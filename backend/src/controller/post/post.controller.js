import moment from 'moment-timezone';
import db from '../../db.js';

const createPost = async (req, res) => {
  try {
    const { image: Images } = req?.files || {};

    const {
      location,
      description,
      notes,
      hourlyRate,
      Time,
      VenueType,
      LocationType,
    } = req.body;

    const userId = req?.user?.id ? +req.user.id : undefined;

    // Validate user ID
    if (!userId) {
      return res
        .status(401)
        .json({ message: 'Unauthorized access. User not logged in.' });
    }

    // Check for required fields
    if (!location || typeof location !== 'string') {
      return res.status(400).json({
        message: 'Location is required and should be a valid string.',
      });
    }

    if (!description || typeof description !== 'string') {
      return res.status(400).json({
        message: 'Description is required and should be a valid string.',
      });
    }

    if (!notes || typeof notes !== 'string') {
      return res
        .status(400)
        .json({ message: 'Notes are required and should be a valid string.' });
    }

    if (!hourlyRate || isNaN(Number(hourlyRate))) {
      return res.status(400).json({
        message: 'Hourly rate is required and should be a valid number.',
      });
    }

    if (!Time) {
      return res.status(400).json({ message: 'Time is required.' });
    }

    if (
      (!VenueType || VenueType.length === 0) &&
      (!LocationType || LocationType.length === 0)
    ) {
      return res.status(400).json({
        message: 'At least one of VenueType or LocationType is required.',
      });
    }

    if (!Images || Images?.length === 0) {
      return res.status(400).json({ message: 'Images are required!' });
    }

    // Parse and validate JSON fields
    let parseLocationType, parseVenueType, parseTime;
    try {
      parseLocationType = LocationType && JSON.parse(LocationType);
      parseVenueType = VenueType && JSON.parse(VenueType);
      parseTime = Time && JSON.parse(Time);
    } catch (error) {
      return res.status(400).json({
        message: 'Invalid JSON format in LocationType, VenueType, or Time.',
      });
    }

    const isLocationValid =
      Array.isArray(parseLocationType) && parseLocationType.length > 0;
    const isVenueValid =
      Array.isArray(parseVenueType) && parseVenueType.length > 0;

    if (!isLocationValid && !isVenueValid) {
      return res.status(400).json({
        message:
          'At least one of LocationType or VenueType must be a non-empty array.',
      });
    }
    if (!Array.isArray(parseTime) || parseTime?.length === 0) {
      return res
        .status(400)
        .json({ message: 'Time must be a non-empty array.' });
    }

    // Format and validate Time objects
    const formattedTime = parseTime?.map((time) => {
      if (!time?.startTime || !time?.endTime) {
        throw new Error('Each Time entry must include startTime and endTime.');
      }
      return {
        startTime: moment(time?.startTime).utc(),
        endTime: moment(time?.endTime).utc(),
      };
    });

    // Validate Seller existence or get user role
    const user = await db.user.findFirst({
      where: { id: userId, deleted: false },
      include: { Seller: true }
    });

    if (!user) {
      return res.status(400).json({ message: 'User not found!' });
    }

    let existSeller = user.Seller;

    // If user is ADMIN but doesn't have a Seller profile, create one
    if (!existSeller && user.role === 'ADMIN') {
      // Get a default category (Photography)
      const defaultCategory = await db.category.findFirst({
        where: { name: 'Photography', deleted: false }
      });

      if (defaultCategory) {
        existSeller = await db.seller.create({
          data: {
            userId: userId,
            categoryId: defaultCategory.id,
            aboutMe: 'Admin user',
            location: 'Admin location'
          }
        });
      }
    }

    if (!existSeller) {
      return res.status(400).json({ message: 'Seller profile not found. Please contact support.' });
    }

    // Create post in database
    await db.post.create({
      data: {
        Seller: { connect: { id: existSeller?.id } },
        ...(parseLocationType?.length > 0 && {
          LocationType: {
            connect: parseLocationType?.map((type) => ({
              id: type?.id,
            })),
          },
        }),
        ...(parseVenueType?.length > 0 && {
          VenueType: {
            connect: parseVenueType?.map((type) => ({
              id: type?.id,
            })),
          },
        }),
        Time: {
          create: formattedTime?.map((time) => ({
            startTime: time?.startTime,
            endTime: time?.endTime,
          })),
        },
        notes,
        description,
        hourlyRate,
        location,
        ...(Images?.length > 0
          ? {
              Images: {
                createMany: {
                  data: Images?.map((image) => ({
                    url: image?.path,
                    mimeType: image?.mimetype,
                  })),
                },
              },
            }
          : {}),
      },
    });

    return res.status(200).json({ message: 'Post created successfully!' });
  } catch (err) {
    console.error('Post creation error:', err);
    console.error('Stack trace:', err.stack);
    res.status(500).json({ 
      message: err.message || 'Internal server error',
      error: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
  }
};

const getPost = async (req, res) => {
  try {
    const { search, timeFrom, timeTo, locationType, venueType } = req?.query;

    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;

    const startTime = timeFrom ? moment(timeFrom).utc().toDate() : undefined;
    const endTime = timeTo ? moment(timeTo).utc().toDate() : undefined;

    // Parse locationType and venueType as arrays (if passed)
    const locationTypesArray = locationType ? locationType?.split(',') : [];
    const venueTypesArray = venueType ? venueType?.split(',') : [];

    // Build the where clause dynamically
    const whereClause = {
      ...(search
        ? {
            location: {
              contains: search,
              mode: 'insensitive',
            },
          }
        : {}),
      deleted: false,
      ...(startTime && endTime
        ? {
            Time: {
              some: {
                ...(timeFrom
                  ? {
                      startTime: {
                        gte: startTime,
                      },
                    }
                  : {}),
                ...(endTime
                  ? {
                      endTime: {
                        lte: endTime,
                      },
                    }
                  : {}),
              },
            },
          }
        : {}),
      ...(locationTypesArray?.length > 0
        ? {
            LocationType: {
              some: {
                name: {
                  in: locationTypesArray,
                },
              },
            },
          }
        : {}),
      ...(venueTypesArray?.length > 0
        ? {
            VenueType: {
              some: {
                name: {
                  in: venueTypesArray,
                },
              },
            },
          }
        : {}),
    };

    // Count query
    const count = await db.post.count({
      where: whereClause,
    });

    // Find many query
    const posts = await db.post.findMany({
      where: whereClause,
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        Seller: {
          where: { deleted: false, User: { deleted: false } },
          select: {
            id: true,
            Scheduler: { where: { deleted: false }, select: { id: true } },
            User: { select: { id: true } },
          },
        },
        id: true,
        description: true,
        hourlyRate: true,
        location: true,
        notes: true,
        Images: true,
        LocationType: true,
        VenueType: true,
        Time: true,
        Review: true,
      },
    });

    return res.status(200).json({
      posts,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log(' get post ', err);
    res.status(500).json({ message: err.message });
  }
};

const getPostBySellerId = async (req, res) => {
  try {
    const { id } = req?.params;
    const { search, timeFrom, timeTo, locationType, venueType } = req?.query;

    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;

    const startTime = timeFrom ? moment(timeFrom).utc().toDate() : undefined;
    const endTime = timeTo ? moment(timeTo).utc().toDate() : undefined;

    // Parse locationType and venueType as arrays (if passed)
    const locationTypesArray = locationType ? locationType?.split(',') : [];
    const venueTypesArray = venueType ? venueType?.split(',') : [];
    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }
    // Build the where clause dynamically
    const whereClause = {
      ...(search
        ? {
            location: {
              contains: search,
              mode: 'insensitive',
            },
          }
        : {}),
      Seller: { deleted: false, id: +id },
      deleted: false,
      ...(startTime && endTime
        ? {
            Time: {
              some: {
                ...(timeFrom
                  ? {
                      startTime: {
                        gte: startTime,
                      },
                    }
                  : {}),
                ...(endTime
                  ? {
                      endTime: {
                        lte: endTime,
                      },
                    }
                  : {}),
              },
            },
          }
        : {}),
      ...(locationTypesArray?.length > 0
        ? {
            LocationType: {
              some: {
                name: {
                  in: locationTypesArray,
                },
              },
            },
          }
        : {}),
      ...(venueTypesArray?.length > 0
        ? {
            VenueType: {
              some: {
                name: {
                  in: venueTypesArray,
                },
              },
            },
          }
        : {}),
    };

    // Count query
    const count = await db.post.count({
      where: whereClause,
    });

    // Find many query
    const posts = await db.post.findMany({
      where: whereClause,
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        Seller: {
          where: { deleted: false, User: { deleted: false } },
          select: {
            id: true,
            Scheduler: { where: { deleted: false }, select: { id: true } },
            User: { select: { id: true } },
          },
        },
        id: true,
        description: true,
        hourlyRate: true,
        location: true,
        notes: true,
        Images: true,
        LocationType: true,
        VenueType: true,
        Time: true,
        Review: true,
      },
    });

    return res.status(200).json({
      posts,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    console.log(' get post ', err);
    res.status(500).json({ message: err.message });
  }
};

const getPostById = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const post = await db.post.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
      select: {
        Seller: {
          where: { deleted: false, User: { deleted: false } },
          select: { id: true, User: { select: { id: true } } },
        },
        id: true,
        description: true,
        hourlyRate: true,
        location: true,
        notes: true,
        Images: true,
        LocationType: { where: { deleted: false } },
        VenueType: { where: { deleted: false } },
        Time: true,
        Review: true,
      },
    });

    if (!post) {
      return res.status(404).json({ message: 'Post not found!' });
    }

    return res.status(200).json({ post });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const deletePost = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const isPost = await db.post.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });

    if (!isPost) {
      return res.status(404).json({ message: 'Post not found!' });
    }
    // Soft delete the post
    const post = await db.post.update({
      where: {
        id: +id,
        deleted: false,
      },
      data: {
        deleted: true,
      },
    });

    if (!post) {
      return res.status(404).json({ message: 'Post not found!' });
    }

    return res.status(200).json({ post });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const updatePost = async (req, res) => {
  try {
    const { id } = req?.params;
    const userId = req?.user?.id;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const {
      location,
      description,
      notes,
      hourlyRate,
      Time,
      VenueType,
      LocationType,
    } = req.body;

    // Only delete and recreate times if Time array is provided
    if (Time?.length > 0) {
      const postTimes = await db.time.findMany({
        where: {
          postId: +id,
        },
      });

      await db.time.deleteMany({
        where: {
          id: {
            in: postTimes.map((time) => time.id),
          },
        },
      });

      // Recreate the Time records
      await db.time.createMany({
        data: Time.map((time) => ({
          postId: +id,
          startTime: new Date(time.startTime),
          endTime: new Date(time.endTime),
        })),
      });
    }

    // Prepare update data object
    const updateData = {
      Seller: {
        connect: {
          id: +userId,
        },
      },
    };

    // Conditionally update only if fields are provided
    if (location) updateData.location = location;
    if (description) updateData.description = description;
    if (notes) updateData.notes = notes;
    if (hourlyRate) updateData.hourlyRate = hourlyRate;

    // Handle optional LocationType and VenueType
    if (LocationType?.length > 0) {
      updateData.LocationType = {
        connect: LocationType.map((type) => ({
          id: type.id,
        })),
      };
    }

    if (VenueType?.length > 0) {
      updateData.VenueType = {
        connect: VenueType.map((type) => ({
          id: type.id,
        })),
      };
    }

    const isPost = await db.post.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });

    if (!isPost) {
      return res.status(404).json({ message: 'Post not found!' });
    }
    // Update the post
    await db.post.update({
      where: {
        id: +id,
      },
      data: updateData,
    });

    return res.status(200).json({ message: 'Post updated successfully!' });
  } catch (err) {
    console.error('Error updating post:', err);
    res.status(500).json({ message: err.message });
  }
};

export {
  createPost,
  getPost,
  getPostById,
  deletePost,
  updatePost,
  getPostBySellerId,
};
