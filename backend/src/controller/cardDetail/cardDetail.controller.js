import db from '../../db.js';

const createCardDetil = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;
    const {
      cardHolderName,
      cardNumber,
      expiryDate,
      cvvCvc,
      isPrimaryPaymentMethod,
    } = req?.body;

    if (!cardHolderName || !cardNumber || !expiryDate || !cvvCvc) {
      return res.status(400).json({ message: 'card detail  is required' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: userId,
        deleted: false,
      },
      select: {
        id: true,
        Consumer: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User  not found!' });
    }

    await db.cardDetail.create({
      data: {
        cardHolderName,
        cardNumber,
        expiryDate,
        securityCode: cvvCvc,
        isPrimary: isPrimaryPaymentMethod,
        Consumer: {
          connect: {
            id: findUser?.Consumer?.id,
          },
        },
      },
    });

    return res.status(200).json({ message: 'Card created successfully!' });
  } catch (err) {
    console.log('Error create card Detials', err);
    res.status(500).json({ message: err.message });
  }
};

const getAllCardDetails = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;

    const consumer = await db.consumer.findFirst({
      where: {
        User: { deleted: false, id: userId },
        deleted: false,
      },
    });

    if (!consumer) {
      return res.status(400).json({ message: 'Consumer  not found!' });
    }

    const getAllCardDetails = await db.cardDetail.findMany({
      where: {
        consumerId: consumer?.id,
        deleted: false,
      },
      select: {
        id: true,
        cardHolderName: true,
        cardNumber: true,
        expiryDate: true,
        securityCode: true,
        isPrimary: true,
      },
    });

    return res.status(200).json({ cardDetails: getAllCardDetails });
  } catch (err) {
    console.log('Error create card Detials', err);
    res.status(500).json({ message: err.message });
  }
};

const getCardByCardId = async (req, res) => {
  try {
    const { cardId } = req?.params;
    if (cardId) {
      return res.status(400).json({ message: 'CardId is required!' });
    }
    const getCardDetail = await db.cardDetail.findFirst({
      where: {
        id: +cardId,
        deleted: false,
      },
      select: {
        id: true,
        cardHolderName: true,
        cardNumber: true,
        expiryDate: true,
        securityCode: true,
        isPrimary: true,
      },
    });

    if (!getCardDetail) {
      return res.status(400).json({ message: 'Card Detail not found!' });
    }

    return res.status(200).json({ cardDetail: getCardDetail });
  } catch (err) {
    console.log('Error get detail  by card Id ', err);
    res.status(500).json({ message: err.message });
  }
};

const updateCardDetail = async (req, res) => {
  try {
    const { cardId } = req?.params;
    if (cardId) {
      return res.status(400).json({ message: 'CardId is required!' });
    }
    const {
      cardHolderName,
      cardNumber,
      expiryDate,
      cvvCvc,
      isPrimaryPaymentMethod,
    } = req?.body;

    const getCardDetail = await db.cardDetail.findFirst({
      where: {
        id: +cardId,
        deleted: false,
      },
      select: {
        id: true,
      },
    });

    if (!getCardDetail) {
      return res.status(400).json({ message: 'Card Detail not found!' });
    }

    await db.cardDetail.update({
      where: {
        id: getCardDetail?.id,
      },
      data: {
        cardHolderName,
        ...(cardNumber && { cardNumber }),
        ...(expiryDate && { expiryDate }),
        ...(cvvCvc && { securityCode: cvvCvc }),
        ...(isPrimary && { isPrimary: isPrimaryPaymentMethod }),
      },
    });

    return res.status(200).json({ message: 'update  successfully' });
  } catch (err) {
    console.log('Error update detail  by card Id', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteCardDetail = async (req, res) => {
  try {
    const { cardId } = req?.params;

    if (cardId) {
      return res.status(400).json({ message: 'CardId is required!' });
    }

    const getCardDetail = await db.cardDetail.findFirst({
      where: {
        id: +cardId,
        deleted: false,
      },
      select: {
        id: true,
      },
    });

    if (!getCardDetail) {
      return res.status(400).json({ message: 'Card Detail not found!' });
    }

    await db.cardDetail.update({
      where: {
        id: getCardDetail?.id,
      },
      data: {
        deleted: true,
      },
    });

    return res.status(200).json({ message: 'deleted  successfully' });
  } catch (err) {
    console.log('Error delete detail  by card Id', err);
    res.status(500).json({ message: err.message });
  }
};

export {
  createCardDetil,
  getAllCardDetails,
  getCardByCardId,
  updateCardDetail,
  deleteCardDetail,
};
