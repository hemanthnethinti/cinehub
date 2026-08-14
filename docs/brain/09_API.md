# 09 - API Documentation

## Base URL
`/api/v1`

## Authentication
Most endpoints require a Bearer token in the `Authorization` header.

## Current Endpoints

### Auth (`/auth`)
- `POST /register`: Creates a user. Returns JWT.
- `POST /login`: Authenticates a user. Returns JWT.
- `POST /forgot-password`: Generates reset token (mocked currently).

### Users (`/users`)
- `GET /:id`: Retrieves public profile data.
- `PATCH /profile`: Updates the authenticated user's profile.
- `POST /:id/follow`: Authenticated user follows `:id`.
- `DELETE /:id/follow`: Authenticated user unfollows `:id`.
- `GET /:id/followers`: Retrieves paginated followers.
- `GET /:id/following`: Retrieves paginated following.

### Media (`/media`)
- `POST /upload`: Uploads a single file (`multipart/form-data`). Returns the Cloudinary URL.

## Standard Response Format
```json
{
  "status": "success",
  "data": { ... },
  "message": "Optional message"
}
```

## Standard Error Format
```json
{
  "status": "error",
  "message": "Human readable error",
  "code": "VALIDATION_ERROR"
}
```
