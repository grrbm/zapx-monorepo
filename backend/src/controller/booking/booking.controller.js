import moment from 'moment-timezone';
import db from '../../db.js';
import { BookingStatus, NotificationType, Role } from '@prisma/client';

import { v4 as uuidv4 } from 'uuid';
import { notificationSocket } from '../../../index.js';
import { sendNotification } from '../../utils/sendNotification.utils.js';
import Stripe from 'stripe';
import { getRatesForTimeOnDate } from '../../utils/mergeDat.utils.js';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const createBooking = async (req, res) => {
  try {
    const { image } = req.files;
    const {
      notes,
      startTime,
      endTime,
      date,
      consumerId,
      sellerId,
      description,
      reminderTime,
      location,
      deliveryDate,
    } = req.body;

    // List of required fields
    const requiredFields = {
      description,
      date,
      startTime,
      endTime,
      location,
    };

    // Check for missing fields
    const missingFields = Object?.keys(requiredFields)?.filter(
      (field) => !requiredFields[field]
    );

    if (missingFields?.length > 0) {
      return res.status(400).json({
        message: `The following fields are required: ${missingFields?.join(
          ', '
        )}`,
      });
    }

    if (!sellerId) {
      return res.status(400).json({ message: 'sellerId is required!' });
    }

    const isSeller = await db.seller.findFirst({
      where: { id: +sellerId, deleted: false },
      include: {
        Scheduler: {
          select: {
            SchedulerDate: {
              select: {
                id: true,
                date: true,
                Time: true,
              },
            },
          },
        },
      },
    });

    if (!isSeller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }
    const price = getRatesForTimeOnDate(isSeller, date, startTime, endTime);

    if (!consumerId) {
      return res.status(400).json({ message: 'ConsumerId not found!' });
    }

    const isConsumer = await db.consumer.findFirst({
      where: { deleted: false, id: +consumerId },
    });

    if (!isConsumer) {
      return res.status(400).json({ message: 'Consumer not found!' });
    }

    const existingBookings = await db.booking.findFirst({
      where: {
        sellerId: isSeller?.id,
        status: BookingStatus.AWAITING_CONFIRMATION,
        date: date ? moment(date)?.startOf('day')?.utc() : undefined,
        OR: [
          // Check if the new slot's startTime is within an existing booking
          {
            startTime: {
              lte: moment(startTime)?.utc(),
            },
            endTime: {
              gte: moment(startTime)?.utc(),
            },
          },
          // Check if the new slot's endTime is within an existing booking
          {
            startTime: {
              lte: moment(endTime)?.utc(),
            },
            endTime: {
              gte: moment(endTime)?.utc(),
            },
          },
          // Check if the new booking fully contains an existing booking
          {
            startTime: {
              gte: moment(startTime)?.utc(),
            },
            endTime: {
              lte: moment(endTime)?.utc(),
            },
          },
        ],
      },
    });

    if (existingBookings) {
      return res.status(400).json({
        message: 'Booking time overlaps with an existing booking.',
      });
    }

    const bookingCount = await db.booking.count({
      where: {
        deleted: false,
      },
    });

    const generateReferenceCode = (bookingCount) => {
      const uuid = uuidv4(); // Generate a random UUID
      const numericUuid = uuid.replace(/\D/g, ''); // Remove all non-numeric characters
      const shortNumericUuid = numericUuid.slice(0, 6); // Take the first 6 digits for compactness
      return `#D-${bookingCount + 1}${shortNumericUuid}`;
    };
    // Generate a unique reference code based on booking count
    const referenceCode = generateReferenceCode(bookingCount);
    if (!price) {
      return res
        .status(400)
        .json({ message: 'No Slot for This time not found!' });
    }

    // Create booking data
    const bookingData = {
      Seller: { connect: { id: isSeller?.id } },
      Consumer: { connect: { id: isConsumer?.id } },
      notes,
      bookingReferenceId: referenceCode,
      status: BookingStatus.AWAITING_BOOKING_CONFIRMATION,
      deliveryDate: deliveryDate
        ? moment(deliveryDate)?.endOf('day')?.utc()
        : undefined,
      startTime: startTime ? moment(startTime)?.utc() : undefined,
      endTime: endTime ? moment(endTime)?.utc() : undefined,
      reminderTime: reminderTime ? moment(reminderTime)?.utc() : undefined,
      date: date ? moment(date)?.startOf('day')?.utc() : undefined,
      location,
      description,
      totalPrice: `${price}`,
      ...(image?.length > 0 && {
        ExampleImages: {
          createMany: {
            data: image?.map((img) => ({
              url: img?.path,
              mimeType: img?.mimetype,
            })),
          },
        },
      }),
    };

    const booking = await db.booking.create({ data: bookingData });

    return res.status(200).json({
      booking,
      message: 'Booking created successfully',
    });
  } catch (err) {
    console.log('create booking ', err);
    res.status(500).json({ message: err.message });
  }
};

