/**
 * @swagger
 * /booking:
 *   post:
 *     summary: Create a booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 description: Start time of the service
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 description: End time of the service
 *               deliveryDate:
 *                 type: string
 *                 format: date
 *                 description: Delivery date of the service
 *               notes:
 *                 type: string
 *                 description: Additional notes for the service
 *               description:
 *                 type: string
 *                 description: Description of the service
 *               date:
 *                 type: string
 *                 format: date
 *                 description: Date of the service
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Example Pictures
 *               location:
 *                 type: string
 *                 description: Location details of the service
 *               reminderTime:
 *                 type: string
 *                 format: date-time
 *                 description: Reminder time for the service
 *               sellerId:
 *                 type: number
 *                 description: ID of the seller
 *               consumerId:
 *                 type: number
 *                 description: ID of the consumer (optional)
 *     responses:
 *       200:
 *         description: Service created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Service created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized, missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/external:
 *   post:
 *     summary: Create an external booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 description: Start time of the service
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 description: End time of the service
 *               deliveryDate:
 *                 type: string
 *                 format: date
 *                 description: Delivery date of the service
 *               notes:
 *                 type: string
 *                 description: Additional notes for the service
 *               description:
 *                 type: string
 *                 description: Description of the service
 *               date:
 *                 type: string
 *                 format: date
 *                 description: Date of the service
 *               location:
 *                 type: string
 *                 description: Location details of the service
 *               price:
 *                 type: string
 *                 description: Total price
 *               sellerId:
 *                 type: number
 *                 description: ID of the seller
 *               clientName:
 *                 type: string
 *                 description: Name of the client
 *               consumerEmail:
 *                 type: string
 *                 format: email
 *                 description: Email address of the consumer
 *     responses:
 *       200:
 *         description: Service created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Service created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized, missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/confirmed/{bookingId}:
 *   post:
 *     summary: Confirm Booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the booking
 *       - in: query
 *         name: cardId
 *         required: false
 *         schema:
 *           type: string  # Changed from number to string for consistency with card ID format
 *         description: The ID of the card to be used for payment
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object  # Added schema definition for the request body
 *             properties:
 *               additionalInfo:
 *                 type: string
 *                 description: "Any additional information required to confirm the booking"
 *                 example: "Confirming with card details."
 *     responses:
 *       200:
 *         description: Booking confirmed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 status:
 *                   type: string
 *                   example: "COMPLETE"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking:
 *   get:
 *     summary: Retrieve bookings
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         required: true
 *         description: Start date for filtering bookings
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         required: true
 *         description: End date for filtering bookings
 *     responses:
 *       200:
 *         description: Bookings retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/{bookingId}:
 *   get:
 *     summary: Retrieve a booking by ID
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID of the booking to retrieve
 *     responses:
 *       200:
 *         description: Booking retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 date:
 *                   type: string
 *                   format: date
 *                   description: Booking date
 *                 notes:
 *                   type: string
 *                   description: Notes for the booking
 *                 description:
 *                   type: string
 *                   description: Description of the booking
 *                 startTime:
 *                   type: string
 *                   format: time
 *                   description: Start time of the booking
 *                 endTime:
 *                   type: string
 *                   format: time
 *                   description: End time of the booking
 *                 totalPrice:
 *                   type: number
 *                   description: Total price of the booking
 *                 status:
 *                   type: string
 *                   description: Current status of the booking
 *                 location:
 *                   type: string
 *                   description: Location of the booking
 *                 reminderTime:
 *                   type: string
 *                   format: time
 *                   description: Reminder time for the booking
 *                 clientName:
 *                   type: string
 *                   description: Name of the client
 *                 bookingReferenceId:
 *                   type: string
 *                   description: Booking reference ID
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/orders:
 *   get:
 *     summary: Retrieve filtered bookings by status
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: filterStatus
 *         schema:
 *           type: string
 *           enum: [OUTSTANDING, INPROGRESS, COMPLETE]
 *         description: Filter bookings by status (outstanding, inprogress, or complete)
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           minimum: 0
 *         description: Number of results to skip for pagination
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           minimum: 1
 *         description: Number of results to retrieve for pagination
 *     responses:
 *       200:
 *         description: Bookings retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: Booking ID
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/delivery/{bookingId}:
 *   post:
 *     summary: delivery details for a booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - name: bookingId
 *         in: path
 *         required: true
 *         description: ID of the booking to update
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               message:
 *                 type: string
 *                 description: Message regarding the delivery
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Delivery images
 *     responses:
 *       200:
 *         description: Delivery details updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Delivery details updated successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized, missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/delivered:
 *   get:
 *     summary: Retrieve delivered bookings
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           description: Number of items to skip (for pagination)
 *         required: false
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           description: Number of items to take (for pagination)
 *         required: false
 *     responses:
 *       200:
 *         description: Bookings retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     description: Booking ID
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/complete/{bookingId}:
 *   post:
 *     summary: Retrieve a delivered booking by ID with status COMPLETE
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the booking
 *     responses:
 *       200:
 *         description: Booking retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 status:
 *                   type: string
 *                   example: COMPLETE
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/gallery:
 *   get:
 *     summary: Get gallery pictures for a booking
 *     tags: [Booking]
 *     parameters:
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           description: Number of items to skip (for pagination)
 *         required: false
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           description: Number of items to take (for pagination)
 *         required: false
 *     responses:
 *       200:
 *         description: Gallery pictures retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 images:
 *                   type: array
 *                   items:
 *                     type: string
 *                     description: URL of gallery image
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/canceled/{bookingId}:
 *   post:
 *     summary: Canceled Booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the booking
 *     responses:
 *       200:
 *         description: Booking retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 status:
 *                   type: string
 *                   example: COMPLETE
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/offer:
 *   post:
 *     summary: Create a booking offer
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               startTime:
 *                 type: string
 *                 format: date-time
 *                 description: Start time of the service
 *               endTime:
 *                 type: string
 *                 format: date-time
 *                 description: End time of the service
 *               deliveryDate:
 *                 type: string
 *                 format: date
 *                 description: Delivery date of the service
 *               notes:
 *                 type: string
 *                 description: Additional notes for the service
 *               description:
 *                 type: string
 *                 description: Description of the service
 *               date:
 *                 type: string
 *                 format: date
 *                 description: Date of the service
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Example pictures
 *               location:
 *                 type: string
 *                 description: Location details of the service
 *               price:
 *                 type: string
 *                 description: Total price
 *               sellerId:
 *                 type: number
 *                 description: ID of the seller
 *               consumerId:
 *                 type: number
 *                 description: ID of the consumer (optional)
 *     responses:
 *       200:
 *         description: Service created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Service created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized, missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/offers:
 *   get:
 *     summary: Get booking offers
 *     description: Retrieve booking offers filtered by time slots and date. Returns offers that overlap with the specified time range.
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: startTime
 *         schema:
 *           type: string
 *           format: date-time
 *         description: Start time to filter offers (ISO 8601 format)
 *         example: "2024-12-01T10:00:00Z"
 *       - in: query
 *         name: endTime
 *         schema:
 *           type: string
 *           format: date-time
 *         description: End time to filter offers (ISO 8601 format)
 *         example: "2024-12-01T12:00:00Z"
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *         description: Specific date to filter offers (ISO 8601 format)
 *         example: "2025-06-29T19:00:00.000Z"
 *     responses:
 *       200:
 *         description: Offers retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 offers:
 *                   type: array
 *                   description: Array of booking offers
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: number
 *                         description: Booking offer ID
 *                       startTime:
 *                         type: string
 *                         format: date-time
 *                         description: Start time of the offer
 *                       endTime:
 *                         type: string
 *                         format: date-time
 *                         description: End time of the offer
 *                       date:
 *                         type: string
 *                         format: date-time
 *                         description: Date of the offer
 *                       status:
 *                         type: string
 *                         description: Booking status (OFFER)
 *                       price:
 *                         type: string
 *                         description: Price of the offer
 *                       description:
 *                         type: string
 *                         description: Description of the service
 *                       location:
 *                         type: string
 *                         description: Location details
 *                       notes:
 *                         type: string
 *                         description: Additional notes
 *                       deleted:
 *                         type: boolean
 *                         description: Deletion status
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                         description: Creation timestamp
 *                       updatedAt:
 *                         type: string
 *                         format: date-time
 *                         description: Last update timestamp
 *             example:
 *               offers:
 *                 - id: 1
 *                   startTime: "2024-12-01T10:00:00Z"
 *                   endTime: "2024-12-01T12:00:00Z"
 *                   date: "2024-12-01T00:00:00Z"
 *                   status: "OFFER"
 *                   price: "100.00"
 *                   description: "House cleaning service"
 *                   location: "123 Main St"
 *                   notes: "Please have keys ready"
 *                   deleted: false
 *                   createdAt: "2024-11-15T08:30:00Z"
 *                   updatedAt: "2024-11-15T08:30:00Z"
 *       400:
 *         description: Bad request - Seller not found or invalid parameters
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Seller not found!"
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred while fetching offers"
 */

