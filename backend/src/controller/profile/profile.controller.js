import db from '../../db.js';

const createProfile = async (req, res) => {
  try {
    const { cardImage, image } = req?.files;
    const { services: provideServices, categoryId } = req?.body;
    const userId = req?.user?.id ? +req.user.id : undefined;

    if (!categoryId) {
      return res.status(400).json({ message: 'categoryId is required!' });
    }
    const isUser = await db.user.findUnique({
      where: {
        id: userId,
        deleted: false,
      },
    });

    if (!isUser) {
      return res.status(400).json({ message: 'User is not found!' });
    }
    const findProfile = await db.seller.findFirst({
      where: {
        userId,
        deleted: false,
      },
    });

    if (findProfile) {
      return res
        .status(400)
        .json({ message: 'You already have a profile created' });
    }

    const sevicesParse =
      provideServices.length > 0 ? JSON.parse(provideServices) : [];

    if (sevicesParse && sevicesParse?.length === 0) {
      return res.status(400).json({ message: 'services is required' });
    }

    if (!cardImage) {
      return res.status(400).json({ message: 'Id card Image is required' });
    }

    if (!image) {
      return res.status(400).json({ message: 'Profile Image  is required' });
    }
    await db.seller.create({
      data: {
        User: {
          connect: {
            id: userId,
          },
        },
        Category: {
          connect: {
            id: +categoryId,
          },
        },
        Services: {
          connect: sevicesParse?.map((service) => ({
            id: +service,
          })),
        },
        ...(cardImage?.length > 0
          ? {
              CardImage: {
                create: {
                  url: cardImage[0]?.path,
                  mimeType: cardImage[0]?.mimetype,
                },
              },
            }
          : {}),
        ...(image?.length > 0
          ? {
              Image: {
                create: {
                  url: image[0]?.path,
                  mimeType: image[0]?.mimetype,
                },
              },
            }
          : {}),
      },
    });

    return res
      .status(200)
      .json({ message: 'You have successfully created the profile' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const createBio = async (req, res) => {
  try {
    const image = req?.file;
    const { aboutMe, location } = req?.body;
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          where: { deleted: false },
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User is not found' });
    }

    await db.$transaction([
      db.user.update({
        where: {
          id: findUser?.id,
        },
        data: {
          ProfileImage: {
            create: {
              url: image?.path,
              mimeType: image?.mimetype,
            },
          },
        },
      }),

      db.seller.update({
        where: {
          id: findUser?.Seller?.id,
        },
        data: {
          aboutMe,
          location,
        },
      }),
    ]);

    return res.status(200).json({ message: 'Created  successfully' });
  } catch (err) {
    console.log('error', err);
    res.status(500).json({ message: err.message });
  }
};

const updateBio = async (req, res) => {
  try {
    const { aboutMe, location } = req.body;
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          where: { deleted: false },
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User is not found' });
    }

    await db.seller.update({
      where: {
        id: findUser.Seller.id,
      },
      data: {
        aboutMe,
        location,
      },
    });

    return res.status(200).json({ message: 'Updated  successfully' });
  } catch (err) {
    console.log('error', err);
    res.status(500).json({ message: err.message });
  }
};

const getBioByUser = async (req, res) => {
  try {
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        username: true,
        fullName: true,
        email: true,
        role: true,
        Seller: {
          where: { deleted: false },
          select: {
            id: true,
            aboutMe: true,
            location: true,
            _count: { select: { Review: { where: { deleted: false } } } },
          },
        },
        ProfileImage: {
          where: { deleted: false },
          select: {
            id: true,
            url: true,
            mimeType: true,
          },
        },
      },
    });

    if (findUser?.Seller?.id) {
      const reverAvg = await db.review.aggregate({
        where: { sellerId: findUser?.Seller?.id },
        _avg: { rating: true },
      });
      findUser._avg = reverAvg._avg;
    }
    if (!findUser) {
      return res.status(400).json({ message: 'User is not found' });
    }

    return res.status(200).json({ User: findUser });
  } catch (err) {
    console.log('error', err);
    res.status(500).json({ message: err.message });
  }
};

