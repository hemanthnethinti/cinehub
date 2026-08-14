# CineHub AI Context (Master Boot Sequence)

> [!CAUTION]
> **DO NOT SKIP THIS FILE.** 
> Every future AI session, developer, or agent MUST start by reading this file before proceeding. This file acts as the memory and central nervous system of the CineHub project. It contains the fundamental rules, architectural decisions, and current state of the application. 

---

## 1. Project Overview
**CineHub** is a mobile-first professional social networking platform tailored specifically for filmmakers, actors, cinephiles, and creative professionals. 

**Why does this exist?**
Traditional networking platforms (like LinkedIn) lack the visual emphasis required for film portfolios, while visual platforms (like Instagram or Vimeo) lack structured professional networking, casting, and project collaboration features. CineHub bridges this gap, allowing users to build a professional identity, showcase their skills, and connect with other creators based on roles and locations.

---

## 2. Architecture Summary

CineHub employs a strictly decoupled Client-Server architecture utilizing **Clean Architecture** principles on both sides of the stack.

### High-Level System Context

```mermaid
C4Context
    title System Context for CineHub
    
    Person(user, "Film Professional", "A user of the application.")
    
    System_Boundary(c1, "CineHub Platform") {
        System(frontend, "Flutter Mobile App", "iOS & Android client.")
        System(backend, "Node.js API", "RESTful backend services.")
    }
    
    SystemExt(mongodb, "MongoDB Atlas", "Primary data store (NoSQL).")
    SystemExt(cloudinary, "Cloudinary", "Global CDN & Media transformation.")
    
    Rel(user, frontend, "Uses")
    Rel(frontend, backend, "Makes API calls to", "JSON/HTTPS")
    Rel(backend, mongodb, "Reads from and writes to", "Mongoose")
    Rel(backend, cloudinary, "Uploads media via", "SDK")
    Rel(frontend, cloudinary, "Fetches optimized images from", "HTTPS")
```

### Why Clean Architecture?
Both the Flutter frontend and the Node.js backend enforce a 3-layer Clean Architecture (Presentation/HTTP -> Domain <- Data). 
- **Reason**: Film production logic and social graphs are highly interconnected and complex. By isolating the **Domain** (Business Logic) from the **Data** (Network/DB) and **Presentation** (UI/Routes), we guarantee that future pivots (e.g., swapping a UI framework or migrating databases) do not corrupt the core business rules. 
- **Rule**: The Domain layer must **never** import external framework libraries (no `package:flutter/material.dart` in frontend Domain, no `express` in backend Domain).

---

## 3. Technology Stack

### Frontend (Mobile)
- **Framework**: Flutter (Dart) — chosen for high-performance cross-platform rendering (iOS/Android).
- **State Management**: Riverpod (`flutter_riverpod`) — chosen for its compile-time safety and declarative dependency injection compared to native `Provider`.
- **Navigation**: GoRouter — used for declarative, deep-linkable, and role-guarded routing.
- **Networking**: Dio — for robust HTTP requests, interceptors (JWT injection), and global error handling.

### Backend (API)
- **Runtime & Framework**: Node.js with Express.js — chosen for high I/O throughput and rapid development.
- **Database**: MongoDB (Atlas) via Mongoose — chosen for flexible schemas accommodating diverse user profiles and unstructured project data.
- **Authentication**: JWT (JSON Web Tokens) with `bcryptjs`.
- **Media**: Cloudinary via `multer` — *Decision:* Media binaries are never stored in the database. The API uploads to Cloudinary and stores only secure, CDN-optimized URLs in MongoDB.

---

## 4. Phases & Current Status

### [Implemented] Phase 1: Authentication Module
- **Features**: JWT-based Login, Registration, Password Recovery (mocked).
- **Frontend**: `lib/features/auth`. Introduced `AuthNotifier` to act as the global gatekeeper for GoRouter redirects.
- **Backend**: `/api/v1/auth`. Secure password hashing and token generation.

### [Implemented] Phase 2: User Profile Module
- **Features**: Rich user profiles, Cloudinary avatar uploads, skill proficiency tracking (1-5 scale), and paginated social graphs (Followers/Following).
- **UI Enhancements**: Added dynamic `ProfileCompletionCard` (animating progress bar based on filled domain fields) and `SkillsBottomSheet`.
- **Pagination**: Implemented robust infinite scrolling leveraging Riverpod `FutureProvider.family`.

### [Future] Phase 3: Projects or Messaging (TBD)
- Awaiting Product Owner directive. Will likely involve linking multiple User entities to a shared "Project" entity (portfolio pieces), or implementing real-time Socket.IO chat.

---

## 5. Strict Engineering Rules

> [!WARNING]
> These rules are non-negotiable. Breaking them corrupts the integrity of the codebase.

### Folder & Architecture Rules
1. **Never breach Clean Architecture**: The `domain` folder must not import anything from `presentation` or `data`. Use UseCases to communicate between layers.
2. **Feature Isolation**: Features (e.g., `auth`, `profile`) must not import each other's Data or Presentation layers. Cross-feature communication happens via the Domain layer or shared providers.

### Coding Rules
1. **Never duplicate widgets or providers**: Before creating a new button, input, or list tile, check `lib/shared/widgets/`. 
2. **Immutable State**: All state classes managed by Riverpod must be immutable (sealed classes or `freezed`).
3. **No UI Business Logic**: Widgets must only display data and dispatch user intents to `Notifiers` or `UseCases`.

### AI Operational Rules
1. **Never perform wild repository scans**: Do not run `grep` or `list_dir` on the whole repository just to understand the app. Read the specific files mapped in `docs/brain` instead.
2. **Stop after completion**: Execute exactly the requested phase/task, update the Brain documentation, and await human approval before continuing.

---

## 6. Known Technical Debt & Recent Decisions

### Caching Bug in Pagination (Phase 2 Debt)
- **Issue**: `followersProvider` and `followingProvider` in `lib/features/profile/presentation/providers/profile_providers.dart` are `FutureProvider.family` but lack the `autoDispose` modifier.
- **Impact**: Pull-to-refresh calls `ref.read(...future)` which instantly returns the staled cache from memory instead of triggering a network reload.
- **Action Required**: Must implement `ref.invalidate()` inside the refresh callbacks or migrate to `autoDispose` in early Phase 3.

### Recent Decisions (ADR)
- **Bypassing ProfileHeader Completion Bar**: During Task 2.12, instead of modifying the complex `ProfileHeader` component to strip out its legacy completion bar, we dynamically passed `completionPercent: 100` to suppress it, rendering the new `ProfileCompletionCard` below it. This preserved backward compatibility for `ProfileHeader` usage across the app.

---

## 7. Mandatory Read Order

To understand a specific vertical of the application without reading code, consult the following documents in this exact order:

1. **`13_PHASES.md`**: Understand exactly what features are completed and what is actively being built.
2. **`14_RULES.md`**: Review the strict coding, architecture, and Git guidelines.
3. **`03_ARCHITECTURE.md`**: Deep dive into the flow of data between the UI, Domain, and Backend.
4. **`09_API.md`**: Review the REST endpoints, payloads, and DTO structures.
5. **`06_DATABASE.md`** & **`07_BACKEND.md`**: Understand MongoDB schemas and Node.js folder conventions.
6. **`08_FRONTEND.md`**: Understand Flutter feature modules and Riverpod dependency trees.
7. **`04_DESIGN_SYSTEM.md`** & **`11_UI_GUIDELINES.md`**: Understand visual language, typography, and animation rules.

*(See the `docs/brain` directory for the full list of all 21 specialized architectural documents).*