const createExternalBooking = async (req, res) => {
  try {
    const {
      notes,
      startTime,
      endTime,
      date,
      price,
      sellerId,
      description,
      location,
      deliveryDate,
      clientName,
      consumerEmail,
    } = req.body;

    // List of required fields
    const requiredFields = {
      description,
      date,
      startTime,
      endTime,
      price,
      location,
    };

    // Check for missing fields
    const missingFields = Object?.keys(requiredFields)?.filter(
      (field) => !requiredFields[field]
    );

    if (missingFields.length > 0) {
      return res.status(400).json({
        message: `The following fields are required: ${missingFields.join(
          ', '
        )}`,
      });
    }

    if (!consumerEmail) {
      return res.status(400).json({ message: 'consumerEmail is required!' });
    }

    if (!sellerId) {
      return res.status(400).json({ message: 'sellerId is required!' });
    }

    const isSeller = await db.seller.findFirst({
      where: { id: +sellerId },
    });

    if (!isSeller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    const existingBookings = await db.booking.findFirst({
      where: {
        sellerId: isSeller?.id,
        status: BookingStatus.INPROGRESS,
        date: date ? moment(date)?.startOf('day')?.utc() : undefined,
        OR: [
          // Check if the new slot's startTime is within an existing booking
          {
            startTime: {
              lte: moment(startTime)?.utc(),
            },
            endTime: {
              gte: moment(startTime)?.utc(),
            },
          },
          // Check if the new slot's endTime is within an existing booking
          {
            startTime: {
              lte: moment(endTime)?.utc(),
            },
            endTime: {
              gte: moment(endTime)?.utc(),
            },
          },
          // Check if the new booking fully contains an existing booking
          {
            startTime: {
              gte: moment(startTime)?.utc(),
            },
            endTime: {
              lte: moment(endTime)?.utc(),
            },
          },
        ],
      },
    });

    if (existingBookings) {
      return res.status(400).json({
        message: 'Booking time overlaps with an existing booking.',
      });
    }

    const bookingCount = await db.booking.count({
      where: {
        deleted: false,
      },
    });

    const generateReferenceCode = (bookingCount) => {
      const uuid = uuidv4(); // Generate a random UUID
      const numericUuid = uuid.replace(/\D/g, ''); // Remove all non-numeric characters
      const shortNumericUuid = numericUuid.slice(0, 6); // Take the first 6 digits for compactness
      return `#D-${bookingCount + 1}${shortNumericUuid}`;
    };
    // Generate a unique reference code based on booking count
    const referenceCode = generateReferenceCode(bookingCount);

    // Create booking data
    const bookingData = {
      Seller: { connect: { id: isSeller?.id } },
      notes,
      clientName,
      consumerEmail,
      isExternal: true,
      bookingReferenceId: referenceCode,
      status: BookingStatus.AWAITING_BOOKING_CONFIRMATION,
      deliveryDate: deliveryDate
        ? moment(deliveryDate)?.endOf('day')?.utc()
        : undefined,
      startTime: startTime ? moment(startTime)?.utc() : undefined,
      endTime: endTime ? moment(endTime)?.utc() : undefined,
      date: date ? moment(date)?.startOf('day')?.utc() : undefined,
      location,
      description,
      totalPrice: price,
    };

    await db.booking.create({ data: bookingData });

    return res.status(200).json({
      message: 'Booking created successfully',
    });
  } catch (err) {
    console.log('create booking ', err);
    res.status(500).json({ message: err.message });
  }
};

const bookingConfirmed = async (req, res) => {
  try {
    const { bookingId } = req?.params;
    const { cardId } = req.query;
    const userId = req?.user?.id;

    const existedUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!existedUser) {
      return res.status(400).json({ message: 'User not found!' });
    }

    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        status: {
          in: [
            BookingStatus.AWAITING_BOOKING_CONFIRMATION,
            BookingStatus.OFFER,
          ],
        },
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          select: {
            User: {
              select: { fullName: true },
            },
            userId: true,
          },
        },
        Consumer: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(400).json({ message: 'Booking not found!' });
    }

    await db.booking.update({
      where: {
        id: findBooking?.id,
        deleted: false,
      },
      data: {
        status: BookingStatus.INPROGRESS,
      },
    });

    // check if the user login not sending the notification
    const reciverId = existedUser?.Consumer?.id
      ? findBooking?.Seller?.userId
      : findBooking?.Consumer?.userId;

    // Create a notification in the database
    await sendNotification({
      description: `Your booking has been confirmed with ${findBooking?.Seller?.User?.fullName}`,
      type: NotificationType.BOOKING_CREATED,
      bookingId: findBooking?.id,
      userIds: [reciverId],
      notificationSocket,
    });

    return res.status(200).json({
      message: 'Confirmed  Booking successfully',
    });
  } catch (err) {
    console.log('booking complete', err);
    res.status(500).json({ message: err.message });
  }
};