const getProfilebySellerId = async (req, res) => {
  try {
    const { id } = req.params;
    if (id === 'undefined' || !id) {
      return res.status(400).json({ message: 'Seller ID is required' });
    }
    const findUser = await db.user.findFirst({
      where: {
        Seller: { id: +id, deleted: false },
        deleted: false,
      },
      select: {
        id: true,
        username: true,
        fullName: true,
        email: true,
        role: true,
        Seller: {
          where: { deleted: false },
          select: {
            id: true,
            aboutMe: true,
            location: true,
            _count: { select: { Review: { where: { deleted: false } } } },
          },
        },
        ProfileImage: {
          where: { deleted: false },
          where: { deleted: false },
          select: {
            id: true,
            aboutMe: true,
            location: true,
            _count: { select: { Review: { where: { deleted: false } } } },
          },
        },
        ProfileImage: {
          where: { deleted: false },
          select: {
            id: true,
            url: true,
            mimeType: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User is not found' });
    }
    if (findUser?.Seller?.id) {
      const reverAvg = await db.review.aggregate({
        where: { sellerId: findUser?.Seller?.id },
        _avg: { rating: true },
      });
      findUser._avg = reverAvg._avg;
    }

    return res.status(200).json({ User: findUser });
  } catch (err) {
    console.log('error', err);
    res.status(500).json({ message: err.message });
  }
};

const getProfilebyUser = async (req, res) => {
  try {
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        username: true,
        fullName: true,
        Consumer: {
          where: { deleted: false },
          select: {
            id: true,
            phone: true,
          },
        },
        ProfileImage: {
          where: { deleted: false },
          select: {
            id: true,
            url: true,
            mimeType: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User is not found' });
    }

    return res.status(200).json({ User: findUser });
  } catch (err) {
    console.log('error', err);
    res.status(500).json({ message: err.message });
  }
};

const createProfileImage = async (req, res) => {
  try {
    const image = req?.file;
    const userId = req?.user?.id;

    if (!image) {
      return res.status(400).json({ message: 'File (image) is required' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      include: { ProfileImage: true }, // Include existing profile image
    });

    if (!findUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Delete existing profile image if it exists
    if (findUser.ProfileImage) {
      await db.file.delete({
        where: { id: findUser.ProfileImage.id },
      });
    }

    // Update user with new profile image
    await db.user.update({
      where: { id: findUser.id },
      data: {
        ProfileImage: {
          create: {
            url: image.path,
            mimeType: image.mimetype,
          },
        },
      },
    });

    return res
      .status(200)
      .json({ message: 'Profile image created successfully' });
  } catch (err) {
    console.error('Error in createProfileImage:', err);
    return res
      .status(500)
      .json({ message: 'Internal server error', error: err.message });
  }
};

const updateProfile = async (req, res) => {
  try {
    const { fullName, username, phone } = req.body;
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: { id: true },
    });

    if (!findUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Update user profile image
    const user = await db.user.update({
      where: { id: findUser.id },
      data: {
        fullName,
        username,
        Consumer: {
          update: {
            phone,
          },
        },
      },
      include: {
        Consumer: { select: { id: true, phone: true } },
        ProfileImage: { select: { id: true, url: true, mimeType: true } },
      },
    });
    const profile = {
      id: user.id,
      fullName: user?.fullName,
      username: user?.username,
      phone: user?.Consumer?.phone,
      profileImage: user?.ProfileImage
        ? {
            id: user?.ProfileImage.id,
            url: user?.ProfileImage?.url,
            mimeType: user?.ProfileImage?.mimeType,
          }
        : null,
    };
    return res
      .status(200)
      .json({ message: 'Profile update successfully', profile });
  } catch (err) {
    console.error('Error in createProfileImage:', err);
    return res
      .status(500)
      .json({ message: 'Internal server error', error: err.message });
  }
};

export {
  createProfile,
  createBio,
  updateBio,
  getBioByUser,
  getProfilebyUser,
  createProfileImage,
  updateProfile,
  getProfilebySellerId,
};
