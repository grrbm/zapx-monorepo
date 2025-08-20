import jwt from 'jsonwebtoken';
import db from '../db.js';
import { body, validationResult } from 'express-validator';
import { Role } from '@prisma/client';

const authMiddleware = (allowedRoles) => async (req, res, next) => {
  const token = req.header('authorization');
  if (!token) return res.status(401).json({ message: 'Access denied' });

  try {
    const decoded = jwt.verify(token, process.env.TOKEN_SECRET);
    const { id } = decoded;

    const validUser = await db.user.findFirst({
      where: {
        id: +id,
        deleted: false,
      },
      select: {
        id: true,
        role: true,
        deleted: true,
      },
    });

    if (!validUser) {
      return res.status(403).json({ message: 'User not found!' });
    }

    req.user = decoded;
    return allowedRoles.includes(validUser.role)
      ? next()
      : res.status(403).json({ message: 'Access denied!' });
  } catch (err) {
    return res.status(400).json({ message: 'invalid token!' });
  }
};

const authProfileMiddleware = (allowedRoles) => async (req, res, next) => {
  const token = req.header('authorization');
  if (!token) return res.status(401).json({ message: 'Access denied' });

  try {
    const decoded = jwt.verify(token, process.env.TOKEN_SECRET);
    const { id } = decoded;

    const validUser = await db.user.findFirst({
      where: {
        id: +id,
      },
      select: {
        id: true,
        role: true,
        deleted: true,
      },
    });

    if (!validUser) {
      return res.status(403).json({ message: 'Invalid user!' });
    }

    if (validUser?.deleted) {
      return res.status(403).json({ message: 'user not exists' });
    }

    req.user = decoded;
    return allowedRoles.includes(validUser.role)
      ? next()
      : res.status(403).json({ message: 'Access denied!' });
  } catch (err) {
    return res.status(400).json({ message: 'invalid token!' });
  }
};

const validateSignUp = [
  body('fullName').notEmpty().withMessage('username is required'),

  body('email').isEmail().withMessage('Invalid email format'),

  body('role').notEmpty().withMessage('role is required'),

  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/^(?=.*[!@#$%^])[a-zA-Z0-9!@#$%^]*$/)
    .withMessage(
      'Password must contain at least one special character (!, @, #, $, or %)'
    ),

  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        errors: errors.array().map((item) => {
          return { message: item?.msg };
        }),
      });
    }
    next();
  },
];

const validateLogIn = [
  body('email').isEmail().withMessage('Invalid email format'),

  body('password').notEmpty().withMessage('Password is required'),

  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        errors: errors.array().map((item) => {
          return { message: item?.msg };
        }),
      });
    }
    next();
  },
];

export { authMiddleware, authProfileMiddleware, validateSignUp, validateLogIn };