const getBookings = async (req, res) => {
  try {
    const { startDate, endDate } = req?.query;
    const userId = req?.user?.id;

    if (!startDate || !endDate) {
      return res.status(200).json({
        message: 'start Date and End Date is required',
      });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        role: true,
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (findUser && findUser.role === Role.SELLER && !findUser?.Seller) {
      return res.status(404).json({ message: 'Seller not found' });
    }

    if (findUser && findUser.role === Role.CONSUMER && !findUser?.Consumer) {
      return res.status(404).json({ message: 'Consumer not found' });
    }

    const getBookingbyUser = await db.booking.findMany({
      where: {
        ...(findUser?.Consumer && { consumerId: findUser?.Consumer?.id }),
        ...(findUser?.Seller && { sellerId: findUser?.Seller?.id }),
        ...(startDate &&
          endDate && {
            date: {
              gte: moment(startDate)?.utc()?.startOf('day'),
              lte: moment(endDate)?.utc()?.startOf('day'),
            },
          }),
        deleted: false,
      },
      select: {
        id: true,
        date: true,
        notes: true,
        description: true,
        startTime: true,
        endTime: true,
        totalPrice: true,
        deliveryDate: true,
        status: true,
        location: true,
        reminderTime: true,
        clientName: true,
        bookingReferenceId: true,
        Seller: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        Consumer: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        ExampleImages: {
          select: {
            id: true,
            mimeType: true,
            url: true,
          },
        },
      },
    });

    return res.status(200).json({
      bookings: getBookingbyUser,
    });
  } catch (err) {
    console.log('get bookings', err);
    res.status(500).json({ message: err.message });
  }
};

const updateBookingbyId = async (req, res) => {
  try {
    const { bookingId } = req?.params;
    const { description, notes } = req?.body;
    const { image } = req.files;

    if (!bookingId) {
      return res.status(400).json({ message: 'bookingId is required!' });
    }

    const findBooking = await db.booking.findUnique({
      where: {
        id: +bookingId,
        deleted: false,
      },
      include: { ExampleImages: { where: { deleted: false } } },
    });

    if (!findBooking) {
      return res.status(400).json({
        message: 'Booking  not found!',
      });
    }

    if (image?.length > 0 && findBooking?.ExampleImages?.length > 0) {
      const images = await db.file.deleteMany({
        where: {
          id: { in: findBooking?.ExampleImages?.map((img) => img?.id) },
        },
      }); // delete old images
    }

    await db.booking.update({
      where: { id: findBooking?.id, deleted: false },
      data: {
        description,
        notes,
        ...(image?.length > 0 && {
          ExampleImages: {
            createMany: {
              data: image?.map((img) => ({
                url: img?.path,
                mimeType: img?.mimetype,
              })),
            },
          },
        }),
      },
    });
    return res.status(200).json({
      message: 'Booking updated successfully',
    });
  } catch (err) {
    console.log('update booking by Id ', err);
    res.status(500).json({ message: err.message });
  }
};

const getBookingbyId = async (req, res) => {
  try {
    const { bookingId } = req?.params;

    if (!bookingId) {
      return res.status(400).json({ message: 'bookingId is required!' });
    }

    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        deleted: false,
      },
      select: {
        id: true,
        date: true,
        notes: true,
        description: true,
        startTime: true,
        endTime: true,
        totalPrice: true,
        status: true,
        location: true,
        deliveryDate: true,
        reminderTime: true,
        clientName: true,
        bookingReferenceId: true,
        Seller: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        Consumer: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        ExampleImages: {
          select: {
            id: true,
            mimeType: true,
            url: true,
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(400).json({
        message: 'Booking  not found!',
      });
    }

    return res.status(200).json({
      booking: findBooking,
    });
  } catch (err) {
    console.log('get booking by Id ', err);
    res.status(500).json({ message: err.message });
  }
};

const getBookingOrder = async (req, res) => {
  try {
    const { filterStatus } = req.query;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        role: true,
        id: true,
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (findUser?.role === Role.SELLER && !findUser.Seller) {
      return res.status(404).json({ message: 'Seller not found' });
    }

    if (findUser?.role === Role.CONSUMER && !findUser.Consumer) {
      return res.status(404).json({ message: 'Consumer not found' });
    }

    let applyFilter = [];

    if (filterStatus === 'COMPLETE') {
      applyFilter = [BookingStatus.CONFIRMED];
    } else if (
      filterStatus === 'OUTSTANDING' ||
      filterStatus === 'INPROGRESS'
    ) {
      applyFilter = [BookingStatus.INPROGRESS];
    }

    const count = await db.booking.count({
      where: {
        ...(findUser?.Consumer && { consumerId: findUser?.Consumer?.id }),
        ...(findUser?.Seller && { sellerId: findUser?.Seller?.id }),
        status: {
          in: applyFilter,
        },
        deleted: false,
      },
    });

    const findBooking = await db.booking.findMany({
      where: {
        ...(findUser?.Consumer && { consumerId: findUser?.Consumer?.id }),
        ...(findUser?.Seller && { sellerId: findUser?.Seller?.id }),
        status: {
          in: applyFilter,
        },
        deleted: false,
      },
      skip: skip,
      take: take,
      select: {
        id: true,
        deliveryDate: true,
        clientName: true,
        status: true,
        description: true,
        notes: true,
        startTime: true,
        endTime: true,
        location: true,
        Consumer: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        Seller: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    return res.status(200).json({
      bookings: findBooking,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log('get outstanding bookings', err);
    res.status(500).json({ message: err.message });
  }
};

const deliveredBooking = async (req, res) => {
  try {
    const { bookingId } = req?.params;
    const { image } = req.files;
    const { message } = req.body;

    const userId = req?.user?.id;

    const existedUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!existedUser) {
      return res.status(400).json({ message: 'User not found!' });
    }

    if (!image || image?.length === 0) {
      return res.status(400).json({
        message: 'Images required',
      });
    }

    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        status: BookingStatus.INPROGRESS,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          select: {
            userId: true,
          },
        },
        Seller: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(404).json({ message: 'Booking not found!' });
    }

    await db.booking.update({
      where: {
        id: findBooking?.id,
        deleted: false,
      },
      data: {
        message,
        status: BookingStatus.PENDING,
        ...(image?.length > 0 && {
          DeliverImages: {
            createMany: {
              data: image?.map((img) => ({
                url: img?.path,
                mimeType: img?.mimetype,
              })),
            },
          },
        }),
      },
    });

    // check if the user login not sending the notification
    const reciverId = existedUser?.Consumer?.id
      ? findBooking?.Seller?.userId
      : findBooking?.Consumer?.userId;

    // Create a notification for the consumer
    await sendNotification({
      description: `Your booking (ID: ${findBooking?.id}) has been delivered and is pending confirmation.`,
      type: NotificationType.BOOKING_CONFIRMED,
      bookingId: findBooking?.id,
      userIds: [reciverId],
      notificationSocket,
    });

    return res.status(200).json({
      message: 'Delivered  Booking successfully',
    });
  } catch (err) {
    console.log('delivered booking ', err);
    res.status(500).json({ message: err.message });
  }
};

const getDeliveredBooking = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (findUser && !findUser?.Seller) {
      return res.status(404).json({ message: 'Seller not found' });
    }

    if (findUser && !findUser?.Consumer) {
      return res.status(404).json({ message: 'Consumer not found' });
    }

    const count = await db.booking.count({
      where: {
        ...(findUser?.Consumer && { consumerId: findUser?.Consumer?.id }),
        ...(findUser?.Seller && { sellerId: findUser?.Seller?.id }),
        status: BookingStatus.PENDING,
        deleted: false,
      },
    });

    const findDeliveredBooking = await db.booking.findMany({
      where: {
        ...(findUser?.Consumer && { consumerId: findUser?.Consumer?.id }),
        ...(findUser?.Seller && { sellerId: findUser?.Seller?.id }),
        status: BookingStatus.PENDING,
        deleted: false,
      },
      skip: +skip,
      take: +take,
      select: {
        id: true,
        deliveryDate: true,
        clientName: true,
        status: true,
        message: true,
        DeliverImages: {
          select: {
            id: true,
            mimeType: true,
            url: true,
          },
        },
        Consumer: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
              },
            },
          },
        },
        Seller: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
              },
            },
          },
        },
      },
    });

    return res.status(200).json({
      bookings: findDeliveredBooking,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log('get delivered booking', err);
    res.status(500).json({ message: err.message });
  }
};

