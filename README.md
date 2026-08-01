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

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

> **Target platform:** Android (primary). All platform directories are preserved.

### Backend (Node.js)

```bash
cd backend
cp .env.example .env      # fill in your values
npm install
npm run dev               # starts on PORT=5000 by default
```

> **Requirements:** Node.js ≥ 20, MongoDB, Redis

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
