import db from '../db.js';

export const sendNotification = async ({
  description,
  type,
  bookingId = null, // Optional for chat-related notifications
  chatId = null, // Optional for booking-related notifications
  userIds,
  notificationSocket,
}) => {
  if (!userIds || userIds?.length === 0) {
    throw new Error('No user IDs provided for the notification.');
  }

  // Create notification in the database
  const notification = await db.notification.create({
    data: {
      description,
      type,
      ...(bookingId && { bookingId: +bookingId }),
      ...(chatId && { chatId: +chatId }),
      Users: {
        connect: userIds?.map((id) => ({ id: +id })),
      },
    },
  });

  // Emit the notification to all relevant socket rooms
  userIds?.forEach((userId) => {
    notificationSocket?.to(parseInt(userId))?.emit('newNotification', {
      id: notification?.id,
      description: notification?.description,
      type: notification?.type,
      createdAt: notification?.createdAt,
    });
  });

  return notification;
};
