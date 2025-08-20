import express from 'express'
import { authMiddleware } from '../../middlewares/authMiddleware.js'
import { Role } from '@prisma/client'
import {
  createLocation,
  deleteLocation,
  getLocation,
  getLocationById,
  updateLocation,
} from '../../controller/location/location.controller.js'

const router = express.Router()

router.post('/', authMiddleware([Role.SELLER, Role.ADMIN]), createLocation)

router.get(
  '/',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getLocation
)

router.get(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getLocationById
)

router.delete(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  deleteLocation
)

router.patch(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  updateLocation
)

export default router
