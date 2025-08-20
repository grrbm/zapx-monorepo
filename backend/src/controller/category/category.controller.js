import db from '../../db.js';

const getCategories = async (req, res) => {
  try {
    const categories = await db.category.findMany({
      where: {
        deleted: false,
      },
      select: {
        id: true,
        name: true,
      },
    });

    return res.status(200).json({
      categories,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export { getCategories };
