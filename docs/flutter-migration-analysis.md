# Flutter Architecture Migration Analysis
**CineHub — Dual Architecture Audit**

> Status: ANALYSIS ONLY — No files moved or deleted.
> Awaiting approval before execution begins.

---

## 1. Current Folder Tree

```
frontend/lib/
│
├── main.dart                          ← Entry point (wired to OLD arch)
├── app.dart                           ← MaterialApp (wired to OLD arch, broken DevicePreview refs)
│
├── core/                              ← NEW ✅
│   ├── config/
│   ├── di/
│   ├── error/
│   ├── network/api_response.dart      ← freezed out of sync
│   ├── router/
│   │   ├── app_router.dart            ← GoRouter (NOT wired to app.dart yet)
│   │   └── routes.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_typography.dart
│       └── theme.dart (barrel)
│
├── features/                          ← NEW ✅
│   ├── ai/
│   │   ├── data/models/              ← freezed out of sync
│   │   ├── data/datasources/ai_generate_service.dart
│   │   └── presentation/
│   │       ├── providers/ai_providers.dart
│   │       └── screens/
│   │           ├── ai_hub_screen.dart
│   │           ├── cost_predictor_screen.dart
│   │           ├── script_generator_screen.dart
│   │           └── trailer_concept_screen.dart
│   ├── auth/
│   │   ├── data/models/              ← freezed out of sync
│   │   ├── data/repositories/auth_repository.dart
│   │   ├── presentation/screens/login_screen.dart
│   │   └── providers/auth_provider.dart
│   ├── discover/
│   │   └── presentation/screens/
│   │       ├── creator_profile_screen.dart
│   │       └── discover_screen.dart
│   ├── home/
│   │   ├── data/models/notification_models.dart
│   │   └── presentation/screens/home_screen.dart
│   ├── messaging/
│   │   └── presentation/screens/
│   │       ├── chat_screen.dart
│   │       └── conversations_screen.dart
│   ├── opportunities/
│   │   └── presentation/screens/
│   │       ├── jobs_screen.dart
│   │       └── job_detail_screen.dart
│   ├── portfolio/
│   │   └── presentation/screens/portfolio_screen.dart
│   ├── profile/
│   │   └── presentation/screens/
│   │       ├── edit_profile_screen.dart
│   │       ├── profile_screen.dart
│   │       └── settings_screen.dart
│   ├── projects/
│   │   ├── data/models/              ← freezed out of sync
│   │   ├── presentation/screens/project_detail_screen.dart
│   │   └── providers/project_providers.dart
│   └── splash/
│       └── presentation/screens/splash_screen.dart
│
├── shared/                            ← NEW ✅
│   └── widgets/
│       ├── ai/ai_widgets.dart
│       ├── buttons/buttons.dart
│       ├── cards/cards.dart
│       ├── chips/chips.dart
│       ├── dialogs/collaborate_dialog.dart
│       ├── inputs/inputs.dart
│       ├── layout/app_shell.dart
│       ├── media/cached_avatar.dart
│       └── states/states.dart
│
├── data/profiles_data.dart            ← OLD ❌ (global hardcoded seed data)
│
├── models/                            ← OLD ❌
│   ├── chat_message.dart
│   ├── notification_item.dart
│   └── profile_data.dart
│
├── screens/                           ← OLD ❌ (CURRENTLY RUNNING)
│   ├── main_screen.dart               ← app.dart home (IndexedStack nav)
│   ├── AI/
│   │   ├── ai.dart                    ← 4 093 lines, full AIPage + 7 sub-pages inline
│   │   ├── models/feature_item.dart
│   │   └── pages/
│   │       ├── ai_script_generator.dart
│   │       ├── budget_estimator.dart
│   │       ├── equipment_rental.dart  ← NO new counterpart
│   │       ├── film_distribution.dart ← NO new counterpart
│   │       ├── learning_center.dart   ← NO new counterpart
│   │       ├── project_management.dart← NO new counterpart
│   │       └── text_to_video.dart     ← NO new counterpart
│   ├── auth/
│   │   ├── login_screen.dart          ← real HTTP calls to localhost:4000
│   │   └── signup_screen.dart         ← re-export of SignupScreen
│   ├── home/home_page.dart            ← 2 176 lines, real posts/search/carousel
│   ├── jobs/jobs_page.dart
│   ├── messages/
│   │   ├── chat_page.dart
│   │   └── messages_page.dart
│   ├── notifications/notifications_page.dart ← NO new counterpart
│   ├── profile/
│   │   ├── profile_details_page.dart  ← NO new counterpart
│   │   └── profile_page.dart          ← 1 278 lines, real AuthService calls
│   └── projects/
│       ├── projects_page.dart         ← NO new list counterpart
│       └── widgets/category_delegate.dart
│
├── services/auth_service.dart         ← OLD ❌ — 240 lines, real HTTP service
│
└── widgets/collaborate_dialog.dart    ← OLD ❌ — duplicate
```

