import express from 'express'
import { authMiddleware } from '../../middlewares/authMiddleware.js'
import { Role } from '@prisma/client'
import {
  createDiscount,
  deleteDiscount,
  updateDiscount,
} from '../../controller/discount/discount.controller.js'

const router = express.Router()

router.post('/', authMiddleware([Role.SELLER, Role.ADMIN]), createDiscount)

router.delete('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), deleteDiscount)

router.patch('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), updateDiscount)

export default router
