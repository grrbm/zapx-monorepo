import { NotificationType } from '@prisma/client';
import {
  notificationSocket,
  socketChat,
  socketMessage,
} from '../../../index.js';
import db from '../../db.js';
import { sendNotification } from '../../utils/sendNotification.utils.js';

const createChat = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined; // Logged-in user's ID
    const { receiverId, message } = req?.body; // Target user ID
    const files = req?.files;

    if (!receiverId) {
      return res.status(400).json({ message: 'receiverId is required!' });
    }
    if (!message) {
      return res.status(400).json({ message: 'Message content not found!' });
    }
    // Check if the logged-in user exists and is not deleted
    const userExist = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
    });

    if (!userExist) {
      return res.status(400).json({ message: 'User not found!' });
    }

    // Check if the target user exists and is not deleted
    const targetUserExist = await db.user.findFirst({
      where: {
        id: +receiverId,
        deleted: false,
      },
    });

    if (!targetUserExist) {
      return res.status(400).json({ message: 'Target user not found!' });
    }

    // Check if the logged-in user is trying to create a chat with themselves
    if (userExist?.id === targetUserExist?.id) {
      return res.status(400).json({
        message: 'You cannot create a chat with yourself!',
      });
    }

    // Check if a chat between these two users already exists
    const chatExist = await db.chat.findFirst({
      where: {
        AND: [
          { Users: { some: { deleted: false, id: userExist?.id } } },
          { Users: { some: { deleted: false, id: targetUserExist?.id } } },
        ],
        deleted: false,
      },
    });

    let chat;
    if (chatExist) {
      chat = chatExist;
    } else {
      // Create a new chat if one does not already exist
      chat = await db.chat.create({
        data: {
          Users: {
            connect: [{ id: userExist?.id }, { id: targetUserExist?.id }],
          },
        },
        include: {
          Users: {
            where: { deleted: false },
            select: {
              id: true,
              fullName: true,
              role: true,
              ProfileImage: {
                select: {
                  id: true,
                  url: true,
                  mimeType: true,
                },
              },
            },
          },
        },
      });
    }

    // Create a new message
    const newMessage = await db.message.create({
      data: {
        content: message,
        From: { connect: { id: userExist?.id } },
        Chat: {
          connect: { id: chat?.id },
        },
        SeenBy: { connect: { id: userExist?.id } },
        ...(files?.length > 0 && {
          File: {
            createMany: {
              data: files?.map((file) => ({
                url: file?.path,
                mimeType: file?.mimetype,
              })),
            },
          },
        }),
      },
      include: {
        File: { where: { deleted: false } },
        From: { select: { id: true, fullName: true } },
        Chat: {
          include: {
            Users: {
              where: { deleted: false },
              select: {
                id: true,
                fullName: true,
                role: true,
                ProfileImage: {
                  select: {
                    id: true,
                    url: true,
                    mimeType: true,
                  },
                },
              },
            },
            Message: {
              where: {
                deleted: false,
                SeenBy: { some: { deleted: false, NOT: { id: +receiverId } } },
              },
            },
          },
        },
      },
    });

    // Emit the new message to all chat participants
    const userIds = newMessage?.Chat?.Users?.map((item) => item?.id); // Extract user IDs from the chat

    if (userIds && userIds?.length > 0) {
      for (const userId of userIds) {
        // Emit 'chat' event to each user ID's room
        socketChat.to(userId).emit('newChat', { chat: newMessage?.Chat });
      }
    }

    socketMessage.to(chat?.id).emit('newMessage', newMessage);

    // Check if the receiver is actively viewing the chat
    const isReceiverActive = socketChat?.adapter?.rooms?.has(
      parseInt(receiverId)
    );

    const isMessageUnread = !newMessage?.SeenBy?.some(
      (user) => user?.userId === parseInt(receiverId)
    );

    if (!isReceiverActive && isMessageUnread) {
      // Create and send a notification
      await sendNotification({
        description: `You have a new message from ${userExist?.fullName}`,
        type: NotificationType.MESSAGE_CREATED,
        chatId: chat?.id,
        userIds: [receiverId],
        notificationSocket,
      });
    }

    return res.status(200).json({
      message: 'Message sent successfully!',
    });
  } catch (err) {
    console.error('Error creating chat:', err);
    res
      .status(500)
      .json({ message: 'Internal server error', error: err.message });
  }
};

