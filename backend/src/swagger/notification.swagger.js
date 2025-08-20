/**
 * @swagger
 * /notification:
 *   get:
 *     summary: Get all notifications for the logged-in user
 *     tags: [Notification]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           default: 0
 *         description: Number of records to skip for pagination
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Number of records to retrieve for pagination
 *     responses:
 *       200:
 *         description: Notifications retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 chats:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: Notification ID
 *                       description:
 *                         type: string
 *                         description: Notification description
 *                       type:
 *                         type: string
 *                         description: Type of the notification
 *                 count:
 *                   type: integer
 *                   description: Total number of notifications
 *                 nextFrom:
 *                   type: integer
 *                   nullable: true
 *                   description: Pagination indicator for the next set of notifications
 *       400:
 *         description: User not found or bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "User not found!"
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
 *                   example: "Internal server error"
 */

/**
 * @swagger
 * /notification/read-all-notification:
 *   post:
 *     summary: Mark all notifications as read for the logged-in user
 *     tags: [Notification]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully marked all notifications as read
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "All notifications marked as read!"
 *       400:
 *         description: User not found or bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "User not exist!"
 *       401:
 *         description: No unread notifications found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "There is no notifications to marked as read!"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Internal Server Error!"
 */