const bookingComplete = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const { bookingId } = req?.params;

    if (!bookingId) {
      return res.status(400).json({ message: 'Booking ID is required!' });
    }

    // Fetch the booking with specified conditions
    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        status: {
          in: [
            BookingStatus.PENDING,
            BookingStatus.AWAITING_BOOKING_CONFIRMATION,
          ],
        },
        deleted: false,
      },
      select: {
        id: true,
        totalPrice: true,
        isExternal: true,
        Consumer: {
          select: {
            userId: true,
          },
        },
        Seller: {
          select: {
            userId: true,
            BankDetail: {
              select: {
                stripeBankAccountId: true,
              },
            },
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(400).json({ message: 'Booking not found!' });
    }

    // Fetch the user with specified conditions
    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        role: true,
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(404).json({ message: 'User not found!' });
    }

    // Update the booking status based on conditions
    if (
      findUser?.role === Role.SELLER &&
      findBooking?.isExternal &&
      !findBooking?.Consumer?.userId
    ) {
      await db.booking.update({
        where: { id: findBooking?.id },
        data: { status: BookingStatus.CONFIRMED },
      });
    } else if (findUser.role === Role.CONSUMER) {
      await db.booking.update({
        where: { id: findBooking?.id },
        data: { status: BookingStatus.CONFIRMED },
      });
    } else {
      return res
        .status(400)
        .json({ message: 'Booking cannot be confirmed for this user!' });
    }

    // check if the user login not sending the notification
    const reciverId = findUser?.Consumer?.id
      ? findBooking?.Seller?.userId
      : findBooking?.Consumer?.userId;

    const originalAmount = +findBooking.totalPrice * 100; // Original amount in cents ($100)
    const feePercentage = 0.08; // 8% fee
    const transferAmount = originalAmount - originalAmount * feePercentage;

    const bankAccountId = findBooking?.Seller?.BankDetail?.stripeBankAccountId;
    const stripeBankAccount = await stripe.accounts.retrieve(bankAccountId);
    // console.log('stripeBankAccount ===>>>', stripeBankAccount);

    // send funds to SELLER after deducting 8%
    await stripe.transfers.create({
      amount: transferAmount, // Amount in cents ($80)
      // currency: stripeBankAccount.default_currency,
      currency: 'usd',
      destination: findBooking?.Seller?.BankDetail?.stripeBankAccountId, // Connected account ID
    });

    // Create a notification
    await sendNotification({
      description: `Booking (ID: ${findBooking?.id}) completed successfully.`,
      type: NotificationType.BOOKING_CONFIRMED,
      bookingId: findBooking?.id,
      userIds: [reciverId],
      notificationSocket,
    });

    // Successful response
    return res.status(200).json({
      message: 'Booking completed successfully!',
    });
  } catch (err) {
    console.error('Error in bookingComplete:', err);
    return res.status(500).json({ message: 'An unexpected error occurred!' });
  }
};

