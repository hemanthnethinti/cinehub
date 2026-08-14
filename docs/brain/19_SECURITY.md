# 19 - Security

## Authentication & JWT
- Tokens are short-lived.
- The backend verifies the token via `requireAuth` middleware.
- The frontend passes the token as a `Bearer` header in an Axios/Dio interceptor.

## Authorization & RBAC
- Supported roles: `user`, `creator`, `admin`.
- Route guards check roles before executing controllers.

## Validation
- **Backend**: Uses Joi for strictly validating request payloads before hitting controllers.
- **Frontend**: Uses Flutter `Form` and `validator` callbacks to prevent unnecessary API calls.

## Environment Variables
- Secrets (`JWT_SECRET`, `MONGO_URI`, `CLOUDINARY_URL`) are never committed to version control. They reside in `.env`.

## Media Uploads
- File uploads are constrained by size limits and MIME type checks (e.g., `image/jpeg`, `image/png`) using Multer before being sent to Cloudinary.
