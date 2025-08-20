import db from '../../db.js';

const createVenue = async (req, res) => {
  try {
    const { name } = req?.body;
    if (!name) {
      return res.status(400).json({ message: 'Name is required!' });
    }
    await db.venue.create({
      data: {
        name,
      },
    });

    return res.status(200).json({ message: 'Venue created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getVenue = async (req, res) => {
  try {
    const { search } = req.query;
    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;

    const count = await db.venue.count({
      where: {
        ...(search
          ? {
              name: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        deleted: false,
      },
    });

    const venue = await db.venue.findMany({
      where: {
        ...(search
          ? {
              name: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        deleted: false,
      },
      skip,
      take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        name: true,
      },
    });

    return res.status(200).json({
      venue,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getVenueById = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const venue = await db.venue.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
      select: {
        id: true,
        name: true,
      },
    });

    if (!venue) {
      return res.status(404).json({ message: 'Location not found!' });
    }

    return res.status(200).json({ venue });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const updateVenue = async (req, res) => {
  try {
    const { id } = req?.params;
    const { name } = req?.body;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }
    const isVenue = await db.venue.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });
    if (!isVenue) {
      return res.status(404).json({ message: 'Venue not found!' });
    }
    if (name) {
      await db.venue.update({
        where: {
          id: +id,
        },
        data: {
          name,
        },
      });
      return res.status(200).json({ message: 'Venue updated successfully!' });
    }
    return res.status(200).json({ message: 'Nothing updated!' });
  } catch (err) {
    console.error('Error updating venue:', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteVenue = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const isVanuePosts = await db.venue.findFirst({
      where: {
        deleted: false,
        id: +id,
        Post: null,
      },
    });

    if (!isVanuePosts) {
      return res
        .status(404)
        .json({ message: 'You cannot delete venue with post!' });
    }

    const venue = await db.venue.update({
      where: {
        id: +id,
        deleted: false,
      },
      data: {
        deleted: true,
      },
    });

    if (!venue) {
      return res.status(404).json({ message: 'Venue not found!' });
    }

    return res.status(200).json({ venue });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export { createVenue, getVenue, getVenueById, updateVenue, deleteVenue };
