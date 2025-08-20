/**
 * @swagger
 * /bank-detail:
 *   post:
 *     summary: Add bank details for a seller
 *     tags:
 *       - Bank Detail
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               cancellationFee:
 *                 type: string
 *                 description: "Fee charged for booking cancellation (optional)"
 *                 example: "25%.00"
 *               noShowFee:
 *                 type: string
 *                 description: "Fee charged for no-show (optional)"
 *                 example: "50%.00"
 *               country:
 *                 type: string
 *                 description: "Country"
 *                 example: "PK"
 *     responses:
 *       200:
 *         description: "Bank details successfully added"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Bank details added successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     accountHolderName:
 *                       type: string
 *                     accountNumber:
 *                       type: string
 *                     routingNumber:
 *                       type: string
 *                     cancellationFee:
 *                       type: number
 *                     noShowFee:
 *                       type: number
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
 * /bank-detail:
 *   get:
 *     summary: Retrieve bank details for a seller
 *     tags:
 *       - Bank Detail
 *     security:
 *       - bearerAuth: [] # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: "Bank details successfully retrieved"
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Bank details retrieved successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     accountHolderName:
 *                       type: string
 *                     accountNumber:
 *                       type: string
 *                     routingNumber:
 *                       type: string
 *                     cancellationFee:
 *                       type: string
 *                     noShowFee:
 *                       type: string
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
 * /bank-detail/{bankDetailId}:
 *   get:
 *     summary: Retrieve bank details for a specific bank detail ID
 *     tags: [Bank Detail]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bankDetailId
 *         required: true
 *         schema:
 *           type: string  # Assuming bankDetailId can be a string (e.g., UUID)
 *         description: The ID of the bank detail to retrieve
 *     responses:
 *       200:
 *         description: Bank details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Bank details retrieved successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     accountHolderName:
 *                       type: string
 *                     accountNumber:
 *                       type: string
 *                     routingNumber:
 *                       type: string
 *                     cancellationFee:
 *                       type: number
 *                     noShowFee:
 *                       type: number
 *       400:
 *         description: Bad request - invalid or missing parameters
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
 * /bank-detail/{bankDetailId}:
 *   patch:
 *     summary: Update bank details for a specific bank detail ID
 *     tags:
 *       - Bank Detail
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bankDetailId
 *         required: true
 *         schema:
 *           type: string  # Assuming bankDetailId can be a string (e.g., UUID)
 *         description: The ID of the bank detail to update
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               stripeBankAccountId:
 *                 type: string
 *                 description: The ID of the Stripe bank account
 *                 example: "acct_1ABCDEF1234567"
 *               cancelationFee:
 *                 type: string
 *                 description: The fee for cancellation
 *                 example: "50.00"
 *               noShowFee:
 *                 type: string
 *                 description: The fee for no-show
 *                 example: "25.00"
 *     responses:
 *       200:
 *         description: Bank details updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "update successfully"
 *       400:
 *         description: Bad request - invalid or missing parameters
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "bankDetailId not found!"
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
 * /bank-detail/{bankDetailId}:
 *   delete:
 *     summary: Delete bank details for a specific bank detail ID
 *     tags: [Bank Detail]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     parameters:
 *       - in: path
 *         name: bankDetailId
 *         required: true
 *         schema:
 *           type: string  # Assuming bankDetailId can be a string (e.g., UUID)
 *         description: The ID of the bank detail to delete
 *     responses:
 *       200:
 *         description: Bank details deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Bank details deleted successfully"
 *       400:
 *         description: Bad request - invalid or missing parameters
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
 *       404:
 *         description: Not Found - bank detail ID does not exist
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Bank detail not found"
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
