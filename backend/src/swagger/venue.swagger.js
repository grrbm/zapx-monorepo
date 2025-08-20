/**
 * @swagger
 * /venue:
 *   post:
 *     summary: create a venue
 *     tags: [Venue Type]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *             properties:
 *               name:
 *                 type: string
 *                 description: Name of the venue.
 *                 example: "Concert Hall"
 *     responses:
 *       200:
 *         description: Venue created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Venue created successfully!"
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
 * /venue:
 *   get:
 *     summary: get venues
 *     tags: [Venue Type]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         required: false
 *         description: Search query to filter venues by name
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
 *         description: A list of venues retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 venue:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       name:
 *                         type: string
 *                         description: The name of the venue
 *                         example: "Concert Hall"
 *                 count:
 *                   type: integer
 *                   description: Total number of venues found
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
 * /venue/{id}:
 *   get:
 *     summary: get a venue by id
 *     tags: [Venue Type]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the venue
 *     responses:
 *       200:
 *         description: Venue retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 venue:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The venue ID
 *                       example: 1
 *                     name:
 *                       type: string
 *                       description: The name of the venue
 *                       example: "Concert Hall"
 *       404:
 *         description: Venue not found or ID not provided
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
 * /venue/{id}:
 *   patch:
 *     summary: update a venue by id
 *     tags: [Venue Type]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the venue to be updated
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *             properties:
 *               name:
 *                 type: string
 *                 description: New name of the venue
 *                 example: "Updated Concert Hall"
 *     responses:
 *       200:
 *         description: Venue updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Venue updated successfully!"
 *       404:
 *         description: Venue not found or ID not provided
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
 * /venue/{id}:
 *   delete:
 *     summary: delete a venue by id
 *     tags: [Venue Type]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the venue to be deleted
 *     responses:
 *       200:
 *         description: Venue deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 venue:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the deleted venue
 *                       example: 1
 *       404:
 *         description: Venue not found, ID not provided, or cannot delete venue with posts
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