const getAllChats = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;
    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;
    // Check if the logged-in user exists and is not deleted
    const userExist = await db.user.findFirst({
      where: {
        id: userId,
        deleted: false,
      },
    });

    if (!userExist) {
      return res.status(400).json({ message: 'User not found!' });
    }

    const count = await db.chat.count({
      where: {
        Users: { some: { deleted: false, id: userExist?.id } },
        deleted: false,
      },
    });

    const chats = await db.chat.findMany({
      where: {
        Users: { some: { deleted: false, id: userExist?.id } },
        deleted: false,
      },
      skip,
      take,
      select: {
        id: true,
        Users: {
          where: {
            deleted: false,
          },
          select: {
            id: true,
            fullName: true,
            username: true,
            role: true,
            ProfileImage: {
              select: {
                id: true,
                url: true,
                mimeType: true,
              },
            },
          },
        },
        Message: {
          take: 1,
          orderBy: {
            createdAt: 'desc',
          },
          where: {
            deleted: false,
          },
        },
      },
    });

    // Respond with success message and chat details
    return res.status(200).json({
      chats,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.error('Error get all chats:', err);
    res
      .status(500)
      .json({ message: 'Internal server error', error: err.message });
  }
};

const getChatByChatId = async (req, res) => {
  try {
    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;
    const userId = req?.user?.id;
    const { chatId } = req?.params;

    if (!chatId) {
      return res.status(400).json({ message: 'chatId is required!' });
    }

    const chat = await db.chat.findFirst({
      where: {
        id: +chatId,
        deleted: false,
      },
      select: {
        id: true,
        Users: {
          where: { deleted: false },
          select: {
            id: true,
            fullName: true,
            role: true,
            Seller: { where: { deleted: false }, select: { id: true } },
            Consumer: { where: { deleted: false }, select: { id: true } },
            ProfileImage: {
              where: { deleted: false },
              select: {
                id: true,
                url: true,
                mimeType: true,
              },
            },
          },
        },
        Message: {
          orderBy: {
            createdAt: 'desc',
          },
          where: {
            deleted: false,
          },
          skip,
          take,
          select: {
            id: true,
            content: true,
            createdAt: true,
            File: {
              where: { deleted: false },
              select: {
                id: true,
                url: true,
                mimeType: true,
              },
            },
            SeenBy: {
              where: { deleted: false },
              select: {
                id: true,
                fullName: true,
                role: true,
                ProfileImage: {
                  where: { deleted: false },
                  select: {
                    id: true,
                    url: true,
                    mimeType: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    if (!chat) {
      return res.status(400).json({ message: 'chat not found!' });
    }

    const unSeenMessages = await db.message.findMany({
      where: {
        chatId: +chatId,
        SeenBy: {
          some: {
            deleted: false,
            id: {
              not: +userId,
            },
          },
        },
        deleted: false,
      },
    });

    for (const message of unSeenMessages || []) {
      await db.message.update({
        where: {
          id: message?.id,
          deleted: false,
        },
        data: {
          SeenBy: {
            connect: { id: +userId },
          },
        },
      });
    }

    const totalMessages = await db.message.count({
      where: {
        chatId: +chatId,
        deleted: false,
      },
    });

    return res.status(200).json({
      chat,
      count: totalMessages,
    });
  } catch (err) {
    console.error('Error get all chats:', err);
    res
      .status(500)
      .json({ message: 'Internal server error', error: err.message });
  }
};

export { createChat, getAllChats, getChatByChatId };
