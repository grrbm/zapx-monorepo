import db from '../../db.js';

const createService = async (req, res) => {
  try {
    const { name, categoryId } = req?.body;
    if (!name) {
      return res.status(400).json({
        message: 'Name is required!',
      });
    }
    if (!categoryId) {
      return res.status(400).json({
        message: 'categoryId is required!',
      });
    }

    const isCategory = await db.category.findUnique({
      where: {
        id: +categoryId,
        deleted: false,
      },
    });

    if (!isCategory) {
      return res.status(400).json({ message: 'Category is not found!' });
    }

    const findServices = await db.services.findFirst({
      where: {
        name,
        deleted: false,
      },
    });

    if (findServices) {
      return res
        .status(400)
        .json({ message: `Services is  already exist this name  "${name}"` });
    } else {
      await db.services.create({
        data: {
          name,
          Category: {
            connect: {
              id: +categoryId,
            },
          },
        },
      });
    }

    return res.status(200).json({
      message: 'Service created successfully',
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getServices = async (req, res) => {
  try {
    const { categoryId, search } = req?.query;
    const skip = req?.query?.skip ? +req.query.skip : 0;
    const take = req?.query?.take ? +req.query.take : 10;

    if (!categoryId) {
      return res.status(400).json({ message: 'categoryId is required ' });
    }

    const findCategory = await db.category.findFirst({
      where: {
        id: +categoryId,
        deleted: false,
      },
    });

    if (!findCategory) {
      return res.status(400).json({ message: 'Category is not found' });
    }

    const count = await db.services.count({
      where: {
        ...(search
          ? {
              name: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        categoryId: +categoryId,
        deleted: false,
      },
    });

    const services = await db.services.findMany({
      where: {
        categoryId: +categoryId,
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
      services,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export { getServices, createService };
