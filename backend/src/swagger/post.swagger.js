/**
 * @swagger
 * /post:
 *   post:
 *     summary: create post
 *     tags: [Posts]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - image
 *               - Time
 *               - notes
 *               - description
 *               - hourlyRate
 *               - location
 *             properties:
 *               image:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Add multiple pictures.
 *               Time:
 *                 type: string
 *                 description: Stringified JSON array of objects containing start and end times as `DateTime`.
 *                 example: '[{"startTime":"2024-10-23T10:00:00Z", "endTime":"2024-10-23T12:00:00Z"}, {"startTime":"2024-10-23T13:00:00Z", "endTime":"2024-10-23T15:00:00Z"}]'
 *               notes:
 *                 type: string
 *                 description: Additional notes for the post.
 *               description:
 *                 type: string
 *                 description: Description of the post.
 *               hourlyRate:
 *                 type: string
 *                 description: The hourly rate for the service.
 *               location:
 *                 type: string
 *                 description: The location where the service is provided.
 *               LocationType:
 *                 type: string
 *                 description: Stringified JSON array of location types, each with an id and name.
 *                 example: '[{"id": 1}, {"id": 2}]'
 *               VenueType:
 *                 type: string
 *                 description: Stringified JSON array of venue types, each with an id and name.
 *                 example: '[{"id": 1}, {"id": 2}]'
 *     responses:
 *       200:
 *         description: Post created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Post created successfully"
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

//Get All Posts
/**
 * @swagger
 * /post:
 *   get:
 *     summary: Get posts with filters and pagination
 *     tags: [Posts]
 *     parameters:
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
 *         description: A search query to filter posts by name or description
 *         example: "conference"
 *       - in: query
 *         name: timeFrom
 *         schema:
 *           type: string
 *           format: date-time
 *         required: false
 *         description: The start time to filter posts by, in UTC format
 *         example: "2024-11-01T00:00:00Z"
 *       - in: query
 *         name: timeTo
 *         schema:
 *           type: string
 *           format: date-time
 *         required: false
 *         description: The end time to filter posts by, in UTC format
 *         example: "2024-11-30T23:59:59Z"
 *       - in: query
 *         name: locationType
 *         schema:
 *           type: string
 *           description: Comma-separated list of location types to filter posts by
 *         required: false
 *         example: "indoor,outdoor"
 *       - in: query
 *         name: venueType
 *         schema:
 *           type: string
 *           description: Comma-separated list of venue types to filter posts by
 *         required: false
 *         example: "conference,webinar"
 *       - in: query
 *         name: hourlyRateMin
 *         schema:
 *           type: string
 *         required: false
 *         description: Minimum hourly rate to filter posts by
 *         example: "50"
 *       - in: query
 *         name: hourlyRateMax
 *         schema:
 *           type: string
 *         required: false
 *         description: Maximum hourly rate to filter posts by
 *         example: "200"
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Posts fetched successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 posts:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: string
 *                       description:
 *                         type: string
 *                       hourlyRate:
 *                         type: string
 *                       location:
 *                         type: string
 *                       notes:
 *                         type: string
 *                       Images:
 *                         type: array
 *                         items:
 *                           type: object
 *                       LocationType:
 *                         type: array
 *                         items:
 *                           type: string
 *                       VenueType:
 *                         type: array
 *                         items:
 *                           type: string
 *                       Time:
 *                         type: array
 *                         items:
 *                           type: object
 *                       Review:
 *                         type: array
 *                         items:
 *                           type: object
 *                 count:
 *                   type: number
 *                 nextFrom:
 *                   type: number
 *                   description: The position of the next set of results (pagination)
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

//Get All Posts seller
/**
 * @swagger
 * /post/seller/{id}:
 *   get:
 *     summary: Get posts by seller ID with filters and pagination
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the seller whose posts to retrieve
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
 *         description: A search query to filter posts by location (case-insensitive)
 *         example: "New York"
 *       - in: query
 *         name: timeFrom
 *         schema:
 *           type: string
 *           format: date-time
 *         required: false
 *         description: The start time to filter posts by, in UTC format
 *         example: "2024-11-01T00:00:00Z"
 *       - in: query
 *         name: timeTo
 *         schema:
 *           type: string
 *           format: date-time
 *         required: false
 *         description: The end time to filter posts by, in UTC format
 *         example: "2024-11-30T23:59:59Z"
 *       - in: query
 *         name: locationType
 *         schema:
 *           type: string
 *           description: Comma-separated list of location types to filter posts by
 *         required: false
 *         example: "indoor,outdoor"
 *       - in: query
 *         name: venueType
 *         schema:
 *           type: string
 *           description: Comma-separated list of venue types to filter posts by
 *         required: false
 *         example: "conference,webinar"
 *     responses:
 *       200:
 *         description: Posts fetched successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 posts:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: The post ID
 *                         example: 1
 *                       description:
 *                         type: string
 *                         description: Description of the post
 *                         example: "Photography services for corporate events"
 *                       hourlyRate:
 *                         type: string
 *                         description: Hourly rate for the service
 *                         example: "$50/hour"
 *                       location:
 *                         type: string
 *                         description: Location of the service
 *                         example: "New York, NY"
 *                       notes:
 *                         type: string
 *                         description: Additional notes about the post
 *                         example: "Available on weekends"
 *                       Seller:
 *                         type: object
 *                         properties:
 *                           id:
 *                             type: integer
 *                             description: The seller ID
 *                             example: 1
 *                           Scheduler:
 *                             type: array
 *                             items:
 *                               type: object
 *                               properties:
 *                                 id:
 *                                   type: integer
 *                                   example: 1
 *                           User:
 *                             type: object
 *                             properties:
 *                               id:
 *                                 type: integer
 *                                 example: 1
 *                       Images:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Images associated with the post
 *                       LocationType:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Location types associated with the post
 *                       VenueType:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Venue types associated with the post
 *                       Time:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Time slots associated with the post
 *                       Review:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Reviews associated with the post
 *                 count:
 *                   type: integer
 *                   description: Total number of posts matching the criteria
 *                   example: 25
 *                 nextFrom:
 *                   oneOf:
 *                     - type: integer
 *                       description: The starting point for the next page of results
 *                       example: 10
 *                     - type: boolean
 *                       description: False if there are no more results
 *                       example: false
 *       404:
 *         description: Bad request - Seller ID is required
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
//Get postById
/**
 * @swagger
 * /post/{id}:
 *   get:
 *     summary: get post by id
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: number
 *         required: true
 *         description: Post Id
 *         example: 1
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Posts fetched successfully
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
 *                       id:
 *                         type: string
 *                       description:
 *                         type: string
 *                       hourlyRate:
 *                         type: string
 *                       location:
 *                         type: string
 *                       notes:
 *                         type: string
 *                       Review:
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

//Delete post
/**
 * @swagger
 * /post/{id}:
 *   delete:
 *     summary: delete post
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: number
 *         required: true
 *         description: Post Id
 *         example: 1
 *     security:
 *       - bearerAuth: []  # Requires Bearer token for authorization
 *     responses:
 *       200:
 *         description: Posts deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Post Deleted Successfully!"
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

//Update post
/**
 * @swagger
 * /post/{id}:
 *   patch:
 *     summary: update post
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID of the post to update
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               location:
 *                 type: string
 *                 description: The location where the service is provided.
 *               description:
 *                 type: string
 *                 description: Description of the post.
 *               notes:
 *                 type: string
 *                 description: Additional notes for the post.
 *               hourlyRate:
 *                 type: string
 *                 description: The hourly rate for the service.
 *               Time:
 *                 type: array
 *                 description: An array of objects containing start and end times for the post.
 *                 items:
 *                   type: object
 *                   properties:
 *                     startTime:
 *                       type: string
 *                       format: date-time
 *                       description: The start time of the service.
 *                     endTime:
 *                       type: string
 *                       format: date-time
 *                       description: The end time of the service.
 *                 example: '[{"startTime": "2024-10-23T10:00:00Z", "endTime": "2024-10-23T12:00:00Z"}]'
 *               LocationType:
 *                 type: array
 *                 description: An array of location types, each with an id.
 *                 items:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: ID of the location type.
 *                 example: '[{"id": 1}, {"id": 2}]'
 *               VenueType:
 *                 type: array
 *                 description: An array of venue types, each with an id.
 *                 items:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: ID of the venue type.
 *                 example: '[{"id": 1}, {"id": 2}]'
 *     responses:
 *       200:
 *         description: Post updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Post updated successfully!"
 *       404:
 *         description: ID required
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
