import express from 'express';
import { Server } from 'socket.io';
import http from 'http';
import setupSwagger from './swagger-setup.js';
import authRoute from './src/routes/auth/auth.route.js';
import profileRoute from './src/routes/profile/profile.route.js';
import categories from './src/routes/category/category.route.js';
import services from './src/routes/service/service.route.js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import bodyParser from 'body-parser';
import cors from 'cors';
import posts from './src/routes/post/post.route.js';
import locationRoute from './src/routes/location/location.route.js';
import venueRoute from './src/routes/venue/venue.routes.js';
import portfolioRoute from './src/routes/portfolio/portfolio.route.js';
import discountRoute from './src/routes/discount/discount.route.js';
import serviceSchedulerRoute from './src/routes/serviceScheduler/serviceScheduler.route.js';
import reviewsRoute from './src/routes/review/review.route.js';
import file from './src/routes/fileUpdate/fileUpdate.route.js';
import booking from './src/routes/booking/booking.route.js';
import favouriteRoute from './src/routes/favourite/favourite.route.js';
import chatRoute from './src/routes/chat/chat.route.js';
import stripeRoute from './src/routes/stripe/stripe.route.js';
import cardDetail from './src/routes/cardDetail/cardDetail.route.js';
import notificationRoute from './src/routes/notification/notification.route.js';
import bankDetailRoute from './src/routes/bankDetail/bankDetail.route.js';
import dashboard from './src/routes/dashboard/dashboard.route.js';
import { callSocket } from './src/services/socket.services.js';

const app = express();
dotenv.config();
app.use(cors({})); // todo - add origins
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: '*', // Ensure this matches your frontend URL
    methods: ['GET', 'POST'],
    credentials: true,
  },
});

app.use(express.json());
app.use(bodyParser.json({ limit: '150mb' }));
app.use(bodyParser.urlencoded({ limit: '150mb', extended: true }));

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const uploadsPath = path.join(__dirname, 'uploads'); // Ensure it is correctly pointing
app.use('/uploads', express.static(uploadsPath));
// Routes setup
app.use('/auth', authRoute);
app.use('/profile', profileRoute);
app.use('/category', categories);
app.use('/services', services);
app.use('/post', posts);
app.use('/location', locationRoute);
app.use('/venue', venueRoute);
app.use('/portfolio', portfolioRoute);
app.use('/discount', discountRoute);
app.use('/reviews', reviewsRoute);
app.use('/service-scheduler', serviceSchedulerRoute);
app.use('/file', file);
app.use('/booking', booking);
app.use('/like-unlike', favouriteRoute);
app.use('/chat', chatRoute);
app.use('/card-detail', cardDetail);
app.use('/notification', notificationRoute);
app.use('/bank-detail', bankDetailRoute);
app.use('/stripe', stripeRoute);
app.use('/dashboard', dashboard);

// Socket.IO Namespace and Rooms Setup
export const socketChat = io.of('/socket-chat');
export const socketMessage = io.of('/socket-message');

socketChat.on('connection', (socket) => {
  console.log(`User connected to the socket-chat namespace: ${socket.id}`);

  // user join room
  socket.on('joinRoom', ({ userId }) => {
    if (userId) {
      console.log(`User with ID ${userId} joined their room`);
      socket.join(userId);
    } else {
      console.log('joinRoom event received with no userId');
    }
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('Socket disconnected chat  ');
  });

  // Error handling
  socket.on('error', (err) => {
    console.error('Socket error:', err);
  });
});

socketMessage.on('connection', (socket) => {
  console.log(`User connected to the socket-message namespace: ${socket.id}`);

  socket.on('joinRoom', ({ chatId }) => {
    if (chatId) {
      console.log(`User joined room with ID: ${chatId}`);
      socket.join(chatId);
    } else {
      console.log('join-room event received with no roomId');
    }
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('Socket disconnected chat  ');
  });

  // Error handling
  socket.on('error', (err) => {
    console.error('Socket error:', err);
  });
});

export const notificationSocket = io.of('/socket-notifications');

notificationSocket.on('connection', (socket) => {
  console.log('user connected  new socket:', socket.id);
  socket.on('connect', () => {
    console.log('user is connect from notification socket', userId);
    console.log('User connected in notification socket', socket.id);
  });

  socket.on('joinRoom', ({ userId }) => {
    console.log('user is joining from notification socket', userId);
    console.log(`${userId} id of user room joined`);
    socket.join(userId);
  });

  socket.on('leaveRoom', ({ userId }) => {
    console.log(`------------------------ ${userId} id of user leave room`);
    socket.leave(userId);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected in socket chat', socket.id);
  });
});

export const socketCall = io.of('/socket-call');
callSocket(socketCall);

// Set up Swagger
const apiPaths = [
  './src/swagger/login.swagger.js',
  './src/swagger/signup.swagger.js',
  './src/swagger/deleteUser.swagger.js',
  './src/swagger/dashboard.swagger.js',
  './src/swagger/stripe.swagger.js',
  './src/swagger/send-email.swagger.js',
  './src/swagger/verify-otp.swagger.js',
  './src/swagger/reset-password.swagger.js',
  './src/swagger/category.swagger.js',
  './src/swagger/services.swagger.js',
  './src/swagger/profile.swagger.js',
  './src/swagger/post.swagger.js',
  './src/swagger/location.swagger.js',
  './src/swagger/venue.swagger.js',
  './src/swagger/portfolio.swagger.js',
  './src/swagger/discount.swagger.js',
  './src/swagger/scheduler.swagger.js',
  './src/swagger/review.swagger.js',
  './src/swagger/fileUpdate.swagger.js',
  './src/swagger/booking.swagger.js',
  './src/swagger/cardDetail.swagger.js',
  './src/swagger/favourite.swagger.js',
  './src/swagger/bankDetail.swagger.js',
  './src/swagger/chat.swagger.js',
  './src/swagger/notification.swagger.js',
];

app.get('/', async (req, res) =>
  res.status(200).json({ message: 'Zapx backend is running!' })
);

setupSwagger(app, apiPaths);

// Start server
const port = process.env.PORT || 5003;
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
  console.log(`Swagger docs at http://localhost:${port}/api-docs`);
});
