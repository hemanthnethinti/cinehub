# CineHub — AI-Powered Filmmaking Platform

A monorepo containing the Flutter mobile application and the Node.js production backend for CineHub.

---

## Repository Structure

```
cinehub/
├── frontend/          # Flutter mobile app (Android primary target)
├── backend/           # Node.js production API server (Express + MongoDB + Redis + AI)
├── legacy/
│   └── otp-server/   # Preserved Twilio OTP server (reference only)
├── docs/              # Project documentation and reports
│   └── reports/
├── cinehub.code-workspace  # VS Code multi-root workspace
└── .gitignore
```

---

## Quick Start

### 1. Start local infrastructure

Docker is the easiest way to run the required MongoDB and Redis services:

```bash
docker compose up -d
```

### 2. Start the backend

```bash
cd backend
cp .env.example .env
npm ci
npm run dev               # http://localhost:5000
```

The example environment is ready for local development. AI routes stay disabled
until either `GEMINI_API_KEY` or `OPENAI_API_KEY` is configured; the rest of the
API works without an AI key.

Verify the server with:

```bash
curl http://localhost:5000/api/v1/health
```

### 3. Start the Flutter app

```bash
cd frontend
flutter pub get
flutter run
```

The default development URL uses `http://10.0.2.2:5000`, the Android emulator's
alias for the host machine. For a physical Android device, pass the computer's
LAN address explicitly:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000
```

For staging or production builds, also pass `--dart-define=ENV=staging` or
`--dart-define=ENV=production`.

> **Requirements:** Node.js ≥ 20, Flutter with Dart ≥ 3.8.1, Docker (or locally
> installed MongoDB and Redis). Android is the primary app target.

---

## Tech Stack

### Frontend
- Flutter 3.x / Dart 3.x
- Riverpod (state management)
- go_router (navigation)
- Dio (HTTP client)
- Freezed + json_serializable (data models)

### Backend
- Node.js 20+ / Express 4
- MongoDB (Mongoose)
- Redis (ioredis + BullMQ)
- OpenAI + Google Gemini (AI integrations)
- AWS S3 (media storage)
- Socket.IO (real-time)
- JWT authentication

---

## Documentation

All project documentation lives in [`docs/`](./docs/).

Key references:
- [Backend Setup](./docs/BACKEND_SETUP.md)
- [Frontend/Backend Integration](./docs/FRONTEND_BACKEND_INTEGRATION.md)
- [Architecture Analysis](./docs/ARCHITECTURE_ANALYSIS_PHASE1.md)
- [Design System](./docs/DESIGN_SYSTEM.md)

---

## Legacy

The original Twilio OTP server is preserved at [`legacy/otp-server/`](./legacy/otp-server/) for reference.
It will be compared with the production backend in a future refactoring phase.
