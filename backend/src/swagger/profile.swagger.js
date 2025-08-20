/**
 * @swagger
 * /profile:
 *   post:
 *     summary: Create profile and verify ID (seller)
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: Upload the user's profile picture
 *               cardImage:
 *                 type: string
 *                 format: binary
 *                 description: Upload the user's ID card image
 *               services:
 *                 type: string
 *                 description: Service IDs must be sent as a stringified JSON array, e.g., "[1,2,3,4]"
 *               categoryId:
 *                 type: string
 *                 description: Category ID must be sent as a String, e.g., "1"
 *     responses:
 *       200:
 *         description: Profile created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Profile created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid input data"
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
 * /profile/bio:
 *   post:
 *     summary: Create Bio (seller)
 *     tags: [Bio]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: Upload the user's profile picture
 *               aboutMe:
 *                 type: string
 *                 description:  string
 *               location:
 *                 type: string
 *                 description:  string
 *     responses:
 *       200:
 *         description: created Bio successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Profile created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid input data"
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
 * /profile/bio:
 *   patch:
 *     summary: update Bio (seller)
 *     tags: [Bio]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               aboutMe:
 *                 type: string
 *                 description: descriptions
 *               location:
 *                 type: string
 *                 description: The user's location
 *     responses:
 *       200:
 *         description: Update Bio successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Update Bio successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid input data"
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
 * /profile/bio:
 *   get:
 *     summary: Get Bio (seller)
 *     tags: [Bio]
 *     responses:
 *       200:
 *         description: get the bio
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /profile/:
 *   get:
 *     summary: Get Profile (consumer)
 *     tags: [Profile]
 *     responses:
 *       200:
 *         description: get the  Profile
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
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
 * /profile/image:
 *   post:
 *     summary: Upload and create a profile image (Consumer) and (Seller)
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: The profile image to upload
 *     responses:
 *       200:
 *         description: Successfully created the file
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Created successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "User not found"
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
 * /profile:
 *   patch:
 *     summary: Update user profile details (consumer)
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               fullName:
 *                 type: string
 *                 description: The user's full name
 *               username:
 *                 type: string
 *                 description: The user's username
 *               phone:
 *                 type: string
 *                 description: The user's phone number
 *     responses:
 *       200:
 *         description: Successfully updated profile details
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Profile updated successfully"
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Invalid request parameters"
 *       404:
 *         description: User not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "User not found"
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
 * /profile/seller/{id}:
 *   get:
 *     summary: Get seller profile by seller ID
 *     tags: [Profile]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the seller whose profile to retrieve
 *     responses:
 *       200:
 *         description: Seller profile retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 User:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The user ID
 *                       example: 1
 *                     username:
 *                       type: string
 *                       description: The username of the user
 *                       example: "john_doe"
 *                     fullName:
 *                       type: string
 *                       description: The full name of the user
 *                       example: "John Doe"
 *                     email:
 *                       type: string
 *                       description: The email address of the user
 *                       example: "john.doe@example.com"
 *                     role:
 *                       type: string
 *                       description: The role of the user
 *                       example: "seller"
 *                     Seller:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: integer
 *                           description: The seller ID
 *                           example: 1
 *                         aboutMe:
 *                           type: string
 *                           description: About me description of the seller
 *                           example: "I am a professional artist with 10 years of experience"
 *                         location:
 *                           type: string
 *                           description: The location of the seller
 *                           example: "New York, USA"
 *                         _count:
 *                           type: object
 *                           properties:
 *                             Review:
 *                               type: integer
 *                               description: Number of reviews for the seller
 *                               example: 15
 *                     ProfileImage:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: integer
 *                           description: The profile image ID
 *                           example: 1
 *                         url:
 *                           type: string
 *                           description: The URL of the profile image
 *                           example: "http://example.com/profile.jpg"
 *                         mimeType:
 *                           type: string
 *                           description: The MIME type of the profile image
 *                           example: "image/jpeg"
 *                     _avg:
 *                       type: object
 *                       properties:
 *                         rating:
 *                           type: number
 *                           format: float
 *                           description: Average rating of the seller
 *                           example: 4.5
 *       400:
 *         description: Bad request - Seller ID is required or User not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     missing_id:
 *                       value: "Seller ID is required"
 *                     user_not_found:
 *                       value: "User is not found"
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
