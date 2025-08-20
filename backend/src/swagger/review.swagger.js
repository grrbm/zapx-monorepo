/**
 * @swagger
 * /reviews/user/{sellerId}:
 *   post:
 *     summary: create a review for a user
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: sellerId
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the user being reviewed
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - rating
 *             properties:
 *               rating:
 *                 type: integer
 *                 description: Rating given by the user
 *                 example: 5
 *               description:
 *                 type: string
 *                 description: Description of the review
 *                 example: "Great service!"
 *     responses:
 *       200:
 *         description: Review created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "review created successfully!"
 *       404:
 *         description: Required fields or user ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     idNotFound:
 *                       value: "id not found!"
 *                     missingFields:
 *                       value: "Required fields are rating and/or description."
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
 * /reviews/post/{id}:
 *   post:
 *     summary: create a review for a post
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the post being reviewed
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - rating
 *             properties:
 *               rating:
 *                 type: integer
 *                 description: Rating given to the post
 *                 example: 4
 *               description:
 *                 type: string
 *                 description: Description of the review
 *                 example: "Informative and well-written."
 *     responses:
 *       200:
 *         description: Review created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "review created successfully!"
 *       404:
 *         description: Required fields or post ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     idNotFound:
 *                       value: "id not found!"
 *                     missingFields:
 *                       value: "Please provide rating, description."
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
 * /reviews/booking/{id}:
 *   post:
 *     summary: create a review for a booking
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the booking being reviewed
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - rating
 *             properties:
 *               rating:
 *                 type: integer
 *                 description: Rating given to the booking
 *                 example: 5
 *               description:
 *                 type: string
 *                 description: Description of the review
 *                 example: "Excellent experience with the booking."
 *     responses:
 *       200:
 *         description: Review created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "review created successfully!"
 *       404:
 *         description: Required fields or booking ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     idNotFound:
 *                       value: "id not found!"
 *                     missingFields:
 *                       value: "Please provide rating, description."
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
 * /reviews/user/{id}:
 *   get:
 *     summary: Get reviews for a specific seller
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the seller whose reviews are being fetched.
 *       - in: query
 *         name: rating
 *         required: false
 *         schema:
 *           type: integer
 *           enum: [1, 2, 3, 4, 5]
 *         description: Optional filter to get reviews with a specific rating (1-5).
 *     responses:
 *       200:
 *         description: A list of reviews for the seller, optionally filtered by rating.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 reviews:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       rating:
 *                         type: integer
 *                         description: The rating of the review.
 *                       description:
 *                         type: string
 *                         description: The description of the review.
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                         description: The timestamp when the review was created.
 *       400:
 *         description: Invalid rating parameter (must be between 1 and 5).
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Rating must be between 1 and 5."
 *       404:
 *         description: No reviews found for the seller or seller ID not provided.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     sellerNotFound:
 *                       value: "Seller id not found!"
 *                     noReviews:
 *                       value: "No reviews found for this seller."
 *       500:
 *         description: Internal server error.
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
 * /reviews/post/{id}:
 *   get:
 *     summary: Get reviews for a specific post
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the post whose reviews are being fetched.
 *       - in: query
 *         name: rating
 *         required: false
 *         schema:
 *           type: integer
 *           enum: [1, 2, 3, 4, 5]
 *         description: Optional filter to get reviews with a specific rating (1-5).
 *     responses:
 *       200:
 *         description: A list of reviews for the post, optionally filtered by rating.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 reviews:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       rating:
 *                         type: integer
 *                         description: The rating of the review.
 *                       description:
 *                         type: string
 *                         description: The description of the review.
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                         description: The timestamp when the review was created.
 *       400:
 *         description: Invalid rating parameter (must be between 1 and 5).
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Rating must be between 1 and 5."
 *       404:
 *         description: No reviews found for the post or post ID not provided.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     postNotFound:
 *                       value: "Post not found!"
 *                     noReviews:
 *                       value: "No reviews found for this post."
 *       500:
 *         description: Internal server error.
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
 * /reviews/booking/{id}:
 *   get:
 *     summary: Get reviews for a specific booking
 *     tags: [Review]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the booking whose reviews are being fetched.
 *       - in: query
 *         name: rating
 *         required: false
 *         schema:
 *           type: integer
 *           enum: [1, 2, 3, 4, 5]
 *         description: Optional filter to get reviews with a specific rating (1-5).
 *     responses:
 *       200:
 *         description: A list of reviews for the booking, optionally filtered by rating.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 reviews:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       rating:
 *                         type: integer
 *                         description: The rating of the review.
 *                       description:
 *                         type: string
 *                         description: The description of the review.
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                         description: The timestamp when the review was created.
 *       400:
 *         description: Invalid rating parameter (must be between 1 and 5).
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Rating must be between 1 and 5."
 *       404:
 *         description: No reviews found for the booking or booking ID not provided.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     bookingNotFound:
 *                       value: "Booking not found!"
 *                     noReviews:
 *                       value: "No reviews found for this booking."
 *       500:
 *         description: Internal server error.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "An error occurred"
 */
