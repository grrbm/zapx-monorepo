/**
 * @swagger
 * /card-detail:
 *   post:
 *     summary: Retrieve bookings with payment method details
 *     tags:
 *       - Card Detail
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cardHolderName:
 *                 type: string
 *                 description: "Name of the cardholder"
 *                 example: "John Doe"
 *               cardNumber:
 *                 type: string
 *                 description: "Name of the card (e.g., Visa, MasterCard)"
 *                 example: "XXXXXXXXX"
 *               expiryDate:
 *                 type: string
 *                 description: "Expiry date of the card (format: YYYY/MM)"
 *                 example: "2025/12"
 *               cvvCvc:
 *                 type: string
 *                 description: "CVV/CVC code of the card"
 *                 example: "123"
 *               isPrimaryPaymentMethod:
 *                 type: boolean
 *                 description: "Indicates if this card is the primary payment method"
 *                 example: true
 *     responses:
 *       200:
 *         description: "Bookings retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: "Booking ID"
 *                   status:
 *                     type: string
 *                     description: "Status of the booking"
 *                   paymentDetails:
 *                     type: object
 *                     properties:
 *                       cardHolderName:
 *                         type: string
 *                       cardNumber:
 *                         type: string
 *                       expiryDate:
 *                         type: string
 *                       cvvCvc:
 *                         type: string
 *                       isPrimaryPaymentMethod:
 *                         type: boolean
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /card-detail:
 *   get:
 *     summary: Retrieve bookings with payment method details
 *     tags:
 *       - Card Detail
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: "Bookings retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: "Booking ID"
 *                   status:
 *                     type: string
 *                     description: "Status of the booking"
 *                   paymentDetails:
 *                     type: object
 *                     properties:
 *                       cardHolderName:
 *                         type: string
 *                       cardNumber:
 *                         type: string
 *                       expiryDate:
 *                         type: string
 *                       isPrimaryPaymentMethod:
 *                         type: boolean
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /card-detail/{cardId}:
 *   get:
 *     summary: Retrieve bookings with payment method details
 *     tags:
 *       - Card Detail
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - name: cardId
 *         in: path
 *         required: true
 *         description: The ID of the card to retrieve details for
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: "Bookings retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: "Booking ID"
 *                   status:
 *                     type: string
 *                     description: "Status of the booking"
 *                   paymentDetails:
 *                     type: object
 *                     properties:
 *                       cardHolderName:
 *                         type: string
 *                       cardNumber:
 *                         type: string
 *                       expiryDate:
 *                         type: string
 *                       isPrimaryPaymentMethod:
 *                         type: boolean
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /card-detail/{cardId}:
 *   patch:
 *     summary: Retrieve bookings with payment method details
 *     tags:
 *       - Card Detail
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - name: cardId
 *         in: path
 *         required: true
 *         description: The ID of the card to retrieve details for
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cardHolderName:
 *                 type: string
 *                 description: "Name of the cardholder"
 *                 example: "John Doe"
 *               cardNumber:
 *                 type: string
 *                 description: "Card number (e.g., Visa, MasterCard)"
 *                 example: "XXXXXXXXX"
 *               expiryDate:
 *                 type: string
 *                 description: "Expiry date of the card (format: YYYY/MM)"
 *                 example: "2025/12"
 *               cvvCvc:
 *                 type: string
 *                 description: "CVV/CVC code of the card"
 *                 example: "123"
 *               isPrimaryPaymentMethod:
 *                 type: boolean
 *                 description: "Indicates if this card is the primary payment method"
 *                 example: true
 *     responses:
 *       200:
 *         description: "Bookings retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: "Booking ID"
 *                   status:
 *                     type: string
 *                     description: "Status of the booking"
 *                   paymentDetails:
 *                     type: object
 *                     properties:
 *                       cardHolderName:
 *                         type: string
 *                       cardNumber:
 *                         type: string
 *                       expiryDate:
 *                         type: string
 *                       cvvCvc:
 *                         type: string
 *                       isPrimaryPaymentMethod:
 *                         type: boolean
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /card-detail/{cardId}:
 *   delete:
 *     summary: Retrieve bookings with payment method details
 *     tags:
 *       - Card Detail
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - name: cardId
 *         in: path
 *         required: true
 *         description: The ID of the card to retrieve details for
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: "Bookings retrieved successfully"
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: "Booking ID"
 *                   status:
 *                     type: string
 *                     description: "Status of the booking"
 *                   paymentDetails:
 *                     type: object
 *                     properties:
 *                       cardHolderName:
 *                         type: string
 *                       cardNumber:
 *                         type: string
 *                       expiryDate:
 *                         type: string
 *                       isPrimaryPaymentMethod:
 *                         type: boolean
 *       400:
 *         description: "Bad request - invalid or missing parameters"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
