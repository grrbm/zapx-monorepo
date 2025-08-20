import db from '../../db.js';

const getAllNotification = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const skip = req?.query?.skip || 0;
    const take = req?.query?.take || 10;

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

    const count = await db.notification.count({
      where: {
        Users: { some: { deleted: false, id: userExist?.id } },
        deleted: false,
      },
    });

    const chats = await db.notification.findMany({
      where: {
        Users: { some: { deleted: false, id: userExist?.id } },
        deleted: false,
      },
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        description: true,
        type: true,
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

const readAllNotification = async (req, res) => {
  try {
    const userId = req?.user?.id;

    if (!userId) {
      return res.status(400).json({ message: 'Id not exist!' });
    }

    const isUser = await db.user.findFirst({
      where: { id: userId, deleted: false },
    });

    if (!isUser) {
      return res.status(400).json({ message: 'User not exist!' });
    }

    const notifications = await db.notification.findMany({
      where: {
        Users: {
          some: {
            deleted: false,
            id: userId,
          },
        },
        SeenBy: null,
        deleted: false,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    if (notifications?.length > 0) {
      const updateNotificatons = notifications?.map((noti) => {
        return db.notification.update({
          where: { id: noti?.id, deleted: false },
          data: {
            SeenBy: {
              connect: {
                id: userId,
              },
            },
          },
        });
      });

      await db.$transaction(updateNotificatons);

      return res
        .status(200)
        .json({ message: 'All notifications marked as read!' });
    } else {
      return res
        .status(200)
        .json({ message: 'There is no notifications to marked as read!' });
    }
  } catch (error) {
    console.log('error in getting slots ===>>>', error);
    return res.status(500).json({ message: 'Internal Server Error!' });
  }
};

export { getAllNotification, readAllNotification };
