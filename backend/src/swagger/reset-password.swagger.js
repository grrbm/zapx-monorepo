/**
 * @swagger
 * /auth/reset-password:
 *   post:
 *     summary: reset password
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               password:
 *                 type: string
 *                 example: "*********"
 *               email:
 *                 type: string
 *                 example: "example@gmail.com"
 *     responses:
 *       200:
 *         description: password reset successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 password:
 *                   type: string
 *                   example: "*********"
 *                 email:
 *                   type: string
 *                   example: "example@gmail.com"
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