const getDeliveredPictures = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (findUser && !findUser.Consumer) {
      return res.status(404).json({ message: 'User not found' });
    }

    const count = await db.booking.count({
      where: {
        consumerId: findUser?.Consumer?.id,
        status: BookingStatus.CONFIRMED,
        deleted: false,
      },
    });

    const getBookingbyUser = await db.booking.findMany({
      where: {
        consumerId: findUser.Consumer.id,
        status: BookingStatus.CONFIRMED,
        deleted: false,
      },
      skip: +skip,
      take: +take,
      select: {
        id: true,
        DeliverImages: {
          select: {
            id: true,
            mimeType: true,
            url: true,
          },
        },
      },
    });

    res.status(200).json({
      deliveredImages: getBookingbyUser,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log(' get delivered pictures', err);
    res.status(500).json({ message: err.message });
  }
};

const bookingCanceled = async (req, res) => {
  try {
    const { bookingId } = req?.params;
    const userId = req?.user?.id;

    const existedUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!existedUser) {
      return res.status(400).json({ message: 'User not found!' });
    }

    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        status: BookingStatus.INPROGRESS,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          select: {
            userId: true,
          },
        },
        Seller: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(400).json({ message: 'Booking not found!' });
    }

    await db.booking.update({
      where: {
        id: findBooking?.id,
        deleted: false,
      },
      data: {
        status: BookingStatus.CANCELED,
      },
    });

    // check if the user login not sending the notification
    const reciverId = existedUser?.Consumer?.id
      ? findBooking?.Seller?.userId
      : findBooking?.Consumer?.userId;

    // Create a notification for the cancellation
    await sendNotification({
      description: `Booking (ID: ${findBooking?.id}) has been canceled.`,
      type: NotificationType.BOOKING_CANCELED,
      bookingId: findBooking?.id,
      userIds: [reciverId],
      notificationSocket,
    });

    return res.status(200).json({
      message: 'Booking canceled successfully.',
    });
  } catch (err) {
    console.log('booking  canceled', err);
    res.status(500).json({ message: err.message });
  }
};

