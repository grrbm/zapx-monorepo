import db from '../../db.js';
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const createBankDetail = async (req, res) => {
  try {
    const userId = req?.user?.id ? +req.user.id : undefined;
    const { cancellationFee, noShowFee, country } = req.body;

    if (!userId) {
      return res.status(400).json({ message: 'userId not found!' });
    }

    const findUser = await db.user.findFirst({
      where: {
        id: userId,
        deleted: false,
      },
      select: {
        email: true,
        id: true,
        Consumer: {
          select: {
            id: true,
          },
        },
        Seller: {
          select: {
            id: true,
          },
        },
      },
    });

    try {
      const account = await stripe.accounts.create({
        type: 'express',
        country,
        email: findUser.email, // Seller's email
        capabilities: {
          transfers: { requested: true },
        },
        business_type: 'individual', // Required for Express accounts
        tos_acceptance: {
          service_agreement: 'recipient', // Explicitly set to 'recipient'
        },
      });

      // adding account link, for user validation (by user)
      const accountLink = await stripe.accountLinks.create({
        account: account.id, // Connected Account ID
        refresh_url: 'https://yourapp.com/reauth', // URL if the user needs to re-authenticate
        return_url: 'https://yourapp.com/return', // URL to redirect the user after onboarding
        type: 'account_onboarding',
      });

      // storing information in database about stripe bank account id
      await db.bankDetail.create({
        data: {
          ...(cancellationFee && { cancelationFee: cancellationFee }),
          ...(noShowFee && { noShowFee: noShowFee }),
          stripeBankAccountId: account.id,
          Seller: {
            connect: {
              id: findUser?.Seller?.id,
            },
          },
        },
      });

      return res.status(200).json({ onboardingUrl: accountLink.url });
    } catch (error) {
      console.log('error in stripe account creation ===>>>', error);
      return res
        .status(500)
        .json({ error, message: 'Error while creating account on stripe' });
    }
  } catch (err) {
    console.log('Error create bank Detials', err);
    res.status(500).json({ message: err.message });
  }
};

const getAllBankDetails = async (req, res) => {
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
          select: {
            id: true,
          },
        },
        Seller: {
          select: {
            id: true,
          },
        },
      },
    });

    if (!findUser) {
      return res.status(400).json({ message: 'User  not found!' });
    }

    const bankDetails = await db.bankDetail.findMany({
      where: {
        ...(findUser?.Seller && {
          Seller: { id: findUser?.Seller?.id },
        }),
        deleted: false,
      },
      select: {
        id: true,
        stripeBankAccountId: true,
        cancelationFee: true,
        noShowFee: true,
      },
    });
    return res.status(200).json({ bankDetails: bankDetails });
  } catch (err) {
    console.log('Error create bank Detials', err);
    res.status(500).json({ message: err.message });
  }
};

const getBankByCardId = async (req, res) => {
  try {
    const { bankDetailId } = req?.params;

    const getbankDetail = await db.bankDetail.findFirst({
      where: {
        id: +bankDetailId,
        deleted: false,
      },
      select: {
        id: true,
        accountHolderName: true,
        accountNumber: true,
        routingNumber: true,
        cancelationFee: true,
        noShowFee: true,
      },
    });

    if (!getbankDetail) {
      return res.status(400).json({ message: 'Bank Detail not found!' });
    }

    return res.status(200).json({ bankDetail: getbankDetail });
  } catch (err) {
    console.log('Error get detail  by Bank Id ', err);
    res.status(500).json({ message: err.message });
  }
};

const updateBankDetail = async (req, res) => {
  try {
    const { bankDetailId } = req?.params;

    if (!bankDetailId) {
      return res.status(400).json({ message: 'bankDetailId not found!' });
    }

    const { stripeBankAccountId, cancelationFee, noShowFee } = req.body;

    const getBankDetail = await db.bankDetail.findFirst({
      where: {
        id: bankDetailId,
        deleted: false,
      },
      select: {
        id: true,
      },
    });

    if (!getBankDetail) {
      return res.status(400).json({ message: 'Bank Detail not found!' });
    }

    await db.bankDetail.update({
      where: {
        id: getBankDetail?.id,
      },
      data: {
        ...(stripeBankAccountId && { stripeBankAccountId }),
        ...(cancelationFee && { cancelationFee }),
        ...(noShowFee && { noShowFee }),
      },
    });

    return res.status(200).json({ message: 'update  successfully' });
  } catch (err) {
    console.log('Error update detail  by bank Id', err);
    res.status(500).json({ message: err.message });
  }
};

const deleteBankDetail = async (req, res) => {
  try {
    const { bankDetailId } = req?.params;

    if (!bankDetailId) {
      return res.status(400).json({ message: 'bankDetailId not found!' });
    }

    const getBankDetail = await db.bankDetail.findFirst({
      where: {
        id: bankDetailId,
        deleted: false,
      },
      select: {
        id: true,
      },
    });

    if (!getBankDetail) {
      return res.status(400).json({ message: 'Bank Detail not found!' });
    }

    await db.bankDetail.update({
      where: {
        id: getBankDetail?.id,
      },
      data: {
        deleted: true,
      },
    });

    return res.status(200).json({ message: 'deleted  successfully' });
  } catch (err) {
    console.log('Error delete detail  by Bank Id', err);
    res.status(500).json({ message: err.message });
  }
};

export {
  createBankDetail,
  getAllBankDetails,
  getBankByCardId,
  updateBankDetail,
  deleteBankDetail,
};
