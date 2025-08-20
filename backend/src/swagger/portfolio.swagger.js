/**
 * @swagger
 * /portfolio:
 *   post:
 *     summary: create a portfolio
 *     tags: [Portfolio]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *               - image
 *             properties:
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Images to be included in the portfolio (multiple files).
 *               title:
 *                 type: string
 *                 description: Title of the portfolio.
 *                 example: "My Art Portfolio"
 *     responses:
 *       200:
 *         description: Portfolio created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Portfolio created successfully!"
 *       400:
 *         description: Bad request, images are required
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Images is required!"
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
 * /portfolio:
 *   get:
 *     summary: get portfolios
 *     tags: [Portfolio]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         required: false
 *         description: Search query to filter portfolios by title
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           default: 0
 *         required: false
 *         description: Number of records to skip for pagination
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           default: 10
 *         required: false
 *         description: Number of records to return
 *     responses:
 *       200:
 *         description: A list of portfolios retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 portfolio:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: The ID of the portfolio
 *                         example: 1
 *                       title:
 *                         type: string
 *                         description: The title of the portfolio
 *                         example: "My Art Portfolio"
 *                       Images:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             url:
 *                               type: string
 *                               description: The URL of the image
 *                               example: "http://example.com/image.jpg"
 *                             mimeType:
 *                               type: string
 *                               description: The MIME type of the image
 *                               example: "image/jpeg"
 *                 count:
 *                   type: integer
 *                   description: Total number of portfolios found
 *                   example: 100
 *                 nextFrom:
 *                   type: integer
 *                   description: The starting point for the next page of results
 *                   example: 10
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
 * /portfolio/seller:
 *   get:
 *     summary: get portfolios
 *     tags: [Portfolio]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         required: false
 *         description: Search query to filter portfolios by title
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           default: 0
 *         required: false
 *         description: Number of records to skip for pagination
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           default: 10
 *         required: false
 *         description: Number of records to return
 *     responses:
 *       200:
 *         description: A list of portfolios retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 portfolio:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: The ID of the portfolio
 *                         example: 1
 *                       title:
 *                         type: string
 *                         description: The title of the portfolio
 *                         example: "My Art Portfolio"
 *                       Images:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             url:
 *                               type: string
 *                               description: The URL of the image
 *                               example: "http://example.com/image.jpg"
 *                             mimeType:
 *                               type: string
 *                               description: The MIME type of the image
 *                               example: "image/jpeg"
 *                 count:
 *                   type: integer
 *                   description: Total number of portfolios found
 *                   example: 100
 *                 nextFrom:
 *                   type: integer
 *                   description: The starting point for the next page of results
 *                   example: 10
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
 * /portfolio/seller/{id}:
 *   get:
 *     summary: Get portfolios by seller ID
 *     tags: [Portfolio]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the seller whose portfolios to retrieve
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         required: false
 *         description: Search term to filter portfolios by title (case-insensitive)
 *         example: "portfolio"
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *           default: 0
 *         required: false
 *         description: Number of records to skip for pagination
 *         example: 0
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *           default: 10
 *         required: false
 *         description: Number of records to retrieve
 *         example: 10
 *     responses:
 *       200:
 *         description: Portfolios retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 portfolio:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: The ID of the portfolio
 *                         example: 1
 *                       title:
 *                         type: string
 *                         description: The title of the portfolio
 *                         example: "My Art Portfolio"
 *                       Images:
 *                         type: array
 *                         description: Array of images associated with the portfolio
 *                         items:
 *                           type: object
 *                           properties:
 *                             url:
 *                               type: string
 *                               description: The URL of the image
 *                               example: "http://example.com/image.jpg"
 *                             mimeType:
 *                               type: string
 *                               description: The MIME type of the image
 *                               example: "image/jpeg"
 *                 count:
 *                   type: integer
 *                   description: Total number of portfolios matching the criteria
 *                   example: 25
 *                 nextFrom:
 *                   oneOf:
 *                     - type: integer
 *                       description: The starting point for the next page of results
 *                       example: 10
 *                     - type: boolean
 *                       description: False if there are no more results
 *                       example: false
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
 * /portfolio/{id}:
 *   get:
 *     summary: get a portfolio by id
 *     tags: [Portfolio]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the portfolio to be retrieved
 *     responses:
 *       200:
 *         description: Portfolio retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 portfolio:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the portfolio
 *                       example: 1
 *                     title:
 *                       type: string
 *                       description: The title of the portfolio
 *                       example: "My Art Portfolio"
 *                     Images:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           url:
 *                             type: string
 *                             description: The URL of the image
 *                             example: "http://example.com/image.jpg"
 *                           mimeType:
 *                             type: string
 *                             description: The MIME type of the image
 *                             example: "image/jpeg"
 *       404:
 *         description: Portfolio not found or ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Id required!"
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
 * /portfolio/{id}:
 *   patch:
 *     summary: update a portfolio by id
 *     tags: [Portfolio]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the portfolio to be updated
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *             properties:
 *               title:
 *                 type: string
 *                 description: New title for the portfolio
 *                 example: "Updated Art Portfolio"
 *     responses:
 *       200:
 *         description: Portfolio updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Portfolio updated successfully!"
 *       404:
 *         description: Portfolio not found or ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Id required!"
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
 * /portfolio/{id}:
 *   delete:
 *     summary: delete a portfolio by id
 *     tags: [Portfolio]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the portfolio to be deleted
 *     responses:
 *       200:
 *         description: Portfolio deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 portfolio:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the deleted portfolio
 *                       example: 1
 *                     deleted:
 *                       type: boolean
 *                       description: Indicates if the portfolio is marked as deleted
 *                       example: true
 *       404:
 *         description: Portfolio not found or ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "404 not found!"
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
