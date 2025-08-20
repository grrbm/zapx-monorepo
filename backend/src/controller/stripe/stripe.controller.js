import Stripe from "stripe";
import db from "../../db.js";
import { BookingStatus } from "@prisma/client";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const setupIntent = async (req, res) => {
  try {
    const userId = req?.user?.id && Number(req?.user?.id);
    const consumer = await db.consumer.findFirst({
      where: { deleted: false, User: { deleted: false, id: userId } },
      select: { stripeCustomerId: true },
    });

    if (!consumer || !consumer.stripeCustomerId) {
      return res.status(400).json({ message: "Stripe customer not found" });
    }

    try {
      const setupIntentObj = await stripe.setupIntents.create({
        customer: consumer.stripeCustomerId,
      });
      return res
        .status(200)
        .json({ clientSecret: setupIntentObj.client_secret });
    } catch (err) {
      console.log("stripe error", err?.raw?.message);
      return res.status(400).json({ message: err?.raw?.message });
    }
  } catch (error) {
    console.error("Error creating Setup Intent:", error);
    return res.status(500).json({ message: "Failed to create Setup Intent" });
  }
};

const saveCard = async (req, res) => {
  try {
    const { cardId, isPrimary } = req.body;
    const userId = req?.user?.id && Number(req?.user?.id);

    const consumer = await db.consumer.findFirst({
      where: { deleted: false, User: { deleted: false, id: userId } },
      select: {
        id: true,
        CardDetail: {
          where: { deleted: false },
          select: { id: true, isPrimary: true },
        },
      },
    });

    if (!cardId) {
      return res.status(400).json({ message: "cardId required!" });
    }

    const prevPrimaryCard = consumer?.CardDetail?.find(
      (card) => card.isPrimary
    );

    // if new card isPrimary true then make previous card not primary
    if (isPrimary && prevPrimaryCard) {
      await db.cardDetail.update({
        where: { id: prevPrimaryCard.id },
        data: { isPrimary: false },
      });
    }

    await db.cardDetail.create({
      data: {
        paymentMethodId: cardId,
        isPrimary,
        Consumer: {
          connect: {
            id: consumer.id,
          },
        },
      },
    });

    return res.status(200).json({ message: "Card saved successfully!" });
  } catch (error) {
    console.error("Error creating Setup Intent:", error);
    return res.status(500).json({ message: "Failed to create Setup Intent" });
  }
};

const getCards = async (req, res) => {
  try {
    const userId = req?.user?.id && Number(req?.user?.id);
    const consumer = await db.consumer.findFirst({
      where: { deleted: false, User: { deleted: false, id: userId } },
      select: { stripeCustomerId: true, CardDetail: true },
    });

    if (!consumer || !consumer.stripeCustomerId) {
      return res.status(400).json({ message: "Stripe customer not found" });
    }

    return res.status(200).json({ cards: consumer?.CardDetail });
  } catch (error) {
    console.error("Error in getCards", error);
    return res.status(500).json({ message: "Failed to get cards" });
  }
};

const paymentIntent = async (req, res) => {
  try {
    const { bookingId, paymentMethodId } = req.body;
    const userId = req.user.id;

    if (!bookingId || !paymentMethodId) {
      return res.status(400).json({
        message: `These fields "bookingId, paymentMethodId" are required!`,
      });
    }

    const consumer = await db.consumer.findFirst({
      where: { deleted: false, User: { deleted: false, id: userId } },
      select: { stripeCustomerId: true },
    });

    // check if booking exists
    const isBooking = await db.booking.findFirst({
      where: {
        id: +bookingId,
        Consumer: { userId: +userId },
        status: {
          in: [
            BookingStatus.AWAITING_BOOKING_CONFIRMATION,
            BookingStatus.OFFER,
          ],
        },
      },
    });

    if (!isBooking) {
      return res.status(400).json({ message: "Booking not found!" });
    }

    // Retrieve the payment method from Stripe
    const paymentMethod = await stripe.paymentMethods.retrieve(paymentMethodId);
    if (!paymentMethod) {
      return res.status(400).json({ message: "Payment method not found!" });
    }

    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount: isBooking.totalPrice * 100, // for cents to dollars
        currency: "usd",
        customer: consumer.stripeCustomerId, // Replace with your customer's ID
        payment_method: paymentMethodId, // Saved card ID,
        automatic_payment_methods: { enabled: true },
        off_session: false, // Customer will actively confirm the payment
        confirm: false, // Confirmation will happen on the frontend
        metadata: {
          bookingId: bookingId,
          userId: userId,
          stripeCustomerId: consumer.stripeCustomerId,
        },
      });
      return res.status(200).json({
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
        bookingId: bookingId,
      });
    } catch (err) {
      return res.status(400).json({ message: err?.raw?.message });
    }
  } catch (error) {
    console.log("error in payment ===>>> ", error);
    return res.status(500).json({ message: "Internal Server Error!", error });
  }
};

