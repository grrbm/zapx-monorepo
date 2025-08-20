/**
 * @swagger
 * /service-scheduler:
 *   post:
 *     summary: create a service scheduler
 *     tags: [Service Scheduler]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - services
 *               - schedulerDate
 *               - rate
 *               - categoryId
 *             properties:
 *               services:
 *                 type: array
 *                 description: List of service IDs to schedule
 *                 items:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the service
 *                       example: 1
 *               schedulerDate:
 *                 type: array
 *                 description: List of dates with times for scheduling
 *                 items:
 *                   type: object
 *                   properties:
 *                     date:
 *                       type: string
 *                       format: date
 *                       description: Date of the schedule
 *                       example: "2023-10-31T19:00:00.000Z"
 *                     times:
 *                       type: array
 *                       description: List of time slots for the date
 *                       items:
 *                         type: object
 *                         properties:
 *                           startTime:
 *                             type: string
 *                             format: time
 *                             description: Start time of the slot
 *                             example: "2023-10-31T19:00:00.000Z"
 *                           endTime:
 *                             type: string
 *                             format: time
 *                             description: End time of the slot
 *                             example: "2023-10-31T10:00:00.000Z"
 *                           rate:
 *                             type: number
 *                             description: Rate for the time slot
 *                             example: 50
 *               categoryId:
 *                 type: integer
 *                 description: The ID of the category
 *                 example: 2
 *     responses:
 *       200:
 *         description: Service scheduler created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Service-scheduler created successfully!"
 *       404:
 *         description: Required fields missing
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Required fields are missing: Please provide services, schedulerDate and time, rate, and categoryId."
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
 * /service-scheduler/{id}:
 *   patch:
 *     summary: Update a service scheduler by ID
 *     tags: [Service Scheduler]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the service scheduler to update
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               services:
 *                 type: array
 *                 description: List of service IDs to schedule
 *                 items:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: The ID of the service
 *                       example: 1
 *               schedulerDate:
 *                 type: array
 *                 description: List of dates with time slots for scheduling
 *                 items:
 *                   type: object
 *                   properties:
 *                     date:
 *                       type: string
 *                       format: date-time
 *                       description: Date of the schedule
 *                       example: "2023-10-31T19:00:00.000Z"
 *                     times:
 *                       type: array
 *                       description: List of time slots for the date
 *                       items:
 *                         type: object
 *                         properties:
 *                           startTime:
 *                             type: string
 *                             format: date-time
 *                             description: Start time of the slot
 *                             example: "2023-10-31T19:00:00.000Z"
 *                           endTime:
 *                             type: string
 *                             format: date-time
 *                             description: End time of the slot
 *                             example: "2023-10-31T20:00:00.000Z"
 *                           rate:
 *                             type: number
 *                             description: Rate for the time slot
 *                             example: 50
 *               categoryId:
 *                 type: integer
 *                 description: The ID of the category
 *                 example: 2
 *     responses:
 *       200:
 *         description: Service scheduler updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Service scheduler updated successfully!"
 *       400:
 *         description: Required fields missing or invalid input
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Required fields are missing"
 *       404:
 *         description: Scheduler not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Scheduler not found for this seller"
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
 * /service-scheduler/{id}:
 *   delete:
 *     summary: delete a service scheduler by id
 *     tags: [Service Scheduler]
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: The ID of the service scheduler to delete
 *     responses:
 *       200:
 *         description: Service scheduler deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 scheduler:
 *                   type: object
 *                   description: Deleted scheduler object
 *       404:
 *         description: ID not provided or scheduler not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   examples:
 *                     idRequired:
 *                       value: "Id required!"
 *                     schedulerNotFound:
 *                       value: "Scheduler not found!"
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
 * /service-scheduler:
 *   get:
 *     summary: Get all service schedulers with filters (consumer)
 *     tags:
 *       - Service Scheduler
 *     parameters:
 *       - name: minimumRate
 *         in: query
 *         description: Minimum rate for filtering
 *         required: false
 *         schema:
 *           type: number
 *       - name: maximumRate
 *         in: query
 *         description: Maximum rate for filtering
 *         required: false
 *         schema:
 *           type: number
 *       - name: categoryId
 *         in: query
 *         description: ID of the service category
 *         required: false
 *         schema:
 *           type: integer
 *       - name: serviceType
 *         in: query
 *         description: List of service types
 *         required: false
 *         schema:
 *           type: string
 *           example: '[{"id": 1}, {"id": 2}]'
 *       - name: locationTypeId
 *         in: query
 *         description: id in location Type
 *         required: false
 *         schema:
 *           type: string
 *           example: '0'
 *       - name: skip
 *         in: query
 *         description: Number of records to skip for pagination
 *         required: false
 *         schema:
 *           type: integer
 *           example: 0
 *       - name: take
 *         in: query
 *         description: Number of records to take for pagination
 *         required: false
 *         schema:
 *           type: integer
 *           example: 10
 *     responses:
 *       200:
 *         description: List of all service schedulers
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 serviceScheduler:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       Services:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Associated services
 *                       SchedulerDate:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             date:
 *                               type: string
 *                               format: date
 *                             Time:
 *                               type: array
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   id:
 *                                     type: integer
 *                                   startTime:
 *                                     type: string
 *                                     format: time
 *                                   endTime:
 *                                     type: string
 *                                     format: time
 *                                   rate:
 *                                     type: number
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
 * /service-scheduler/{sellerId}:
 *   get:
 *     summary: Get a service scheduler by sellerId
 *     tags:
 *       - Service Scheduler
 *     parameters:
 *       - in: path
 *         name: sellerId
 *         required: true
 *         description: The ID of the service scheduler
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Service scheduler retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 scheduler:
 *                   type: object
 *                   description: Service scheduler object
 *       404:
 *         description: ID not provided or scheduler not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   enum:
 *                     - "Id required!"
 *                     - "Scheduler not found!"
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
 * /service-scheduler/consumer/{schedulerId}:
 *   get:
 *     summary: Get a service scheduler by schedulerId
 *     tags:
 *       - Service Scheduler
 *     parameters:
 *       - in: path
 *         name: schedulerId
 *         required: true
 *         description: The ID of the service scheduler
 *         schema:
 *           type: integer
 *       - in: query
 *         name: viewType
 *         required: false
 *         description: Specify the type of data to retrieve
 *         schema:
 *           type: string
 *           enum:
 *             - PORTFOLIO
 *             - TIMESLOTS
 *             - REVIEWS
 *     responses:
 *       200:
 *         description: Service scheduler retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 scheduler:
 *                   type: object
 *                   description: Service scheduler object
 *       404:
 *         description: ID not provided or scheduler not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   enum:
 *                     - "Id required!"
 *                     - "Scheduler not found!"
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
