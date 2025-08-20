/**
 * @swagger
 * /like-unlike/seller/{sellerId}:
 *   post:
 *     summary: Save or unsave a category for a seller
 *     tags: [Like or Unlike]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: sellerId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the seller
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               isSaved:
 *                 type: boolean
 *                 description: Status to mark category as saved or unsaved (true or false)
 *                 example: true
 *     responses:
 *       200:
 *         description: Category saved or unsaved status updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
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
 * /like-unlike/seller:
 *   get:
 *     summary: Retrieve Liked  all sellers
 *     tags: [Like or Unlike]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Successfully retrieved saved category statuses
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       sellerId:
 *                         type: string
 *                         description: The ID of the seller
 *                       isSaved:
 *                         type: boolean
 *                         description: Status to mark category as saved or unsaved (true or false)
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
