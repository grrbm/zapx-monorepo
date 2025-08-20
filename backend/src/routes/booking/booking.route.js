import express from 'express';
import {
  bookingCanceled,
  bookingComplete,
  bookingConfirmed,
  createBooking,
  createExternalBooking,
  createOffer,
  deliveredBooking,
  getBookingbyId,
  getBookingOrder,
  getBookings,
  getDeliveredBooking,
  getDeliveredPictures,
  getPeopleBooked,
  offerDeclined,
  getOffers,
  updateBookingbyId,
  getOfferById,
} from '../../controller/booking/booking.controller.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import upload from '../../services/multer.service.js';
import { Role } from '@prisma/client';

const router = express.Router();

router.post(
  '/',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  upload.fields([{ name: 'image' }]),
  createBooking
);

router.post('/external', authMiddleware([Role.SELLER]), createExternalBooking);

router.post(
  '/confirmed/:bookingId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  bookingConfirmed
);

router.get(
  '/orders',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getBookingOrder
);

router.get(
  '/delivered',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getDeliveredBooking
);

router.get('/', authMiddleware([Role.CONSUMER, Role.SELLER]), getBookings);

router.get('/gallery', authMiddleware([Role.CONSUMER]), getDeliveredPictures);

router.get('/offers', authMiddleware([Role.SELLER, Role.CONSUMER]), getOffers);

router.get(
  '/people-booked-you',
  authMiddleware([Role.SELLER]),
  getPeopleBooked
);

router.get(
  '/:bookingId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  getBookingbyId
);
router.get(
  '/update/:bookingId',
  upload.fields([{ name: 'image' }]),
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  updateBookingbyId
);

router.post(
  '/delivery/:bookingId',
  authMiddleware([Role.SELLER]),
  upload.fields([{ name: 'image' }]),
  deliveredBooking
);

router.post(
  '/complete/:bookingId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  bookingComplete
);

router.post(
  '/canceled/:bookingId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  bookingCanceled
);

router.post(
  '/offer',
  authMiddleware([Role.SELLER]),
  upload.fields([{ name: 'image' }]),
  createOffer
);

router.get(
  '/offer/:offerId',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getOfferById
);

router.post(
  '/offer/declined/:bookingId',
  authMiddleware([Role.CONSUMER]),
  offerDeclined
);

export default router;