const createOffer = async (req, res) => {
  try {
    const { image } = req.files;
    const {
      notes,
      startTime,
      endTime,
      date,
      consumerId,
      price,
      sellerId,
      description,
      location,
      deliveryDate,
    } = req.body;

    if (!sellerId) {
      return res.status(400).json({ message: 'sellerId is required!' });
    }

    // Check if seller exists
    const isSeller = await db.seller.findFirst({
      where: { id: +sellerId, deleted: false },
    });

    if (!isSeller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    const isConsumer = await db.consumer.findFirst({
      where: { id: +consumerId, deleted: false },
      select: { userId: true, id: true },
    });

    if (!isConsumer) {
      return res.status(400).json({ message: 'Consumer not found!' });
    }

    const existingBookings = await db.booking.findFirst({
      where: {
        Seller: { id: +isSeller.id, deleted: false },
        deleted: false,
        date: date ? moment(date)?.startOf('day')?.utc() : undefined,
        OR: [
          // Check if the new slot's startTime is within an existing booking
          {
            startTime: {
              lte: moment(startTime)?.utc(),
            },
            endTime: {
              gte: moment(startTime)?.utc(),
            },
          },
          // Check if the new slot's endTime is within an existing booking
          {
            startTime: {
              lte: moment(endTime)?.utc(),
            },
            endTime: {
              gte: moment(endTime)?.utc(),
            },
          },
          // Check if the new booking fully contains an existing booking
          {
            startTime: {
              gte: moment(startTime)?.utc(),
            },
            endTime: {
              lte: moment(endTime)?.utc(),
            },
          },
        ],
      },
    });

    if (existingBookings) {
      return res.status(400).json({
        message: 'Booking time overlaps with an existing booking.',
      });
    }

    const bookingCount = await db.booking.count({
      where: {
        deleted: false,
      },
    });

    const generateReferenceCode = (bookingCount) => {
      const uuid = uuidv4(); // Generate a random UUID
      const numericUuid = uuid.replace(/\D/g, ''); // Remove all non-numeric characters
      const shortNumericUuid = numericUuid.slice(0, 6); // Take the first 6 digits for compactness
      return `#D-${bookingCount + 1}${shortNumericUuid}`;
    };

    // Generate a unique reference code based on booking count
    const referenceCode = generateReferenceCode(bookingCount);

    // Create booking data
    const bookingData = {
      Seller: { connect: { id: isSeller?.id } },
      Consumer: { connect: { id: isConsumer?.id } },
      notes,
      bookingReferenceId: referenceCode,
      status: BookingStatus.OFFER,
      deliveryDate: deliveryDate
        ? moment(deliveryDate)?.endOf('day')?.utc()
        : undefined,
      startTime: startTime ? moment(startTime)?.utc() : undefined,
      endTime: endTime ? moment(endTime)?.utc() : undefined,
      date: date ? moment(date)?.startOf('day')?.utc() : undefined,
      location,
      description,
      totalPrice: price,
      ...(image?.length > 0 && {
        ExampleImages: {
          createMany: {
            data: image?.map((img) => ({
              url: img?.path,
              mimeType: img?.mimetype,
            })),
          },
        },
      }),
    };

    const booking = await db.booking.create({ data: bookingData });

    // Create notification
    await sendNotification({
      description: `An offer (ID: ${booking?.id}) has been created for you.`,
      type: NotificationType.BOOKING_CREATED,
      bookingId: booking?.id,
      userIds: [isConsumer?.userId],
      notificationSocket,
    });

    return res.status(200).json({
      message: 'Offer created successfully',
    });
  } catch (err) {
    console.log('create  offer ', err);
    res.status(500).json({ message: err.message });
  }
};

const getOffers = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const startTime = req?.query?.startTime;
    const endTime = req?.query?.endTime;
    const date = req?.query?.date;

    // Check if seller exists
    const isUser = await db.user.findFirst({
      where: { id: +userId, deleted: false },
      select: {
        id: true,
        Seller: { where: { deleted: false } },
        Consumer: { where: { deleted: false } },
      },
    });

    if (!isUser) {
      return res.status(400).json({ message: 'User not found!' });
    }

    const offers = await db.booking.findMany({
      where: {
        deleted: false,
        status: BookingStatus.OFFER,
        ...(isUser?.role === Role.SELLER && {
          Seller: { deleted: false, id: isUser?.Seller?.id },
        }),
        ...(isUser?.role === Role.CONSUMER && {
          Consumer: { deleted: false, id: isUser?.Consumer?.id },
        }),

        date: date ? moment(date)?.startOf('day')?.utc() : undefined,
        ...(endTime &&
          startTime && {
            OR: [
              // Check if the new slot's startTime is within an existing booking
              {
                startTime: {
                  lte: moment(startTime)?.utc(),
                },
                endTime: {
                  gte: moment(startTime)?.utc(),
                },
              },
              // Check if the new slot's endTime is within an existing booking
              {
                startTime: {
                  lte: moment(endTime)?.utc(),
                },
                endTime: {
                  gte: moment(endTime)?.utc(),
                },
              },
              // Check if the new booking fully contains an existing booking
              {
                startTime: {
                  gte: moment(startTime)?.utc(),
                },
                endTime: {
                  lte: moment(endTime)?.utc(),
                },
              },
            ],
          }),
      },
      select: {
        id: true,
        description: true,
        notes: true,
        message: true,
        date: true,
        deliveryDate: true,
        startTime: true,
        endTime: true,
        stripePaymentIntentId: true,
        totalPrice: true,
        clientName: true,
        location: true,
        consumerEmail: true,
        reminderTime: true,
        bookingReferenceId: true,
        createdAt: true,
        Seller: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
        Consumer: {
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    return res.status(200).json({
      offers,
    });
  } catch (err) {
    console.log('get  offer ', err);
    res.status(500).json({ message: err.message });
  }
};

const getOfferById = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const offerId = req?.params?.offerId;

    // Check if seller exists
    const isUser = await db.user.findFirst({
      where: { id: +userId, deleted: false },
      select: {
        id: true,
        Seller: { where: { deleted: false } },
        Consumer: { where: { deleted: false } },
      },
    });

    if (!isUser) {
      return res.status(400).json({ message: 'User not found!' });
    }
    if (!offerId) {
      return res.status(400).json({ message: 'offerId is required!' });
    }

    const offer = await db.booking.findUnique({
      where: {
        deleted: false,
        id: +offerId,
        status: BookingStatus.OFFER,
        ...(isUser?.role === Role.SELLER && {
          Seller: { deleted: false, id: isUser?.Seller?.id },
        }),
        ...(isUser?.role === Role.CONSUMER && {
          Consumer: { deleted: false, id: isUser?.Consumer?.id },
        }),
      },
      select: {
        description: true,
        notes: true,
        message: true,
        date: true,
        deliveryDate: true,
        startTime: true,
        endTime: true,
        stripePaymentIntentId: true,
        totalPrice: true,
        clientName: true,
        location: true,
        consumerEmail: true,
        reminderTime: true,
        bookingReferenceId: true,
        Seller: true,
        Consumer: true,
      },
    });

    return res.status(200).json({
      offer,
    });
  } catch (err) {
    console.log('get offer by ID: ', err);
    res.status(500).json({ message: err.message });
  }
};

const offerDeclined = async (req, res) => {
  try {
    const { bookingId } = req?.params;
    const userId = req?.user?.id;

    const existedUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        Seller: {
          select: {
            id: true,
          },
        },
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!existedUser) {
      return res.status(400).json({ message: 'User not found!' });
    }

    const findBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        status: BookingStatus.OFFER,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          where: { deleted: false },
          select: {
            userId: true,
          },
        },
        Seller: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!findBooking) {
      return res.status(400).json({ message: 'Booking not found!' });
    }

    await db.booking.update({
      where: {
        id: findBooking?.id,
        deleted: false,
      },
      data: {
        status: BookingStatus.DECLINED,
      },
    });

    // check if the user login not sending the notification
    const reciverId = existedUser?.Consumer?.id
      ? findBooking?.Seller?.userId
      : findBooking?.Consumer?.userId;

    // Create notification
    await sendNotification({
      description: `The offer for booking (ID: ${findBooking?.id}) has been declined.`,
      type: NotificationType.OFFER_DECLINED,
      bookingId: findBooking?.id,
      userIds: [reciverId],
      notificationSocket,
    });

    return res.status(200).json({
      message: 'Booking declined successfully.',
    });
  } catch (err) {
    console.log('offer declined', err);
    res.status(500).json({ message: err.message });
  }
};

