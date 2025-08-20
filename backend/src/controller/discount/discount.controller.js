import db from '../../db.js';

const createDiscount = async (req, res) => {
  try {
    const { percentage, startDate, endDate, startTime, endTime } = req.body;
    const userId = req?.user?.id ? +req.user.id : undefined;

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

    if (!findUser?.Seller) {
      return res.status(400).json({ message: 'Seller not found!' });
    }

    if (!percentage) {
      return res.status(400).json({ message: 'Percentage is required!' });
    }

    if (!startDate || !endDate) {
      return res
        .status(400)
        .json({ message: 'Both start date and end date are required!' });
    }

    if (!startTime || !endTime) {
      return res
        .status(400)
        .json({ message: 'Both start time and end time are required!' });
    }

    await db.discount.create({
      data: {
        Seller: {
          connect: {
            id: findUser?.Seller?.id,
          },
        },
        percentage,
        startDate,
        endDate,
        startTime,
        endTime,
      },
    });

    return res.status(200).json({ message: 'Discount created successfully!' });
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ message: err.message });
  }
};

const updateDiscount = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id required!' });
    }

    const { percentage, startDate, endDate, startTime, endTime } = req?.body;

    await db.discount.update({
      where: {
        deleted: false,
        id: +id,
      },
      data: {
        ...(percentage && { percentage }),
        ...(startDate && { startDate }),
        ...(endDate && { endDate }),
        ...(startTime && { startTime }),
        ...(endTime && { endTime }),
      },
    });

    return res.status(200).json({ message: 'Discount updated successfully!' });
  } catch (err) {
    console.error('Error updating discount:', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteDiscount = async (req, res) => {
  try {
    const { id } = req?.params;

    if (!id) {
      return res.status(404).json({ message: 'Id is required!' });
    }

    const deleteDiscount = await db.discount.update({
      where: {
        id: +id,
        deleted: false,
      },
      data: {
        deleted: true,
      },
    });

    if (!deleteDiscount) {
      return res.status(404).json({ message: 'Discount not found!' });
    }

    return res.status(200).json({ message: 'Discount deleted sucessfully!' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

export { createDiscount, updateDiscount, deleteDiscount };