---

## 2. Old Architecture Summary

| Characteristic | Detail |
|---|---|
| **Navigation** | `Navigator.push` / `MaterialPageRoute` — no central router |
| **State** | `StatefulWidget` + `setState` — no state management library |
| **Entry point** | `app.dart` → `screens/main_screen.dart` → `IndexedStack` |
| **Design** | Hardcoded colors as private constants (`_C`, `_bg`, `_orange1`) |
| **Auth** | `AuthService` singleton — no DI, no persistence (in-memory only) |
| **Backend URL** | `localhost:4000` (legacy OTP server — NOT production) |
| **Richness** | Very complete — real animations, carousels, post feeds, real backend calls |

---

## 3. New Architecture Summary

| Characteristic | Detail |
|---|---|
| **Navigation** | `go_router` — centralized with `ShellRoute` |
| **State** | Riverpod (`StateNotifierProvider`, `freezed` union types) |
| **Entry point** | Not wired yet — `app_router.dart` exists but `app.dart` still uses old arch |
| **Design** | Full design system: `AppColors`, `AppTypography`, `AppSpacing`, `AppRadii` |
| **Auth** | `AuthRepository` + `AuthNotifier` (Riverpod) + `AuthState` (freezed) |
| **Backend URL** | Production backend (`/api/v1/...`) |
| **Richness** | Structurally clean but many screens have `onPressed: () {}` placeholders |

---

## 4. Complete Duplicate Map

### 4.1 Entry Points

| Layer | Old | New | Notes |
|---|---|---|---|
| App widget | `app.dart` → `MaterialApp`, home=`LoginScreen` | `core/router/app_router.dart` → `GoRouter` | New is complete, not wired |
| Shell / Nav | `screens/main_screen.dart` (IndexedStack + bubble nav) | `shared/widgets/layout/app_shell.dart` | Different designs, different nav approaches |

---

### 4.2 Auth

| Component | Old | New | Winner |
|---|---|---|---|
| Login screen | `screens/auth/login_screen.dart` — real HTTP logic | `features/auth/presentation/screens/login_screen.dart` — beautiful UI, no logic | **NEW UI + merge OLD logic** |
| Signup screen | `screens/auth/login_screen.dart` (SignupScreen class inside) | **Does not exist** | **Must create in new arch** |
| Service/Repo | `services/auth_service.dart` (240 lines, singleton) | `features/auth/data/repositories/auth_repository.dart` | **NEW** — migrate 8 methods from old |
| State | `setState` inside widgets | `features/auth/providers/auth_provider.dart` (Riverpod) | **NEW** |

> ⚠️ The old login screen calls `localhost:4000` (legacy backend). New auth repo calls production backend. Different contracts — migration requires comparing both APIs.

---

### 4.3 Home

| Feature | Old (`home_page.dart`, 2176 lines) | New (`home_screen.dart`, 303 lines) |
|---|---|---|
| Post feed with likes/comments | ✅ | ❌ Missing |
| 5-card auto-scroll carousel | ✅ | ❌ Missing |
| Animated expandable search | ✅ | ❌ Missing |
| Category chips (9 genres) | ✅ | ❌ Missing |
| Infinite scroll + shimmer | ✅ | ❌ Missing |
| Quick action tiles (router) | ❌ | ✅ |
| Design system | ❌ Hardcoded tokens | ✅ AppColors etc. |
| GoRouter navigation | ❌ Callbacks | ✅ |

**Winner:** New architecture is the structural target. Old screen's post feed, search, carousel, and category logic must be ported to the new `home_screen.dart`.

---

### 4.4 Profile

