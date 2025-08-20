import express from 'express'
import { authMiddleware } from '../../middlewares/authMiddleware.js'
import { Role } from '@prisma/client'
import {
  createVenue,
  deleteVenue,
  getVenue,
  getVenueById,
  updateVenue,
} from '../../controller/venue/venue.controller.js'

const router = express.Router()

router.post('/', authMiddleware([Role.SELLER, Role.ADMIN]), createVenue)

router.get(
  '/',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getVenue
)

router.get('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), getVenueById)

router.delete('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), deleteVenue)

router.patch('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), updateVenue)

export default router
