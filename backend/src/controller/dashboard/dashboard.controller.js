import moment from 'moment-timezone';
import db from '../../db.js';

const weeklyInsight = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;

    const timeZone = 'America/New_York'; // Change this to your preferred timezone

    // Get start and end of the current week in the specified timezone
    const startOfWeekDate = moment().tz(timeZone).startOf('week').toDate();
    const endOfWeekDate = moment().tz(timeZone).endOf('week').toDate();

    const bookings = await db.booking.findMany({
      where: {
        Seller: { User: { deleted: false, id: userId } },
        deleted: false,
        date: {
          gte: startOfWeekDate,
          lte: endOfWeekDate,
        },
        status: 'CONFIRMED',
      },
      select: {
        id: true,
        startTime: true,
        endTime: true,
        totalPrice: true,
      },
    });

    // Total count of bookings
    const totalBookings = bookings.length;

    // Calculate total booked hours and revenue
    let totalHours = 0;
    let totalRevenue = 0;

    bookings?.forEach((booking) => {
      const start = moment(booking?.startTime).tz(timeZone);
      const end = moment(booking?.endTime).tz(timeZone);
      const hours = end.diff(start, 'hours', true); // Get difference in hours
      totalHours += hours;
      totalRevenue += parseFloat(booking.totalPrice); // Assuming totalPrice is stored as a string
    });

    return res
      .status(200)
      .json({ insight: { totalBookings, totalHours, totalRevenue } });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const dailyRevenue = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;

    const timeZone = 'America/New_York'; // Change this to your preferred timezone

    // Get start and end of the current week in the specified timezone
    const startOfWeekDate = moment().tz(timeZone).startOf('day').toDate();
    const endOfWeekDate = moment().tz(timeZone).endOf('day').toDate();

    const bookings = await db.booking.findMany({
      where: {
        Seller: { User: { deleted: false, id: userId } },
        deleted: false,
        date: {
          gte: startOfWeekDate,
          lte: endOfWeekDate,
        },
        status: 'CONFIRMED',
      },
      select: {
        id: true,
        totalPrice: true,
      },
    });

    let totalRevenue = 0;

    bookings?.forEach((booking) => {
      totalRevenue += parseFloat(booking.totalPrice); // Assuming totalPrice is stored as a string
    });
    return res.status(200).json({ totalRevenue });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const CompletedAppointments = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;
    const timeZone = 'America/New_York'; // Adjust based on requirement

    // Get the start and end of the current week in UTC
    const startOfWeekDate = moment().tz(timeZone).startOf('week').toISOString();
    const endOfWeekDate = moment().tz(timeZone).endOf('week').toISOString();

    // Raw SQL query to aggregate the required data
    const bookings = await db.$queryRaw`
      SELECT 
        EXTRACT(DOW FROM "Booking"."date") AS "dayOfWeek",
        "Booking"."status",
        COUNT(*)::int AS "bookingcount"
      FROM "Booking"
      INNER JOIN "Seller" ON "Booking"."sellerId" = "Seller"."id"
      INNER JOIN "User" ON "Seller"."userId" = "User"."id"
      WHERE "Booking"."date" BETWEEN ${startOfWeekDate}::TIMESTAMP AND ${endOfWeekDate}::TIMESTAMP
        AND "Booking"."deleted" = false
        AND "Booking"."status" = 'CONFIRMED'
        AND "User"."id" = ${userId}  -- Ensure the booking belongs to the authenticated user
      GROUP BY "dayOfWeek", "Booking"."status"
      ORDER BY "dayOfWeek";
    `;

    return res.status(200).json(bookings);
  } catch (err) {
    console.error('Error fetching data:', err);
    res.status(500).json({ message: err.message });
  }
};

const todaySchedule = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;

    const timeZone = 'America/New_York'; // Change this to your preferred timezone

    // Get start and end of the current week in the specified timezone
    const startOfWeekDate = moment().tz(timeZone).startOf('day').toDate();
    const endOfWeekDate = moment().tz(timeZone).endOf('day').toDate();

    const bookings = await db.booking.findMany({
      where: {
        Seller: { User: { deleted: false, id: userId } },
        deleted: false,
        date: {
          gte: startOfWeekDate,
          lte: endOfWeekDate,
        },
        status: { notIn: ['AWAITING_BOOKING_CONFIRMATION'] },
      },
      select: {
        id: true,
        startTime: true,
        endTime: true,
        clientName: true,
        location: true,
      },
    });

    return res.status(200).json({ bookings });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
export { weeklyInsight, CompletedAppointments, dailyRevenue, todaySchedule };
