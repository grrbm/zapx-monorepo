/**
 * @swagger
 * /dashboard/insignt:
 *   get:
 *     summary: Get weekly booking insights
 *     description: Retrieve booking count, booked hours, and total revenue for the current week.
 *     tags:
 *          - Dashboard
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successful response with weekly insights
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 totalBookings:
 *                   type: integer
 *                   example: 12
 *                 totalHours:
 *                   type: number
 *                   example: 24.5
 *                 totalRevenue:
 *                   type: number
 *                   example: 1200.50
 *       401:
 *         description: Unauthorized - User must be authenticated as a seller
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /dashboard/graph:
 *   get:
 *     summary: Get weekly booking insights
 *     description: Retrieves the count of bookings per day of the week, grouped by status.
 *     tags:
 *       - Dashboard
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully retrieved insights
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   dayOfWeek:
 *                     type: integer
 *                     example: 3
 *                     description: Day of the week (0 = Sunday, 6 = Saturday)
 *                   status:
 *                     type: string
 *                     example: "CONFIRMED"
 *                     description: Booking status
 *                   slotcount:
 *                     type: integer
 *                     example: 2
 *                     description: Number of bookings for that day and status
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /dashboard/dailyRevenue:
 *   get:
 *     summary: Get weekly booking insights
 *     description: Retrieves the count of bookings per day of the week, grouped by status.
 *     tags:
 *       - Dashboard
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully retrieved insights
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   totalRevenue:
 *                     type: integer
 *                     example: 3
 *                     description: totalRevenue = 20
 *                   status:
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *       500:
 *         description: Internal Server Error
 */
/**
 * @swagger
 * /dashboard/todaySchedule:
 *   get:
 *     summary: Get today's scheduled bookings
 *     description: Retrieves the list of confirmed bookings for today, including details such as start time, end time, client name, and location.
 *     tags:
 *       - Dashboard
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully retrieved today's schedule
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 bookings:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         example: 1
 *                         description: Unique booking ID
 *                       startTime:
 *                         type: string
 *                         format: date-time
 *                         example: "2025-03-01T10:00:00Z"
 *                         description: Start time of the booking
 *                       endTime:
 *                         type: string
 *                         format: date-time
 *                         example: "2025-03-01T11:00:00Z"
 *                         description: End time of the booking
 *                       clientName:
 *                         type: string
 *                         example: "John Doe"
 *                         description: Name of the client
 *                       location:
 *                         type: string
 *                         example: "New York, NY"
 *                         description: Location of the booking
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /dashboard/todaySchedule:
 *   get:
 *     summary: Get today's scheduled bookings
 *     description: Retrieves the list of confirmed bookings for today, including details such as start time, end time, client name, and location.
 *     tags:
 *       - Dashboard
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully retrieved today's schedule
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 bookings:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         example: 1
 *                         description: Unique booking ID
 *                       startTime:
 *                         type: string
 *                         format: date-time
 *                         example: "2025-03-01T10:00:00Z"
 *                         description: Start time of the booking
 *                       endTime:
 *                         type: string
 *                         format: date-time
 *                         example: "2025-03-01T11:00:00Z"
 *                         description: End time of the booking
 *                       clientName:
 *                         type: string
 *                         example: "John Doe"
 *                         description: Name of the client
 *                       location:
 *                         type: string
 *                         example: "New York, NY"
 *                         description: Location of the booking
 *       401:
 *         description: Unauthorized - Missing or invalid token
 *       500:
 *         description: Internal Server Error
 */
