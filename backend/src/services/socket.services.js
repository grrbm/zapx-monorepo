import jwt from 'jsonwebtoken';
import db from '../db.js';
import { CallStatus } from '@prisma/client';
let onlineUsers = [];

const authenticateSocket = async (socket, next) => {
  const token = socket?.handshake?.auth?.token;
  if (!token) {
    return next(new Error('Authentication error: No token provided'));
  }
  try {
    const decoded = jwt.verify(token, process?.env?.TOKEN_SECRET);

    socket.user = { userId: decoded?.id };

    const findUser = await db.user.findFirst({
      where: {
        id: socket.user?.userId,
        deleted: false,
      },
    });

    if (findUser) {
      next();
    } else {
      next(new Error('Authentication error: User not found!'));
    }
  } catch (error) {
    console.error('Socket authentication failed:', error.message);
    next(new Error('Authentication error: Invalid token'));
  }
};

const callSocket = async (socketCall) => {
  socketCall.use(authenticateSocket).on('connection', async (socket) => {
    const { userId } = socket?.user;

    const userIndex = onlineUsers?.findIndex((user) => user.userId === userId);

    if (userIndex !== -1) {
      // Update the socketId for the existing user
      onlineUsers[userIndex].socketId = socket?.id;
    } else {
      // Add the user if not already present
      onlineUsers.push({ userId: userId, socketId: socket?.id });
    }
    console.log('onlineUsers', onlineUsers);

    const findUser = await db.user.findFirst({
      where: {
        id: userId,
        deleted: false,
      },
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
    });

    socket.on('offer', async (data) => {
      try {
        const findOnlineUsers = onlineUsers?.find(
          (user) => user?.userId === +data?.toUserId
        );
        const targetSocketId = findOnlineUsers?.socketId;

        if (targetSocketId) {
          const newCall = await db.call.create({
            data: {
              status: CallStatus.MISSED,
              type: data?.type,
              Caller: { connect: { id: userId } },
              Recipient: { connect: { id: +data.toUserId } },
            },
          });

          socket.to(targetSocketId).emit('offer', {
            offer: data?.offer,
            from: findUser,
            callId: newCall?.id,
          });

          console.log(`Offer sent from ${findUser?.id} to ${data.toUserId}`);
        } else {
          console.log(`User ${data.toUserId} not found or not connected`);
        }
      } catch (error) {
        console.error('Error handling offer:', error.message);
      }
    });

    // Handle call start
    socket.on('call-started', async (data) => {
      try {
        const { toUserId, callId, answer } = data;
        const recipient = await db.user.findFirst({ where: { id: +toUserId } });

        if (!recipient) {
          console.log(`Recipient ${toUserId} not found.`);
          return;
        }

        const call = await db.call.update({
          where: {
            id: +callId,
          },
          data: {
            status: CallStatus.PICKED,
            startTime: new Date(),
          },
        });

        const findOnlineUsers = onlineUsers.find(
          (user) => user?.userId === recipient?.id
        );
        const targetSocketId = findOnlineUsers?.socketId;

        socket.to(targetSocketId).emit('call-started', {
          from: findUser,
          callId: call?.id,
          answer,
        });

        console.log(`Call started between ${findUser?.id} and ${toUserId}`);
      } catch (error) {
        console.error('Error handling call start:', error.message);
      }
    });

    socket.on('connection-established', (data) => {
      try {
        const targetSocketId = onlineUsers?.find(
          (user) => user?.userId === +data?.with
        )?.socketId;

        const currentSocketId = onlineUsers?.find(
          (user) => user?.userId === +socket.user?.userId
        )?.socketId;

        if (targetSocketId) {
          // Notify the other user
          socket.to(targetSocketId).emit('connection-established', {
            with: socket?.user?.userId,
          });
          // Notify the current user
          socket.to(currentSocketId).emit('connection-established', {
            with: data?.with,
          });
          console.log(
            `Connection established between ${socket.user.userId} and ${data.with}`
          );
        }
      } catch (error) {
        console.error(
          'Error handling connection-established event:',
          error.message
        );
      }
    });

    // Handle call end
    socket.on('call-ended', async ({ callId }) => {
      try {
        const existingCall = await db.call.findFirst({
          where: { id: +callId },
          select: {
            id: true,
            callerId: true,
            recipientId: true,
          },
        });

        if (!existingCall) {
          console.error(`Call with ID ${callId} not found.`);
          return;
        }

        const call = await db.call.update({
          where: { id: +existingCall?.id },
          data: { endTime: new Date() },
        });

        const caller = onlineUsers?.find(
          (user) => user?.userId === +existingCall?.callerId
        );
        const recipient = onlineUsers?.find(
          (user) => user?.userId === +existingCall?.recipientId
        );

        const callerSocketId = caller?.socketId;
        const recipientSocketId = recipient?.socketId;

        socket.to(callerSocketId).emit('call-ended', {
          from: findUser,
        });

        socket.to(recipientSocketId).emit('call-ended', {
          from: findUser,
        });

        console.log(
          `Call ended between ${existingCall?.id} and ${call?.recipientId}`
        );
      } catch (error) {
        console.error('Error handling call end:', error.message);
      }
    });

    // Handle call rejection
    socket.on('call-rejected', async ({ callId }) => {
      try {
        const existingCall = await db.call.findFirst({
          where: { id: +callId },
        });

        if (!existingCall) {
          console.error(`Call with ID ${callId} not found.`);
          return;
        }

        const call = await db.call.update({
          where: { id: +existingCall?.id },
          data: { status: CallStatus.REJECTED },
          include: { Caller: true },
        });

        if (call && call?.Caller && call?.Caller.id) {
          const findOnlineUsers = onlineUsers?.find(
            (user) => user?.userId === call?.Caller.id
          );
          const callerSocketId = findOnlineUsers?.socketId;

          if (callerSocketId) {
            socket.to(callerSocketId).emit('call-rejected', {
              from: findUser,
            });
            console.log(`Call rejected by ${findUser?.id}`);
          }
        }
      } catch (error) {
        console.error('Error handling call rejection:', error.message);
      }
    });

    // Handle ICE candidate
    socket.on('ice-candidate', (data) => {
      const { toUserId } = data;

      const targetSocketId = onlineUsers?.find(
        (user) => user?.userId === +toUserId
      )?.socketId;

      if (targetSocketId) {
        socket
          .to(targetSocketId)
          .emit('ice-candidate', { ...data, from: findUser });
      } else {
        console.log(`User ${toUserId} not found or not connected`);
      }
    });
  });
};

export { callSocket };
