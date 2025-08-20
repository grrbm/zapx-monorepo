import db from '../../db.js';

const createReviewUser = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const { rating, description } = req?.body;
    const { sellerId } = req?.params;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: true,
      },
    });

    // Check if the seller id is provided
    if (!sellerId) {
      return res.status(404).json({ message: 'sellerId not found!' });
    }

    if (!findUser?.Consumer) {
      return res.status(404).json({ message: 'Consumer not found!' });
    }

    // find seller by id
    const existedSeller = await db.seller.findFirst({
      where: {
        id: +sellerId,
        deleted: false,
      },
    });

    // Check if the seller is not find
    if (!existedSeller) {
      return res.status(404).json({ message: 'Seller not found!' });
    }

    // Validate rating is between 1 and 5
    if (!rating || rating < 1 || rating > 5) {
      return res
        .status(400)
        .json({ message: 'Rating must be between 1 and 5.' });
    }

    // Ensure description is provided
    if (!description) {
      return res.status(400).json({ message: 'Please provide a description.' });
    }

    // Create the review
    await db.review.create({
      data: {
        Seller: {
          connect: {
            id: existedSeller?.id,
          },
        },
        Consumer: {
          connect: {
            id: +findUser?.Consumer?.id,
          },
        },
        description,
        rating,
      },
    });

    return res.status(200).json({ message: 'Review created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getReviewsByUser = async (req, res) => {
  try {
    const { id } = req?.params;
    const { rating } = req?.query; // Rating filter as a query parameter

    if (!id) {
      return res.status(404).json({ message: 'Seller id not found!' });
    }

    // Build filter criteria
    const filter = {
      where: {
        Seller: {
          id: +id,
          deleted: false,
        },
      },
    };

    if (rating) {
      // If rating is provided in query, filter reviews by that rating
      const ratingNum = parseInt(rating, 10);
      if (isNaN(ratingNum) || ratingNum < 1 || ratingNum > 5) {
        return res
          .status(400)
          .json({ message: 'Rating must be between 1 and 5.' });
      }
      filter.where.rating = ratingNum;
    }

    // Fetch reviews based on filter
    const reviews = await db.review.findMany({
      ...filter,
      select: {
        rating: true,
        description: true,
        createdAt: true,
        Consumer: {
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
    });

    return res.status(200).json({ reviews });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const createReviewPost = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const { rating, description } = req?.body;
    const { id } = req?.params;

    // Check if the post id is provided
    if (!id) {
      return res.status(404).json({ message: 'id not found!' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: { where: { deleted: false } },
      },
    });

    if (!findUser?.Consumer) {
      return res.status(404).json({ message: 'Consumer not found!' });
    }

    // find post by id
    const existedPost = await db.post.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
    });

    // Check if the post is not find
    if (!existedPost) {
      return res.status(404).json({ message: 'post not found!' });
    }

    // Validate rating is between 1 and 5
    if (!rating || rating < 1 || rating > 5) {
      return res
        .status(400)
        .json({ message: 'Rating must be between 1 and 5.' });
    }

    // Ensure description is provided
    if (!description) {
      return res.status(400).json({ message: 'Please provide a description.' });
    }

    await db.review.create({
      data: {
        Post: {
          connect: {
            id: existedPost?.id,
          },
        },
        Consumer: {
          connect: {
            id: +findUser?.Consumer?.id,
          },
        },
        description,
        rating,
      },
    });

    return res.status(200).json({ message: 'review created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getReviewsByPost = async (req, res) => {
  try {
    const { id } = req?.params;
    const { rating } = req?.query; // Rating filter as a query parameter

    // Check if the post id is provided
    if (!id) {
      return res.status(404).json({ message: 'Post id not found!' });
    }

    // Find the post by ID
    const existedPost = await db.post.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
    });

    // Check if the post is found
    if (!existedPost) {
      return res.status(404).json({ message: 'Post not found!' });
    }

    // Build the filter criteria
    const filter = {
      where: {
        Post: {
          id: existedPost?.id,
        },
        deleted: false,
      },
    };

    // Apply rating filter if provided
    if (rating) {
      const ratingNum = parseInt(rating, 10);
      if (isNaN(ratingNum) || ratingNum < 1 || ratingNum > 5) {
        return res
          .status(400)
          .json({ message: 'Rating must be between 1 and 5.' });
      }
      filter.where.rating = ratingNum;
    }

    // Fetch reviews for the post
    const reviews = await db.review.findMany({
      ...filter,
      select: {
        rating: true,
        description: true,
        Consumer: {
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
    });

    // If no reviews are found
    if (reviews?.length === 0) {
      return res
        .status(404)
        .json({ message: 'No reviews found for this post.' });
    }

    // Return reviews if found
    return res.status(200).json({ reviews });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const createReviewBooking = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const { rating, description } = req?.body;
    const { id } = req?.params;

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: { where: { deleted: false } },
      },
    });

    if (!findUser?.Consumer) {
      return res.status(404).json({ message: 'Consumer not found!' });
    }

    // Check if the booking id is provided
    if (!id) {
      return res.status(404).json({ message: 'id not found!' });
    }

    // find booking by id
    const existedBooking = await db.booking.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
    });

    // Check if the booking is not find
    if (!existedBooking) {
      return res.status(404).json({ message: 'post not found!' });
    }

    // Validate rating is between 1 and 5
    if (!rating || rating < 1 || rating > 5) {
      return res
        .status(400)
        .json({ message: 'Rating must be between 1 and 5.' });
    }

    // Ensure description is provided
    if (!description) {
      return res.status(400).json({ message: 'Please provide a description.' });
    }

    await db.review.create({
      data: {
        Booking: {
          connect: {
            id: existedBooking?.id,
          },
        },
        Consumer: {
          connect: {
            id: +findUser?.Consumer?.id,
          },
        },
        description,
        rating,
      },
    });

    return res.status(200).json({ message: 'review created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getReviewsByBooking = async (req, res) => {
  try {
    const { id } = req?.params;
    const { rating } = req?.query; // Rating filter as a query parameter

    // Check if the booking id is provided
    if (!id) {
      return res.status(404).json({ message: 'Booking id not found!' });
    }

    // Find the booking by ID
    const existedBooking = await db.booking.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
    });

    // Check if the booking is found
    if (!existedBooking) {
      return res.status(404).json({ message: 'Booking not found!' });
    }

    // Build the filter criteria
    const filter = {
      where: {
        Booking: {
          id: existedBooking?.id,
          deleted: false,
        },
      },
    };

    // Apply rating filter if provided
    if (rating) {
      const ratingNum = parseInt(rating, 10);
      if (isNaN(ratingNum) || ratingNum < 1 || ratingNum > 5) {
        return res
          .status(400)
          .json({ message: 'Rating must be between 1 and 5.' });
      }
      filter.where.rating = ratingNum;
    }

    // Fetch reviews for the booking
    const reviews = await db.review.findMany({
      ...filter,
      select: {
        rating: true,
        description: true,
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
    });

    // If no reviews are found
    if (reviews?.length === 0) {
      return res
        .status(404)
        .json({ message: 'No reviews found for this booking.' });
    }

    // Return reviews if found
    return res.status(200).json({ reviews });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

export {
  createReviewUser,
  createReviewPost,
  createReviewBooking,
  getReviewsByUser,
  getReviewsByPost,
  getReviewsByBooking,
};
