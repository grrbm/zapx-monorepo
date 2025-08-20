import db from '../../db.js';

const createLocation = async (req, res) => {
  try {
    const { name } = req.body;

    if (!name) {
      return res.status(400).json({ message: 'name is required!' });
    }

    await db.location.create({
      data: {
        name,
      },
    });

    return res.status(200).json({ message: 'Location created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getLocation = async (req, res) => {
  try {
    const { search } = req.query;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    const count = await db.location.count({
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

    const locations = await db.location.findMany({
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
      skip: +skip,
      take: +take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        name: true,
      },
    });

    return res.status(200).json({
      locations,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getLocationById = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const location = await db.location.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
      select: {
        id: true,
        name: true,
      },
    });

    if (!location) {
      return res.status(404).json({ message: 'Location not found!' });
    }

    return res.status(200).json({ location });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const updateLocation = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const { name } = req.body;
    const isLocation = await db.location.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });
    if (!isLocation) {
      return res.status(404).json({ message: 'Location not found!' });
    }
    await db.location.update({
      where: {
        id: +id,
      },
      data: {
        name,
      },
    });

    return res.status(200).json({ message: 'Location updated successfully!' });
  } catch (err) {
    console.error('Error updating location:', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteLocation = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const isLocation = await db.location.findFirst({
      where: {
        deleted: false,
        id: +id,
        Post: null,
      },
    });

    if (!isLocation) {
      return res
        .status(404)
        .json({ message: 'You cannot delete location with post!' });
    }

    const location = await db.location.update({
      where: {
        id: +id,
        deleted: false,
      },
      data: {
        deleted: true,
      },
    });

    if (!location) {
      return res.status(404).json({ message: 'Location not found!' });
    }

    return res.status(200).json({ location });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export {
  createLocation,
  getLocation,
  getLocationById,
  updateLocation,
  deleteLocation,
};