/**
 * @swagger
 * /booking/offer/{offerId}:
 *   get:
 *     summary: Get booking offer by ID
 *     description: Retrieve a specific booking offer by its ID. Access is restricted based on user role (seller can only access their offers, consumer can only access offers made to them).
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: offerId
 *         required: true
 *         schema:
 *           type: integer
 *           minimum: 1
 *         description: Unique identifier of the booking offer
 *         example: 123
 *     responses:
 *       200:
 *         description: Offer retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 offer:
 *                   type: object
 *                   description: Booking offer details
 *                   properties:
 *                     description:
 *                       type: string
 *                       description: Description of the service
 *                       example: "Professional house cleaning service"
 *                     notes:
 *                       type: string
 *                       description: Additional notes for the service
 *                       example: "Please have cleaning supplies ready"
 *                     message:
 *                       type: string
 *                       description: Message from seller/consumer
 *                       example: "Looking forward to providing excellent service"
 *                     date:
 *                       type: string
 *                       format: date-time
 *                       description: Date of the service
 *                       example: "2024-12-01T00:00:00Z"
 *                     deliveryDate:
 *                       type: string
 *                       format: date-time
 *                       description: Delivery date of the service
 *                       example: "2024-12-01T18:00:00Z"
 *                     startTime:
 *                       type: string
 *                       format: date-time
 *                       description: Start time of the service
 *                       example: "2024-12-01T10:00:00Z"
 *                     endTime:
 *                       type: string
 *                       format: date-time
 *                       description: End time of the service
 *                       example: "2024-12-01T14:00:00Z"
 *                     stripePaymentIntentId:
 *                       type: string
 *                       description: Stripe payment intent ID
 *                       example: "pi_3MtwBwLkdIwHu7ix28a3tqPa"
 *                     totalPrice:
 *                       type: string
 *                       description: Total price of the service
 *                       example: "150.00"
 *                     clientName:
 *                       type: string
 *                       description: Name of the client
 *                       example: "John Smith"
 *                     location:
 *                       type: string
 *                       description: Location details of the service
 *                       example: "123 Main Street, City, ZIP"
 *                     consumerEmail:
 *                       type: string
 *                       format: email
 *                       description: Email address of the consumer
 *                       example: "john.smith@email.com"
 *                     reminderTime:
 *                       type: string
 *                       format: date-time
 *                       description: Reminder time for the service
 *                       example: "2024-12-01T09:00:00Z"
 *                     bookingReferenceId:
 *                       type: string
 *                       description: Booking reference ID
 *                       example: "BK-2024-001234"
 *                     Seller:
 *                       type: object
 *                       description: Seller information
 *                       properties:
 *                         id:
 *                           type: integer
 *                           description: Seller ID
 *                           example: 1
 *                         name:
 *                           type: string
 *                           description: Seller name
 *                           example: "ABC Cleaning Services"
 *                         email:
 *                           type: string
 *                           format: email
 *                           description: Seller email
 *                           example: "contact@abccleaning.com"
 *                         phone:
 *                           type: string
 *                           description: Seller phone number
 *                           example: "+1234567890"
 *                         rating:
 *                           type: number
 *                           format: float
 *                           description: Seller rating
 *                           example: 4.5
 *                         deleted:
 *                           type: boolean
 *                           description: Deletion status
 *                           example: false
 *                     Consumer:
 *                       type: object
 *                       description: Consumer information
 *                       properties:
 *                         id:
 *                           type: integer
 *                           description: Consumer ID
 *                           example: 2
 *                         name:
 *                           type: string
 *                           description: Consumer name
 *                           example: "John Smith"
 *                         email:
 *                           type: string
 *                           format: email
 *                           description: Consumer email
 *                           example: "john.smith@email.com"
 *                         phone:
 *                           type: string
 *                           description: Consumer phone number
 *                           example: "+1234567891"
 *                         deleted:
 *                           type: boolean
 *                           description: Deletion status
 *                           example: false
 *             example:
 *               offer:
 *                 description: "Professional house cleaning service"
 *                 notes: "Please have cleaning supplies ready"
 *                 message: "Looking forward to providing excellent service"
 *                 date: "2024-12-01T00:00:00Z"
 *                 deliveryDate: "2024-12-01T18:00:00Z"
 *                 startTime: "2024-12-01T10:00:00Z"
 *                 endTime: "2024-12-01T14:00:00Z"
 *                 stripePaymentIntentId: "pi_3MtwBwLkdIwHu7ix28a3tqPa"
 *                 totalPrice: "150.00"
 *                 clientName: "John Smith"
 *                 location: "123 Main Street, City, ZIP"
 *                 consumerEmail: "john.smith@email.com"
 *                 reminderTime: "2024-12-01T09:00:00Z"
 *                 bookingReferenceId: "BK-2024-001234"
 *                 Seller:
 *                   id: 1
 *                   name: "ABC Cleaning Services"
 *                   email: "contact@abccleaning.com"
 *                   phone: "+1234567890"
 *                   rating: 4.5
 *                   deleted: false
 *                 Consumer:
 *                   id: 2
 *                   name: "John Smith"
 *                   email: "john.smith@email.com"
 *                   phone: "+1234567891"
 *                   deleted: false
 *       400:
 *         description: Bad request - User not found or offerId missing
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *               examples:
 *                 userNotFound:
 *                   summary: User not found
 *                   value:
 *                     message: "User not found!"
 *                 missingOfferId:
 *                   summary: Missing offer ID
 *                   value:
 *                     message: "offerId is required!"
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       403:
 *         description: Forbidden - User doesn't have access to this offer
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Access denied to this offer"
 *       404:
 *         description: Not found - Offer doesn't exist or has been deleted
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Offer not found"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred while fetching the offer"
 */