const storePaymentDetails = async (req, res) => {
  try {
    const { paymentIntentId, bookingId } = req.body;
    const userId = req.user.id;
    if (!paymentIntentId || !bookingId) {
      return res
        .status(200)
        .json({ message: "paymentIntentId and bookingId required!" });
    }

    const booking = await db.booking.update({
      where: { id: +bookingId, Consumer: { userId: +userId } },
      data: {
        stripePaymentIntentId: paymentIntentId,
        status: BookingStatus.INPROGRESS,
      },
    });

    if (!booking) {
      return res.status(400).json({ message: "booking not found!" });
    }

    return res.status(200).json({ message: "Your booking is in progress." });
  } catch (error) {
    console.log("error in storePaymentDetails ===>>>", error);
    return res.status(500).json({ message: "Internal Server Error!", error });
  }
};

const refundPayment = async (req, res) => {
  try {
    const { paymentIntentId, amount } = req.body;

    if (!paymentIntentId || !amount) {
      return res
        .status(400)
        .json({ message: "paymentIntentId and amount are required." });
    }

    // Retrieve the PaymentIntent
    const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId);

    if (!paymentIntent) {
      return res.status(404).json({
        message: "PaymentIntent not found. Please check the paymentIntentId.",
      });
    }

    const refund = await stripe.refunds.create({
      payment_intent: paymentIntentId,
      // Specify 'amount' in cents if doing a partial refund
      amount: amount * 100,
    });

    return res.status(200).json({ message: "Refund successful!", refund });
  } catch (error) {
    console.error("Error in refundPayment:", error);
    return res.status(500).json({ message: "Failed to process refund", error });
  }
};

const getSellerBalance = async (req, res) => {
  try {
    const userId = req.user.id;
    const seller = await db.seller.findFirst({
      where: { userId: +userId, User: { deleted: false } },
      select: { BankDetail: { select: { stripeBankAccountId: true } } },
    });

    if (!seller)
      return res.status(404).json({ message: "user not found", error });

    const balance = await stripe.balance.retrieve({
      stripeAccount: seller?.BankDetail?.stripeBankAccountId, // Pass the Connected Account ID
    });

    const availableBalance = balance?.available?.map((entry) => ({
      amount: entry?.amount / 100, // Convert cents to dollars
      currency: entry?.currency,
    }));

    const pendingBalance = balance?.pending?.map((entry) => ({
      amount: entry?.amount / 100, // Convert cents to dollars
      currency: entry?.currency,
    }));

    return res.status(200).json({ availableBalance, pendingBalance });
  } catch (error) {
    console.log("error in getSellerBlance:", error);
    return res.status(500).json({ message: "Internal server error!", error });
  }
};

const withdrawSellerBalance = async (req, res) => {
  try {
    const userId = req.user.id;
    const seller = await db.seller.findFirst({
      where: { userId: +userId, User: { deleted: false } },
      select: { BankDetail: { select: { stripeBankAccountId: true } } },
    });

    if (!seller)
      return res.status(404).json({ message: "user not found", error });

    const balance = await stripe.balance.retrieve({
      stripeAccount: seller.BankDetail.stripeBankAccountId, // Pass the Connected Account ID
    });

    const availableBalance =
      balance?.available.length > 0 && balance?.available[0];

    if (!availableBalance) {
      throw new Error("Insufficient available balance for withdrawal.");
    }

    // initiate payout
    await stripe.payouts.create(
      {
        amount: availableBalance.amount, // Amount in cents
        currency: availableBalance.currency,
      },
      {
        stripeAccount: seller.BankDetail.stripeBankAccountId, // Scope the payout to the connected account
      }
    );

    return res.status(200).json({ message: "Payout initiated successfully" });
  } catch (error) {
    console.log("error in getSellerBlance:", error);
    return res.status(500).json({ message: "Internal server error!", error });
  }
};

export {
  paymentIntent,
  setupIntent,
  saveCard,
  getCards,
  storePaymentDetails,
  refundPayment,
  getSellerBalance,
  withdrawSellerBalance,
};
