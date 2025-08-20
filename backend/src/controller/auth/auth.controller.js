import db from '../../db.js';
import { generateOTP, sendAuthEmail } from '../../services/auth.service.js';
import bcrypt from 'bcrypt';
import Stripe from 'stripe';
import {
  assignToken,
  hashingPassword,
  verifyPassword,
} from '../../services/auth.service.js';
import { BookingStatus, Role } from '@prisma/client';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ message: 'Email is required!' });
    }

    // Check if the email exists in the database
    const user = await db.user.findFirst({
      where: {
        email: email.toLowerCase(), // Convert email to lowercase for case-insensitive search
        deleted: false,
      },
    });

    if (!user) {
      return res.status(400).json({
        message: `Account with this email "${email}" does not exist`,
      });
    }

    // Generate a 4-digit random OTP
    const otp = generateOTP();

    // Delete previous reset tokens for the user
    await db.passwordResetToken.deleteMany({
      where: { userId: user.id },
    });

    // Store the OTP in the database
    await db.passwordResetToken.create({
      data: {
        userId: user.id,
        token: otp, // Store the OTP directly
        expiresAt: new Date(Date.now() + 3600000), // 1 hour expiration
      },
    });

    const mailOptions = {
      from: process.env.EMAIL,
      to: email,
      subject: 'Zapx Reset Password',
      html: `Here is your OTP to reset your password: <b>${otp}</b>.<br/>It is valid for 1 hour.`,
    };

    // Try sending the email
    try {
      await sendAuthEmail(mailOptions, res);
      return res.status(200).json({
        message: 'If the email exists, a reset password OTP has been sent!',
      });
    } catch (error) {
      return res
        .status(500)
        .json({ message: error.message || 'Failed to send OTP' });
    }
  } catch (error) {
    console.log('error in forgotPassword ===>>>', error);
    return res.status(500).json({ message: 'Internal Server Error!', error });
  }
};

const verifyOTP = async (req, res) => {
  try {
    const { otp } = req.body;

    if (!otp) {
      return res.status(400).json({ message: 'OTP are required!' });
    }

    const user = await db.user.findFirst({
      where: {
        deleted: false,
        otp: {
          token: otp,
          expiresAt: { gte: new Date() },
        },
      },
    });

    if (!user) {
      return res.status(400).json({ message: 'Invalid Token!' });
    }

    // delete refresh token
    await db.passwordResetToken.delete({ where: { userId: user.id } });

    return res.status(200).json({ message: 'Code verify successfully' });
  } catch (error) {
    console.log('error in verifyOTP ====>>> ', error);
    return res.status(500).json({ message: 'Internal Server Error!' });
  }
};

const resetPassword = async (req, res) => {
  try {
    const { password, email } = req.body;

    if (!password || !email) {
      return res
        .status(400)
        .json({ message: 'Password and email are required!' });
    }

    const user = await db.user.findFirst({
      where: {
        deleted: false,
        email,
      },
    });

    if (!user) {
      return res.status(400).json({ message: 'User not found!' });
    }

    // hashing password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    await db.user.update({
      where: {
        id: user.id,
      },
      data: {
        password: hashedPassword,
      },
    });

    return res.status(200).json({ message: 'Password updated successfully' });
  } catch (error) {
    console.log('error in resetPassword ====>>> ', error);
    return res.status(500).json({ message: 'Internal Server Error!' });
  }
};

const signup = async (req, res) => {
  try {
    const { fullName, email, password, role } = req.body;

    // Check if user already exists
    const findUser = await db.user.findFirst({
      where: { email, deleted: false },
    });

    if (findUser) {
      return res.status(400).json({ message: 'User already exists!' });
    }

    // Hash the password
    const hashedPassword = await hashingPassword({ password });

    // Generate a unique username
    let username = fullName.toLowerCase().replace(/\s+/g, '');
    const randomSuffix = Math.floor(100 + Math.random() * 900); // Generate a random 3-digit number
    username = `${username}${randomSuffix}`;

    const findBooking = await db.booking.findFirst({
      where: {
        consumerEmail: email,
        status: BookingStatus.AWAITING_BOOKING_CONFIRMATION,
        deleted: false,
      },
    });

    const createUser = await db.user.create({
      data: {
        fullName,
        username,
        email,
        password: hashedPassword,
        role,
        ...(role === Role.CONSUMER && {
          Consumer: {
            create: {
              ...(findBooking && {
                Booking: {
                  connect: { id: findBooking?.id },
                },
              }),
            },
          },
        }),
      },
    });

    if (role === Role.CONSUMER) {
      const stripeCustomer = await stripe.customers.create({
        email: createUser.email, // Replace with user email or other identifying info
        metadata: {
          userId: createUser.id, // Map your user ID for easy reference
        },
      });
      const consumer = await db.consumer.findFirst({
        where: { deleted: false, userId: createUser.id },
      });

      await db.consumer.update({
        where: { id: consumer.id },
        data: { stripeCustomerId: stripeCustomer.id },
      });
    }

    // Generate a JWT token for the newly created user
    const token = assignToken({ id: createUser?.id });

    // Respond with success
    return res.status(200).json({
      message: 'User Created Successfully',
      response: {
        token,
        User: {
          id: createUser?.id,
          role: createUser?.role,
          email: createUser?.email,
        },
      },
    });
  } catch (err) {
    console.error('Signup error:', err); // Improved logging
    res
      .status(500)
      .json({ message: 'An error occurred during signup', error: err.message });
  }
};

