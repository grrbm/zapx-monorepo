import db from '../../db.js';

const favouriteOrUnFavourite = async (req, res) => {
  try {
    const { sellerId } = req?.params;
    const { isSaved } = req?.body;
    const userId = req?.user?.id ? +req.user.id : undefined;

    if (sellerId && !Number.isInteger(Number(sellerId))) {
      return res
        .status(400)
        .json({ error: 'Invalid sellerId. It must be an number.' });
    }

    const consumer = await db.consumer.findFirst({
      where: {
        deleted: false,
        User: { id: userId, deleted: false },
      },
      select: {
        id: true,
      },
    });

    if (!consumer) {
      return res.status(400).json({ message: 'Consumer not found' });
    }

    // Find the seller and include the Favourite relation
    const findSeller = await db.seller.findFirst({
      where: {
        id: +sellerId,
        deleted: false,
      },
      include: {
        Favourite: {
          where: {
            consumerId: consumer?.id,
          },
        },
      },
    });

    if (!findSeller) {
      return res.status(400).json({ message: 'Seller not found' });
    }

    const existingFavourite = findSeller?.Favourite[0];

    if (!existingFavourite) {
      // Create a new favourite entry if none exists
      await db.favourite.create({
        data: {
          consumerId: consumer?.id,
          sellerId: +sellerId,
          isSaved,
        },
      });
    } else {
      // Update the existing favourite entry
      await db.favourite.update({
        where: {
          id: existingFavourite?.id,
        },
        data: {
          isSaved,
        },
      });
    }

    return res
      .status(200)
      .json({ message: `${isSaved ? 'Saved' : 'Un-saved'} successfully!` });
  } catch (err) {
    console.error('Error:', err);
    res.status(500).json({ message: 'An error occurred' });
  }
};

const getFavoritesUser = async (req, res) => {
  try {
    const userId = req?.user?.id;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          where: { deleted: false },
          select: {
            id: true,
          },
        },
      },
    });

    if (findUser && !findUser.Consumer) {
      return res.status(400).json({ message: 'User not found' });
    }

    const getLikedUsers = await db.favourite.findMany({
      where: {
        consumerId: findUser?.Consumer?.id,
        isSaved: true,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          select: {
            id: true,
            aboutMe: true,
            User: {
              select: {
                id: true,
                fullName: true,
                username: true,
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

    return res.status(200).json({ SavedUser: getLikedUsers });
  } catch (err) {
    console.error('Error:', err);
    res.status(500).json({ message: 'An error occurred' });
  }
};

export { favouriteOrUnFavourite, getFavoritesUser };
