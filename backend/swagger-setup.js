import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

/**
 * Set up Swagger for the application.
 * @param {Object} app - The Express application instance.
 * @param {Array<string>} apiPaths - The array of paths to Swagger documentation files.
 * @param {Object} [swaggerOptions] - Optional custom Swagger options.
 */
const setupSwagger = (app, apiPaths, swaggerOptions = {}) => {
  const defaultOptions = {
    swaggerDefinition: {
      openapi: '3.0.0',
      info: {
        title: 'My API',
        version: '1.0.0',
        description: 'API documentation',
      },
      servers: [
        {
          url: process.env.BACKEND_URL || 'http://localhost:5003',
        },
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'apiKey',
            in: 'header',
            name: 'Authorization',
            bearerFormat: 'JWT',
          },
        },
      },
      security: [
        {
          bearerAuth: [], // Apply globally or per route
        },
      ],
    },
    apis: apiPaths,
  };

  const finalOptions = { ...defaultOptions, ...swaggerOptions };
  const swaggerSpec = swaggerJsdoc(finalOptions);

  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
};

export default setupSwagger;