const login = async (req, res) => {
  try {
    console.log('🔐 Login attempt started');
    console.log('📧 Email:', req.body.email);
    console.log('🔑 TOKEN_SECRET exists:', !!process.env.TOKEN_SECRET);
    
    const { email, password } = req.body;

    const user = await db.user.findFirst({
      where: {
        email,
        deleted: false,
      },
    });

    if (!user) {
      console.log('❌ User not found for email:', email);
      return res.status(400).json({ message: 'Invalid email or password!' });
    }

    console.log('✅ User found:', user.id);

    const validPassword = await verifyPassword({
      commingPassword: password,
      usersPassword: user.password,
    });

    if (!validPassword) {
      console.log('❌ Invalid password for user:', user.id);
      return res.status(400).json({
        message: 'Invalid email or password!',
      });
    }

    console.log('✅ Password valid, generating token...');
    
    try {
      const token = assignToken({ id: user.id });
      console.log('✅ Token generated successfully');
      
      const response = {
        token,
        User: {
          id: user.id,
          role: user.role,
          email: user.email,
        },
      };

      console.log('🎉 Login successful for user:', user.id);
      return res
        .status(200)
        .json({ message: 'You have logged in successfully', response });
    } catch (tokenError) {
      console.log('❌ Token generation failed:', tokenError.message);
      return res.status(500).json({ message: 'Failed to generate authentication token' });
    }
  } catch (err) {
    console.log('❌ Login error:', err.message);
    res.status(500).json({ message: err.message });
  }
};
const deleteUser = async (req, res) => {
  try {
    const userId = req?.user?.id;

    // Start a database transaction for data consistency
    await db.$transaction(async (tx) => {
      // 1. Check if user exists and is not already deleted
      const findUser = await tx.user.findUnique({
        where: {
          id: +userId,
          deleted: false,
        },
        include: {
          Seller: true,
          Consumer: true,
        },
      });

      if (!findUser) {
        throw new Error('User not found!');
      }

      // 2. Delete Seller-specific data if user is a seller
      if (findUser.Seller) {
        const sellerId = findUser?.Seller?.id;

        // Delete seller's bookings and related data
        const bookings = await tx.booking.findMany({
          where: { sellerId, deleted: false },
        });

        for (const booking of bookings) {
          // Delete booking files
          await tx.file.updateMany({
            where: {
              OR: [
                { exampleBookingImageId: booking?.id },
                { deliverBookingImageId: booking?.id },
              ],
            },
            data: { deleted: true },
          });

          // Delete booking notifications
          await tx.notification.updateMany({
            where: { bookingId: booking?.id },
            data: { deleted: true },
          });

          // Mark booking as deleted
          await tx.booking.update({
            where: { id: booking?.id },
            data: { deleted: true },
          });
        }

        // Delete seller's posts and related data
        const posts = await tx.post.findMany({
          where: { sellerId, deleted: false },
        });

        for (const post of posts) {
          // Delete post files
          await tx.file.updateMany({
            where: { postId: post?.id },
            data: { deleted: true },
          });

          // Delete post times
          await tx.time.updateMany({
            where: { postId: post?.id },
            data: { deleted: true },
          });

          // Delete post venues
          await tx.venue.updateMany({
            where: { postId: post?.id },
            data: { deleted: true },
          });

          // Delete post locations
          await tx.location.updateMany({
            where: { postId: post?.id },
            data: { deleted: true },
          });

          // Delete post reviews
          await tx.review.updateMany({
            where: { postId: post?.id },
            data: { deleted: true },
          });

          // Mark post as deleted
          await tx.post.update({
            where: { id: post?.id },
            data: { deleted: true },
          });
        }

        // Delete seller's portfolio and images
        const portfolios = await tx.portfolio.findMany({
          where: { sellerId, deleted: false },
        });

        for (const portfolio of portfolios) {
          // Delete portfolio files
          await tx.file.updateMany({
            where: { portfolioId: portfolio?.id },
            data: { deleted: true },
          });

          // Mark portfolio as deleted
          await tx.portfolio.update({
            where: { id: portfolio?.id },
            data: { deleted: true },
          });
        }

        // Delete seller's services
        await tx.services.updateMany({
          where: { sellerId, deleted: false },
          data: { deleted: true },
        });

        // Delete seller's scheduler
        const scheduler = await tx.scheduler.findUnique({
          where: { sellerId },
        });

        if (scheduler) {
          // Delete scheduler dates and times
          const schedulerDates = await tx.schedulerDate.findMany({
            where: { schedulerId: scheduler.id, deleted: false },
          });

          for (const schedDate of schedulerDates) {
            await tx.time.updateMany({
              where: { schedulerDateId: schedDate?.id },
              data: { deleted: true },
            });
          }

          await tx.schedulerDate.updateMany({
            where: { schedulerId: scheduler?.id },
            data: { deleted: true },
          });

          await tx.scheduler.update({
            where: { id: scheduler?.id },
            data: { deleted: true },
          });
        }

        // Delete seller's discount
        await tx.discount.updateMany({
          where: { sellerId, deleted: false },
          data: { deleted: true },
        });

        // Delete seller's bank details
        await tx.bankDetail.updateMany({
          where: { sellerId, deleted: false },
          data: { deleted: true },
        });

        // Delete seller's reviews
        await tx.review.updateMany({
          where: { sellerId, deleted: false },
          data: { deleted: true },
        });

        // Delete favorites related to seller
        await tx.favourite.updateMany({
          where: { sellerId, deleted: false },
          data: { deleted: true },
        });

        // Delete seller's images
        await tx.file.updateMany({
          where: {
            OR: [{ sellerImageId: sellerId }, { sellerCardImageId: sellerId }],
          },
          data: { deleted: true },
        });

        // Finally delete seller
        await tx.seller.update({
          where: { id: sellerId },
          data: { deleted: true },
        });
      }

      // 3. Delete Consumer-specific data if user is a consumer
      if (findUser.Consumer) {
        const consumerId = findUser?.Consumer?.id;

        // Delete consumer's bookings (they made)
        await tx.booking.updateMany({
          where: { consumerId, deleted: false },
          data: { deleted: true },
        });

        // Delete consumer's card details
        await tx.cardDetail.updateMany({
          where: { consumerId, deleted: false },
          data: { deleted: true },
        });

        // Delete consumer's favorites
        await tx.favourite.updateMany({
          where: { consumerId, deleted: false },
          data: { deleted: true },
        });

        // Delete consumer's reviews
        await tx.review.updateMany({
          where: { consumerId, deleted: false },
          data: { deleted: true },
        });

        // Finally delete consumer
        await tx.consumer.update({
          where: { id: consumerId },
          data: { deleted: true },
        });
      }

      // 4. Delete user's communications
      // Get user's messages
      const messages = await tx.message.findMany({
        where: { userId: +userId, deleted: false },
      });

      // Delete message files
      for (const message of messages) {
        await tx.file.updateMany({
          where: { messageId: message.id },
          data: { deleted: true },
        });
      }

      // Delete user's messages
      await tx.message.updateMany({
        where: { userId: +userId, deleted: false },
        data: { deleted: true },
      });

      // Delete user's calls
      await tx.call.deleteMany({
        where: {
          OR: [{ callerId: +userId }, { recipientId: +userId }],
        },
      });

      // Delete user's notifications
      await tx.notification.updateMany({
        where: {
          OR: [{ userId: +userId }, { Users: { some: { id: +userId } } }],
        },
        data: { deleted: true },
      });

      // Handle chats - mark as deleted if no other active users
      const userChats = await tx.chat.findMany({
        where: {
          Users: { some: { id: +userId } },
          deleted: false,
        },
        include: {
          Users: true,
        },
      });

      for (const chat of userChats) {
        const activeUsers = chat.Users.filter(
          (user) => !user?.deleted && user?.id !== +userId
        );

        if (activeUsers.length === 0) {
          // No other active users, delete the chat
          await tx.chat.update({
            where: { id: chat.id },
            data: { deleted: true },
          });
        }
      }

      // 5. Delete user's files (profile image)
      if (findUser.fileId) {
        await tx.file.update({
          where: { id: findUser?.fileId },
          data: { deleted: true },
        });
      }

      // 6. Delete password reset tokens
      await tx.passwordResetToken.updateMany({
        where: { userId: +userId },
        data: { deleted: true },
      });

      // 7. Finally, mark user as deleted
      await tx.user.update({
        where: { id: +userId },
        data: { deleted: true },
      });
    });

    return res.status(200).json({
      success: true,
      message: 'User deleted successfully!',
    });
  } catch (err) {
    console.log('Error deleting user:', err);
    return res.status(500).json({
      success: false,
      message: err.message || 'Failed to delete user',
    });
  }
};

export { login, signup, forgotPassword, verifyOTP, resetPassword, deleteUser };