| Feature | Old (`profile_page.dart`, 1278 lines) | New (`profile_screen.dart`, 359 lines) |
|---|---|---|
| Real backend data | ✅ `AuthService.fetchMe()`, follower counts | ❌ Hardcoded strings |
| Tabs (Overview/Projects/Awards) | ✅ | ❌ Missing |
| Testimonials section | ✅ | ❌ Missing |
| Portfolio preview strip | ❌ | ✅ |
| Quick settings inline menu | ❌ | ✅ |
| Design system | ❌ | ✅ |
| GoRouter | ❌ `Navigator.push` | ✅ |

**Winner:** New is the target. Real backend calls + tabs + testimonials must be ported.

---

### 4.5 Projects

| Component | Old | New | Notes |
|---|---|---|---|
| Projects list | `screens/projects/projects_page.dart` | **Does not exist** | Must create `features/projects/presentation/screens/projects_screen.dart` |
| Project detail | None | `features/projects/presentation/screens/project_detail_screen.dart` | **NEW** — already exists |
| Project model | Inline `_Project` in `profile_page.dart` | `features/projects/data/models/project_models.dart` (freezed) | **NEW** |

---

### 4.6 Messaging

| Component | Old | New | Winner |
|---|---|---|---|
| Conversations list | `screens/messages/messages_page.dart` — requires `ProfileData` + callbacks from `MainScreen` | `features/messaging/presentation/screens/conversations_screen.dart` — self-contained | **NEW** |
| Chat screen | `screens/messages/chat_page.dart` | `features/messaging/presentation/screens/chat_screen.dart` | **NEW** |

---

### 4.7 AI Module

| Component | Old | New | Winner |
|---|---|---|---|
| AI Hub | `screens/AI/ai.dart` (4 093 lines, 7 features) | `features/ai/presentation/screens/ai_hub_screen.dart` (332 lines, Riverpod, real API) | **NEW hub + port missing sub-pages** |
| Script Generator | `screens/AI/pages/ai_script_generator.dart` | `features/ai/presentation/screens/script_generator_screen.dart` | **NEW** (real API) |
| Budget Estimator | `screens/AI/pages/budget_estimator.dart` | `features/ai/presentation/screens/cost_predictor_screen.dart` | **NEW** |
| Trailer Concept | Partial in old | `features/ai/presentation/screens/trailer_concept_screen.dart` | **NEW** |
| Text to Video | `screens/AI/pages/text_to_video.dart` | **Does not exist** | **Must migrate** |
| Equipment Rental | `screens/AI/pages/equipment_rental.dart` | **Does not exist** | **Must migrate** |
| Learning Center | `screens/AI/pages/learning_center.dart` | **Does not exist** | **Must migrate** |
| Film Distribution | `screens/AI/pages/film_distribution.dart` | **Does not exist** | **Must migrate** |
| Project Management | `screens/AI/pages/project_management.dart` | **Does not exist** | **Must migrate** |

> ⚠️ 5 of 7 AI sub-pages have NO new counterpart. These features will be permanently lost if old `screens/AI/` is deleted prematurely.

---

### 4.8 Notifications

| Component | Old | New | Notes |
|---|---|---|---|
| Notifications screen | `screens/notifications/notifications_page.dart` | **Does not exist** | Router references `/notifications` but no file — runtime crash risk |

---

### 4.9 Discovery / Portfolio / Jobs

| Component | Old | New | Notes |
|---|---|---|---|
| Discover | Not in old arch | `features/discover/presentation/screens/discover_screen.dart` | **NEW** (new feature) |
| Creator profile | Not in old arch | `features/discover/presentation/screens/creator_profile_screen.dart` | **NEW** (new feature) |
| Portfolio | Not in old arch | `features/portfolio/presentation/screens/portfolio_screen.dart` | **NEW** (new feature) |
| Jobs list | `screens/jobs/jobs_page.dart` | `features/opportunities/presentation/screens/jobs_screen.dart` | **NEW** |
| Job detail | Not in old arch | `features/opportunities/presentation/screens/job_detail_screen.dart` | **NEW** |

---

### 4.10 Models

| Old Model | Used By | New Equivalent | Decision |
|---|---|---|---|
| `models/profile_data.dart` | `home_page`, `messages_page`, `projects_page`, `main_screen` | None | Migrate → `features/discover/data/models/` |
| `models/chat_message.dart` | `messages_page`, `main_screen` | None | Migrate → `features/messaging/data/models/` |
| `models/notification_item.dart` | `notifications_page` | `features/home/data/models/notification_models.dart` | Consolidate into NEW |
| `data/profiles_data.dart` | `main_screen.dart` only | None | Delete after `main_screen` migration |

