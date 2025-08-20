/**
 * @swagger
 * /discount:
 *   post:
 *     summary: create a discount
 *     tags: [Discount]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - percentage
 *               - startDate
 *               - endDate
 *               - startTime
 *               - endTime
 *             properties:
 *               percentage:
 *                 type: string
 *                 description: Discount percentage
 *                 example: "15"
 *               startDate:
 *                 type: string
 *                 format: date
 *                 description: Start date of the discount
 *                 example: "2024-10-24T19:30:00Z"
 *               endDate:
 *                 type: string
 *                 format: date
 *                 description: End date of the discount
 *                 example: "2024-10-24T19:30:00Z"
 *               startTime:
 *                 type: string
 *                 format: time
 *                 description: Start time for the discount each day
 *                 example: "2024-10-24T19:30:00Z"
 *               endTime:
 *                 type: string
 *                 format: time
 *                 description: End time for the discount each day
 *                 example: "2024-10-24T19:30:00Z"
 *     responses:
 *       200:
 *         description: Discount created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Discount created successfully!"
 *       404:
 *         description: Required fields are missing
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Required fields are missing: Please provide percentage, start date, end date, start time, or end time."
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
 * /discount/{id}:
 *   patch:
 *     summary: update a discount by id
 *     tags: [Discount]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the discount to be updated
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               percentage:
 *                 type: number
 *                 description: New discount percentage
 *                 example: "20"
 *               startDate:
 *                 type: string
 *                 format: date
 *                 description: New start date of the discount
 *                 example: "2024-10-24T19:30:00Z"
 *               endDate:
 *                 type: string
 *                 format: date
 *                 description: New end date of the discount
 *                 example: "2024-10-24T19:30:00Z"
 *               startTime:
 *                 type: string
 *                 format: time
 *                 description: New start time for the discount each day
 *                 example: "2024-10-24T19:30:00Z"
 *               endTime:
 *                 type: string
 *                 format: time
 *                 description: New end time for the discount each day
 *                 example: "2024-10-24T19:30:00Z"
 *     responses:
 *       200:
 *         description: Discount updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Discount updated successfully!"
 *       404:
 *         description: Discount not found or ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Id required! or Discount not found!"
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
 * /discount/{id}:
 *   delete:
 *     summary: delete a discount by id
 *     tags: [Discount]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the discount to be deleted
 *     responses:
 *       200:
 *         description: Discount deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 discount:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the deleted discount
 *                       example: 1
 *                     deleted:
 *                       type: boolean
 *                       description: Indicates if the discount is marked as deleted
 *                       example: true
 *       404:
 *         description: Discount not found or ID not provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Id required! or Discount not found!"
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