/**
 * @swagger
 * /booking/offer/declined/{bookingId}:
 *   post:
 *     summary: Declined Booking
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the booking
 *     responses:
 *       200:
 *         description: Booking retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 status:
 *                   type: string
 *                   example: COMPLETE
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/people-booked-you:
 *   get:
 *     summary: Get people who booked
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *         required: false
 *         description: Number of records to skip for pagination
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *         required: false
 *         description: Number of records to take for pagination
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *         required: false
 *         description: Filter by date in start or day
 *     responses:
 *       200:
 *         description: Booking retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                   description: Booking ID
 *                 status:
 *                   type: string
 *                   example: COMPLETE
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
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
 * /booking/update/{bookingId}:
 *   patch:
 *     summary: Update booking by ID
 *     tags: [Booking]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bookingId
 *         required: true
 *         schema:
 *           type: integer
 *         description: The ID of the booking to update
 *     requestBody:
 *       required: false
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               description:
 *                 type: string
 *                 description: Updated description for the booking
 *               notes:
 *                 type: string
 *                 description: Updated notes for the booking
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Array of image files to upload
 *     responses:
 *       200:
 *         description: Booking updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Booking updated successfully"
 *       400:
 *         description: Bad request - booking ID required or booking not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "bookingId is required!"
 *       401:
 *         description: Unauthorized - missing or invalid token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Unauthorized access"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred"
 */
