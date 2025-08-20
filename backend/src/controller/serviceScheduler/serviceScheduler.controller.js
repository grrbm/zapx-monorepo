import moment from 'moment-timezone';
import db from '../../db.js';
import { BookingStatus } from '@prisma/client';
import { mergeDateAndTime } from '../../utils/mergeDat.utils.js';

const getAllServiceScheduler = async (req, res) => {
  try {
    const {
      minimumRate,
      maximumRate,
      categoryId,
      serviceType,
      locationTypeId,
    } = req?.query;
    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;

    // Parse serviceType safely
    let parsedServiceType = [];
    if (typeof serviceType === 'string') {
      try {
        const parseArray = JSON.parse(serviceType);
        if (Array.isArray(parseArray)) {
          parsedServiceType = parseArray;
        }
      } catch (err) {
        console.log('Error:', err);
      }
    }

    const count = await db.scheduler.count({
      where: {
        ...((minimumRate || maximumRate) && {
          SchedulerDate: {
            some: {
              Time: {
                some: {
                  rate: {
                    ...(minimumRate && { gte: +minimumRate }),
                    ...(maximumRate && { lte: +maximumRate }),
                  },
                },
              },
            },
          },
        }),
        ...(categoryId && { categoryId: +categoryId }),
        ...(parsedServiceType.length > 0 && {
          Services: {
            some: {
              deleted: false,
              id: {
                in: parsedServiceType?.map((item) => item?.id),
              },
            },
          },
        }),
        ...(locationTypeId && {
          Seller: {
            Post: {
              some: {
                deleted: false,
                LocationType: { some: { deleted: false, id: +locationTypeId } },
              },
            },
          },
        }),
        deleted: false,
      },
    });

    const serviceScheduler = await db.scheduler.findMany({
      where: {
        ...((minimumRate || maximumRate) && {
          SchedulerDate: {
            some: {
              Time: {
                some: {
                  rate: {
                    ...(minimumRate && { gte: +minimumRate }),
                    ...(maximumRate && { lte: +maximumRate }),
                  },
                },
              },
            },
          },
        }),
        ...(categoryId && { categoryId: +categoryId }),
        ...(parsedServiceType.length > 0 && {
          Services: {
            some: {
              deleted: false,
              id: {
                in: parsedServiceType?.map((item) => item?.id),
              },
            },
          },
        }),
        ...(locationTypeId && {
          Seller: {
            Post: {
              some: {
                deleted: false,
                LocationType: { some: { deleted: false, id: +locationTypeId } },
              },
            },
          },
        }),
        deleted: false,
      },
      skip,
      take,
      select: {
        id: true,
        Seller: {
          select: {
            id: true,
            aboutMe: true,
            location: true,
            _count: { select: { Review: { where: { deleted: false } } } },
            User: {
              select: {
                id: true,
                fullName: true,
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
        },
        Services: {
          where: { deleted: false },
          select: {
            id: true,
            name: true,
            Category: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
        SchedulerDate: {
          where: { deleted: false },
          select: {
            date: true,
            Time: {
              select: {
                id: true,
                startTime: true,
                endTime: true,
                rate: true,
              },
            },
          },
        },
      },
    });

    await Promise.all(
      serviceScheduler.map(async (serv) => {
        if (serv?.Seller?.id) {
          const reviewAvg = await db.review.aggregate({
            where: { sellerId: serv.Seller.id, deleted: false },
            _avg: { rating: true },
          });
          serv._avg = reviewAvg._avg; // Assign the result to serv._avg
        }
      })
    );

    return res.status(200).json({
      serviceScheduler,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.error('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getAllServiceSchedulerBySellerId = async (req, res) => {
  try {
    const { sellerId } = req?.params;

    if (!sellerId) {
      return res.status(400).json({ message: 'sellerId is required' });
    }

    const sellerServices = await db.seller.findFirst({
      where: {
        id: +sellerId,
        deleted: false,
      },
      select: {
        id: true,
        location: true,
        Scheduler: {
          where: {
            deleted: false,
          },
          select: {
            id: true,

            SchedulerDate: {
              where: { deleted: false },
              select: {
                date: true,
                Time: {
                  select: {
                    id: true,
                    startTime: true,
                    endTime: true,
                    rate: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    if (!sellerServices) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    return res.status(200).json({
      sellerServices,
    });
  } catch (err) {
    console.error('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getAllServiceBySchedulerId = async (req, res) => {
  try {
    const { schedulerId } = req?.params;
    const { viewType } = req?.query;
    const userId = req?.user?.id ? +req.user.id : undefined;
    if (!schedulerId) {
      return res.status(400).json({ message: 'schedulerId is required' });
    }
    const user = await db.user.findFirst({
      where: { id: userId, deleted: false },
      select: {
        role: true,
        Seller: { where: { deleted: false }, select: { id: true } },
        Consumer: { where: { deleted: false }, select: { id: true } },
      },
    });

    const serviceScheduler = await db.scheduler.findFirst({
      where: {
        id: +schedulerId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          select: {
            id: true,
            aboutMe: true,
            location: true,
            ...(viewType === 'PORTFOLIO' && {
              Portfolio: {
                where: { deleted: false },
                select: {
                  id: true,
                  title: true,
                  Images: {
                    select: {
                      id: true,
                      url: true,
                      mimeType: true,
                    },
                  },
                },
              },
            }),
            ...(viewType === 'REVIEWS' && {
              _count: { select: { Review: { where: { deleted: false } } } },
              Review: {
                where: { deleted: false },
                select: {
                  id: true,
                  rating: true,
                  description: true,
                  createdAt: true,
                  Consumer: {
                    where: { deleted: false },
                    select: {
                      id: true,
                      User: {
                        select: {
                          id: true,
                          fullName: true,
                          username: true,
                          email: true,
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
                  },
                },
              },
            }),
            User: {
              select: {
                id: true,
                fullName: true,
                username: true,
                Chat: { where: { deleted: false }, select: { id: true } },
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
        },
        ...(viewType === 'TIMESLOTS' && {
          SchedulerDate: {
            select: {
              date: true,
              Time: {
                select: {
                  id: true,
                  startTime: true,
                  endTime: true,
                  rate: true,
                },
              },
            },
          },
        }),
      },
    });
    if (!serviceScheduler) {
      return res.status(400).json({
        message: `scheduler by schedulerId ${schedulerId} not found!`,
      });
    }
    if (viewType === 'REVIEWS' && serviceScheduler?.Seller?.id) {
      const reverAvg = await db.review.aggregate({
        where: { sellerId: serviceScheduler?.Seller?.id },
        _avg: { rating: true },
      });
      serviceScheduler._avg = reverAvg._avg;
    }
    const FindbookingSellerId = await db.booking.findMany({
      where: {
        sellerId: serviceScheduler?.Seller?.id,
        deleted: false,
        status: BookingStatus.INPROGRESS,
      },
      select: {
        id: true,
        date: true,
        startTime: true,
        endTime: true,
      },
    });

    if (serviceScheduler && serviceScheduler?.SchedulerDate) {
      serviceScheduler.SchedulerDate = serviceScheduler?.SchedulerDate.filter(
        (schedulerDate) => {
          const schedulerDateMoment = moment(schedulerDate?.date);
          const schedulerDateStr = schedulerDateMoment?.format('YYYY-MM-DD');

          const hasOverlap = FindbookingSellerId.some((booking) => {
            const bookingDateStr = moment(booking?.date)?.format('YYYY-MM-DD');
            return schedulerDateStr === bookingDateStr;
          });

          if (!hasOverlap) {
            schedulerDate.Time = schedulerDate?.Time?.filter((time) => {
              return !FindbookingSellerId?.some((booking) => {
                const bookingStartTime = moment(booking?.startTime);
                const bookingEndTime = moment(booking?.endTime);
                const timeStartTime = moment(time?.startTime);
                const timeEndTime = moment(time?.endTime);

                // Check for overlap using moment
                return (
                  timeStartTime?.isBefore(bookingEndTime) &&
                  timeEndTime?.isAfter(bookingStartTime)
                );
              });
            });
            return true;
          }
          return false;
        }
      );
    }
    const favourite = await db.favourite.findFirst({
      where: {
        deleted: false,
        ...(user?.role == 'CONSUMER' && {
          Seller: {
            id: serviceScheduler?.Seller?.id,
          },
          Consumer: { id: user?.Consumer?.id },
        }),
      },
    });
    serviceScheduler.Seller.favourite = favourite?.isSaved
      ? favourite?.isSaved
      : false;

    return res.status(200).json({
      serviceScheduler,
    });
  } catch (err) {
    console.error('err', err);
    res.status(500).json({ message: err.message });
  }
};

const createServiceScheduler = async (req, res) => {
  try {
    const { services, schedulerDate, categoryId } = req?.body;
    const userId = req?.user?.id ? +req.user.id : undefined;

    if (
      (services?.length === 0 && schedulerDate?.length === 0) ||
      !categoryId
    ) {
      return res.status(404).json({
        message:
          'Required fields are missing: Please provide services, schedulerDate and time,  CategoryId',
      });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: userId,
        deleted: false,
      },
      select: {
        id: true,
        role: true,
        Seller: {
          select: {
            id: true,
            Scheduler: { where: { deleted: false } },
          },
        },
      },
    });

    // Fix 1: Check if user exists first
    if (!findUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Fix 2: Check if user has a Seller profile
    if (!findUser?.Seller) {
      return res.status(404).json({ message: 'Seller profile not found' });
    }
    console.log({
      sche: findUser?.Seller?.Scheduler,
    });
    // Fix 3: Check if Seller already has a scheduler
    if (findUser?.Seller?.Scheduler) {
      return res
        .status(409) // Changed to 409 Conflict
        .json({ message: 'Seller already has service scheduler' });
    }

    // Fix 4: Ensure sellerId is valid before creating
    const sellerId = findUser.Seller.id;
    if (!sellerId) {
      return res.status(400).json({ message: 'Invalid seller ID' });
    }

    await db.scheduler.create({
      data: {
        sellerId: sellerId, // Direct field assignment instead of connect
        categoryId: +categoryId, // Direct field assignment instead of connect
        Services: {
          connect: services?.map((service) => ({ id: service.id })),
        },
        SchedulerDate: {
          create:
            schedulerDate?.map((schedulerDate) => ({
              date: schedulerDate?.date
                ? moment(schedulerDate.date).startOf('day').utc().toISOString()
                : undefined,
              Time: {
                create: schedulerDate?.times?.map((time) => ({
                  startTime: mergeDateAndTime(
                    schedulerDate?.date,
                    time?.startTime
                  ),
                  endTime: mergeDateAndTime(schedulerDate?.date, time?.endTime),
                  rate: time?.rate,
                })),
              },
            })) || [],
        },
      },
    });

    return res
      .status(201) // Changed to 201 Created
      .json({ message: 'Service scheduler created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const updateServiceScheduler = async (req, res) => {
  try {
    const { services, schedulerDate, categoryId } = req?.body;
    const { id } = req.params;
    const userId = req?.user?.id ? +req.user.id : undefined;
    console.log({ userId, id });
    if (!id) {
      return res
        .status(400)
        .json({ message: 'Scheduler ID is required for update.' });
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
            Scheduler: {
              where: {
                id: +id,
                deleted: false,
              },
              select: { id: true },
            },
          },
        },
      },
    });

    if (!findUser?.Seller || !findUser?.Seller?.Scheduler) {
      return res
        .status(400)
        .json({ message: 'Scheduler not found for this seller.' });
    }
    let formatedDateTime = undefined;
    if (schedulerDate?.length > 0) {
      const schedulerDates = await db.schedulerDate.findMany({
        where: { schedulerId: +id, deleted: false },
        select: { id: true },
      });

      const schedulerDateIds = schedulerDates?.map((d) => d?.id);

      await db.time.deleteMany({
        where: {
          schedulerDateId: {
            in: schedulerDateIds,
          },
        },
      });

      // Delete existing scheduler dates and times (optional based on business logic)
      await db.schedulerDate.deleteMany({
        where: {
          schedulerId: +id,
        },
      });
      formatedDateTime = schedulerDate?.map((schedulerDate) => ({
        date: schedulerDate?.date,

        Time: schedulerDate?.times?.map((time) => ({
          startTime: mergeDateAndTime(schedulerDate?.date, time?.startTime),
          endTime: mergeDateAndTime(schedulerDate?.date, time?.endTime),
          rate: time?.rate,
        })),
      }));
    }

    // Update scheduler
    await db.scheduler.update({
      where: { id: +id },
      data: {
        ...(categoryId && {
          Category: {
            connect: { id: +categoryId },
          },
        }),
        ...(services?.length > 0 && {
          Services: {
            set: [], // remove existing services
            connect: services?.map((service) => ({ id: service.id })),
          },
        }),
        ...(formatedDateTime?.length > 0 && {
          SchedulerDate: {
            create:
              formatedDateTime?.map((schedulerDate) => ({
                date: schedulerDate?.date
                  ? moment(schedulerDate.date)
                      .utc()
                      .startOf('day')
                      .toISOString()
                  : undefined,
                ...(schedulerDate?.Time?.length > 0 && {
                  Time: {
                    create: schedulerDate?.Time?.map((time) => ({
                      startTime: time?.startTime
                        ? moment(time.startTime).utc().toISOString()
                        : undefined,
                      endTime: time?.endTime
                        ? moment(time.endTime).utc().toISOString()
                        : undefined,
                      rate: time?.rate && +time?.rate,
                    })),
                  },
                }),
              })) || [],
          },
        }),
      },
    });

    return res
      .status(200)
      .json({ message: 'Service scheduler updated successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteServiceScheduler = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const schedulerExist = await db.scheduler.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });
    if (!schedulerExist) {
      return res.status(404).json({ message: 'scheduler not found!' });
    }

    await db.scheduler.delete({
      where: {
        id: +id,
        deleted: false,
      },
    });

    return res.status(200).json({ message: 'delete successfully' });
  } catch (err) {
    console.log({ err });
    res.status(500).json({ message: err.message });
  }
};

export {
  createServiceScheduler,
  updateServiceScheduler,
  deleteServiceScheduler,
  getAllServiceScheduler,
  getAllServiceSchedulerBySellerId,
  getAllServiceBySchedulerId,
};
