/**
 * @swagger
 * /services:
 *   post:
 *     summary: create a service
 *     tags: [Services]
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Service name
 *                 example: "Service Name"
 *               categoryId:
 *                 type: number
 *                 description: Category ID
 *                 example: "1"
 *             required:
 *               - name
 *               - categoryId
 *     responses:
 *       201:
 *         description: Service created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                     name:
 *                       type: string
 *                     categoryid:
 *                       type: string
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
 * /services:
 *   get:
 *     summary: get services
 *     tags: [Services]
 *     parameters:
 *       - in: query
 *         name: categoryId
 *         schema:
 *           type: string
 *         required: true
 *         description: The type of service requested (e.g., categoryId=1 )
 *         example: "1"
 *       - in: query
 *         name: skip
 *         schema:
 *           type: number
 *         required: false
 *         description: The number of items to skip (for pagination)
 *         example: 0
 *       - in: query
 *         name: take
 *         schema:
 *           type: number
 *         required: false
 *         description: The number of items to take (for pagination)
 *         example: 10
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         required: false
 *         description: A search query to filter the services
 *         example: "wedding"
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Services fetched successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 serviceType:
 *                   type: string
 *                   example: "VIDEO or PHOTO"
 *                 message:
 *                   type: string
 *                   example: "Services found"
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: string
 *                       name:
 *                         type: string
 *                       description:
 *                         type: string
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