---

### 4.11 Widgets & Services

| Old | New | Decision |
|---|---|---|
| `widgets/collaborate_dialog.dart` | `shared/widgets/dialogs/collaborate_dialog.dart` | **NEW wins** — design system, creatorName param, Cancel button |
| `services/auth_service.dart` | `features/auth/data/repositories/auth_repository.dart` | **NEW** — but old has 8 unique methods (`fetchFeed`, `follow`, `unfollow`, `likePost`, `createPost`, `fetchAllUsers`, `fetchFollowers`, `fetchUserStats`) that must be distributed to feature repos before deletion |

---

## 5. Survive vs Delete Summary

| Path | Action |
|---|---|
| `screens/main_screen.dart` | Delete after all features migrated + `app.dart` rewired |
| `screens/auth/login_screen.dart` | Port HTTP logic to `auth_repository.dart`, then delete |
| `screens/auth/signup_screen.dart` | Create `register_screen.dart` in new arch, then delete |
| `screens/home/home_page.dart` | Port post feed, search, carousel to `home_screen.dart`, then delete |
| `screens/profile/profile_page.dart` | Port real backend calls + tabs to `profile_screen.dart`, then delete |
| `screens/AI/ai.dart` | Port 5 unique sub-pages, then delete |
| `screens/AI/pages/*.dart` | Migrate all 5 pages to `features/ai/`, then delete |
| `screens/notifications/notifications_page.dart` | Create `features/notifications/`, then delete |
| `screens/projects/projects_page.dart` | Create `features/projects/.../projects_screen.dart`, then delete |
| `screens/messages/*.dart` | New versions exist — delete after verify |
| `screens/jobs/jobs_page.dart` | Compare then delete |
| `models/profile_data.dart` | Move to `features/discover/data/models/`, then delete |
| `models/chat_message.dart` | Move to `features/messaging/data/models/`, then delete |
| `models/notification_item.dart` | Consolidate with new, then delete |
| `services/auth_service.dart` | Port 8 methods to feature repos, then delete |
| `widgets/collaborate_dialog.dart` | Delete (superseded) |
| `data/profiles_data.dart` | Delete after `main_screen` gone |
| `features/**` + `core/**` + `shared/**` | **KEEP — target architecture** |

---

## 6. Migration Difficulty

| Feature | Difficulty | Reason |
|---|---|---|
| Auth | 🔴 High | Two backends with different contracts; no signup screen in new arch; freezed out of sync |
| Home | 🔴 High | 2 176-line screen — post feed, carousel, search, shimmer, infinite scroll, create-post sheet |
| AI | 🔴 High | 5 sub-pages with no new counterpart; navigation from `Navigator.push` to `go_router` |
| Profile | 🟡 Medium | Real backend calls + tabs + testimonials must be ported |
| Projects | 🟡 Medium | List screen missing in new arch — must create |
| Notifications | 🟡 Medium | New feature — must create `features/notifications/` from scratch |
| Messaging | 🟢 Low | New screen is self-contained; old is tightly coupled |
| Discovery | 🟢 Low | Already in new arch — verify only |
| Portfolio | 🟢 Low | Already in new arch — verify only |
| Jobs | 🟢 Low | New screen exists — compare then switch |

---

## 7. Pre-migration Blocker (Must Fix First)

`app.dart` will not compile as-is. The `device_preview` import was removed but two calls remain:

```dart
// These two lines reference DevicePreview but import was deleted:
locale: DevicePreview.locale(context),     // line 14
builder: DevicePreview.appBuilder,          // line 15
```

This is a **two-line deletion** required before any migration can begin. Not a refactor — a compilation fix.

---

## 8. Recommended Migration Order

| Step | Task | Dependency |
|---|---|---|
| **0** | Fix `app.dart` broken DevicePreview refs | Blocks compilation |
| **1** | Auth | All screens depend on auth state |
| **2** | Home | Highest user-facing impact |
| **3** | Profile | Depends on auth |
| **4** | Projects | Profile links to projects |
| **5** | Messaging | Independent once ProfileData model migrated |
| **6** | AI | Most isolated route group; most complex internally |
| **7** | Notifications | Short screen; create from scratch |
| **8** | Discovery | Verify existing new screens |
| **9** | Portfolio | Verify existing new screen |
| **10** | Delete old dirs | Only after ALL features verified |

---

*Analysis completed — 2026-08-02. Zero files modified.*
