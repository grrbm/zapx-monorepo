import db from '../../db.js';

const createPortfolio = async (req, res) => {
  try {
    const { title } = req.body;
    const { image: Images } = req.files;
    const userId = req?.user?.id;

    if (Images?.length === 0) {
      return res.status(400).json({ message: 'Images is required!' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: +userId,
        deleted: false,
      },
      select: {
        id: true,
        Seller: {
          where: {
            deleted: false,
          },
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser?.Seller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    await db.portfolio.create({
      data: {
        Seller: {
          connect: {
            id: findUser?.Seller?.id,
          },
        },
        title,
        ...(Images?.length > 0
          ? {
              Images: {
                createMany: {
                  data: Images?.map((image) => ({
                    url: image.path,
                    mimeType: image.mimetype,
                  })),
                },
              },
            }
          : {}),
      },
    });

    return res.status(200).json({ message: 'Portfolio created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const getPortfolio = async (req, res) => {
  try {
    const { search } = req.query;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    const count = await db.portfolio.count({
      where: {
        ...(search
          ? {
              title: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        deleted: false,
      },
    });

    const portfolio = await db.portfolio.findMany({
      where: {
        ...(search
          ? {
              title: {
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
        title: true,
        Images: true,
      },
    });

    return res.status(200).json({
      portfolio,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getPortfolioBySellerId = async (req, res) => {
  try {
    const { id } = req?.params;
    const { search } = req.query;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }
    const count = await db.portfolio.count({
      where: {
        ...(search
          ? {
              title: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        deleted: false,
        Seller: {
          id: +id,
        },
      },
    });

    const portfolio = await db.portfolio.findMany({
      where: {
        ...(search
          ? {
              title: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
        deleted: false,
        Seller: {
          id: +id,
        },
      },
      skip: +skip,
      take: +take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        title: true,
        Images: { select: { id: true, url: true, mimeType: true } },
      },
    });

    return res.status(200).json({
      portfolio,
      count: count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getPortfolioById = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const portfolio = await db.portfolio.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
      select: {
        id: true,
        title: true,
        Images: true,
      },
    });

    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found!' });
    }

    return res.status(200).json({ portfolio });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const updatePortfolio = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const { title } = req.body;
    const isPortfolio = await db.portfolio.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });

    if (!isPortfolio) {
      return res.status(404).json({ message: 'Portfolio not found!' });
    }

    if (!title) {
      return res.status(400).json({ message: 'Title is required!' });
    }

    await db.portfolio.update({
      where: {
        id: +id,
      },
      data: {
        title,
      },
    });

    return res.status(200).json({ message: 'Portfolio updated successfully!' });
  } catch (err) {
    console.error('Error updating porfolio:', err);
    res.status(500).json({ message: err.message });
  }
};

const deletePortfolio = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const isPortfolio = await db.portfolio.findUnique({
      where: {
        id: +id,
        deleted: false,
      },
    });

    if (!isPortfolio) {
      return res.status(404).json({ message: 'Portfolio not found!' });
    }

    const portfolio = await db.portfolio.update({
      where: {
        id: +id,
        deleted: false,
      },
      data: {
        deleted: true,
      },
    });

    if (!portfolio) {
      return res.status(404).json({ message: 'Portfolio not found!' });
    }

    return res.status(200).json({ portfolio });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
const getPortfolioByUser = async (req, res) => {
  try {
    const userId = req?.user?.id;
    const { search } = req.query;
    const skip = +req?.query?.skip || 0;
    const take = +req?.query?.take || 10;

    const count = await db.portfolio.count({
      where: {
        Seller: { User: { deleted: false, id: userId } },
        deleted: false,
        ...(search
          ? {
              title: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
      },
    });

    const portfolio = await db.portfolio.findMany({
      where: {
        Seller: { User: { deleted: false, id: userId } },
        deleted: false,
        ...(search
          ? {
              title: {
                contains: search,
                mode: 'insensitive',
              },
            }
          : {}),
      },
      skip: +skip,
      take: +take,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        title: true,
        Images: true,
      },
    });

    return res.status(200).json({
      portfolio,
      count,
      nextFrom: count > skip + take ? skip + take : false,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export {
  createPortfolio,
  getPortfolio,
  getPortfolioById,
  updatePortfolio,
  deletePortfolio,
  getPortfolioByUser,
  getPortfolioBySellerId,
};