const getPeopleBooked = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;
    const date = req?.query?.date;

    if (!date) {
      return res.status(404).json({ message: 'Date is required' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    const isSeller = await db.seller.findFirst({
      where: { id: findUser.Seller.id, deleted: false },
    });

    if (!isSeller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    const count = await db.booking.count({
      where: {
        ...(isSeller && { sellerId: isSeller.id }),
        ...(date && { date: moment(date)?.startOf('day')?.utc() }),
        status: {
          in: [BookingStatus.PENDING, BookingStatus.INPROGRESS],
        },
        deleted: false,
      },
    });

    const bookings = await db.booking.findMany({
      where: {
        deleted: false,
        ...(isSeller && { sellerId: isSeller?.id }),
        ...(date && { date: moment(date)?.startOf('day')?.utc() }),
        status: {
          in: [BookingStatus.PENDING, BookingStatus.INPROGRESS],
        },
        deleted: false,
      },
      skip: +skip,
      take: +take,
      select: {
        id: true,
        clientName: true,
        status: true,
        date: true,
        description: true,
        notes: true,
        startTime: true,
        endTime: true,
        location: true,
        Consumer: {
          where: { deleted: false },
          select: {
            id: true,
            User: {
              select: {
                id: true,
                fullName: true,
                ProfileImage: {
                  select: {
                    id: true,
                    mimeType: true,
                    url: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    return res.status(200).json({
      bookings,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log('get people booked', err);
    res.status(500).json({ message: err.message });
  }
};

export {
  createBooking,
  getBookings,
  getBookingbyId,
  getBookingOrder,
  deliveredBooking,
  getDeliveredBooking,
  bookingComplete,
  getDeliveredPictures,
  bookingCanceled,
  createOffer,
  offerDeclined,
  getPeopleBooked,
  bookingConfirmed,
  createExternalBooking,
  getOffers,
  getOfferById,
  updateBookingbyId,
};
