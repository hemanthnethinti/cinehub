process.env.NODE_ENV = 'test';
process.env.APP_URL = 'http://localhost:5000';
process.env.CLIENT_URL = 'http://localhost:3000';
process.env.MONGODB_URI = 'mongodb://127.0.0.1:27017/cinehub-test';
process.env.JWT_ACCESS_SECRET = 'test-access-secret-with-at-least-thirty-two-characters';
process.env.JWT_REFRESH_SECRET = 'test-refresh-secret-with-at-least-thirty-two-characters';

const request = require('supertest');
const app = require('../src/app');
const User = require('../src/models/user.model');

describe('CineHub API application', () => {
  test('excludes authentication secrets from user queries by default', () => {
    expect(User.schema.path('password').options.select).toBe(false);
    expect(User.schema.path('refreshToken').options.select).toBe(false);
  });

  test('serves application metadata without a database connection', async () => {
    const response = await request(app).get('/').expect(200);

    expect(response.body).toMatchObject({
      name: 'CineHub',
      version: '1.0.0',
      status: 'running',
    });
  });

  test('serves the versioned API root', async () => {
    const response = await request(app).get('/api/v1').expect(200);

    expect(response.body).toEqual({
      status: 'success',
      message: 'CineHub API is running',
    });
  });

  test('reports a disconnected database before bootstrap', async () => {
    const response = await request(app).get('/api/v1/health').expect(200);

    expect(response.body.status).toBe('ok');
    expect(response.body.database).toMatchObject({
      connected: false,
      state: 'disconnected',
    });
  });

  test('rejects malformed registration data before accessing MongoDB', async () => {
    const response = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'not-an-email', password: 'weak' })
      .expect(400);

    expect(response.body).toMatchObject({
      status: 'error',
      statusCode: 400,
      code: 'VALIDATION_ERROR',
      message: 'Validation failed',
    });
    expect(response.body.errors.length).toBeGreaterThan(0);
  });

  test('does not expose the unauthenticated AI test endpoint outside development', async () => {
    const response = await request(app)
      .post('/api/v1/ai/test-generate')
      .send({
        module: 'script-development',
        task: 'story-expansion',
        input: 'A test premise',
      })
      .expect(401);

    expect(response.body.code).toBe('AUTH_NO_TOKEN');
  });

  test('returns a normalized 404 response', async () => {
    const response = await request(app).get('/does-not-exist').expect(404);

    expect(response.body).toMatchObject({
      status: 'error',
      statusCode: 404,
      message: 'Route not found: GET /does-not-exist',
    });
  });

  test('allows the configured client origin', async () => {
    const response = await request(app)
      .options('/api/v1')
      .set('Origin', 'http://localhost:3000')
      .set('Access-Control-Request-Method', 'GET')
      .expect(204);

    expect(response.headers['access-control-allow-origin']).toBe(
      'http://localhost:3000',
    );
  });
});
