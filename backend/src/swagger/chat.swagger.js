/**
 * @swagger
 * /chat/message:
 *   post:
 *     summary: Send a message and files to a receiver
 *     tags:
 *       - Chat
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - receiverId
 *             properties:
 *               receiverId:
 *                 type: number
 *                 description: "The ID of the receiver"
 *                 example: 123
 *               message:
 *                 type: string
 *                 description: "Optional message content"
 *                 example: "Hello, how are you?"
 *               files:
 *                 type: array
 *                 description: "Array of files to upload"
 *                 items:
 *                   type: string
 *                   format: binary
 *     responses:
 *       200:
 *         description: "Message sent successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Message sent successfully"
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid receiverId or file format"
 *       401:
 *         description: "Unauthorized - missing or invalid token"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: "Internal server error"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred"
 */

/**
 * @swagger
 * /chat:
 *   get:
 *     summary: Retrieve  chat
 *     tags:
 *       - Chat
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: skip
 *         schema:
 *           type: number
 *           default: 0
 *         description: "Number of items to skip (default is 0)"
 *         example: 0
 *       - in: query
 *         name: take
 *         schema:
 *           type: number
 *           default: 10
 *         description: "Number of items to take (default is 10)"
 *         example: 10
 *     responses:
 *       200:
 *         description: "Chat messages retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       messageId:
 *                         type: string
 *                         description: "Unique identifier of the message"
 *                         example: "msg_12345"
 *                       senderId:
 *                         type: number
 *                         description: "ID of the message sender"
 *                         example: 123
 *                       receiverId:
 *                         type: number
 *                         description: "ID of the message receiver"
 *                         example: 456
 *                       message:
 *                         type: string
 *                         description: "The message content"
 *                         example: "Hello, how are you?"
 *                       timestamp:
 *                         type: string
 *                         format: date-time
 *                         description: "Timestamp of the message"
 *                         example: "2024-11-22T12:00:00Z"
 *       400:
 *         description: "Bad request - invalid query parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid skip or take parameters"
 *       401:
 *         description: "Unauthorized - missing or invalid token"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: "Internal server error"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred"
 */

/**
 * @swagger
 * /chat/{chatId}:
 *   get:
 *     summary: Retrieve chat messages for a specific chat
 *     tags:
 *       - Chat
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: chatId
 *         required: true
 *         schema:
 *           type: string
 *         description: "Unique identifier of the chat"
 *         example: "chat_12345"
 *       - in: query
 *         name: skip
 *         schema:
 *           type: number
 *           default: 0
 *         description: "Number of items to skip (default is 0)"
 *         example: 0
 *       - in: query
 *         name: take
 *         schema:
 *           type: number
 *           default: 10
 *         description: "Number of items to take (default is 10)"
 *         example: 10
 *     responses:
 *       200:
 *         description: "Chat messages retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       messageId:
 *                         type: string
 *                         description: "Unique identifier of the message"
 *                         example: "msg_12345"
 *                       senderId:
 *                         type: number
 *                         description: "ID of the message sender"
 *                         example: 123
 *                       receiverId:
 *                         type: number
 *                         description: "ID of the message receiver"
 *                         example: 456
 *                       message:
 *                         type: string
 *                         description: "The message content"
 *                         example: "Hello, how are you?"
 *                       timestamp:
 *                         type: string
 *                         format: date-time
 *                         description: "Timestamp of the message"
 *                         example: "2024-11-22T12:00:00Z"
 *       400:
 *         description: "Bad request - invalid parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid chatId, skip, or take parameters"
 *       401:
 *         description: "Unauthorized - missing or invalid token"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: "Internal server error"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred"
 */
