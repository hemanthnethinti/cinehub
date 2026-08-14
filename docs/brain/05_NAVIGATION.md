# 05 - Navigation

## Routing Architecture (GoRouter)
CineHub uses `GoRouter` for declarative routing and deep linking capabilities. All routes are defined in `lib/core/router/app_router.dart`.

## Application Flow
1. **Splash**: Determines auth state.
2. **Auth Branch**: Login, Register, Forgot Password.
3. **Main Branch (BottomNav)**:
   - Home (Feed)
   - Discover
   - Projects (Future)
   - Messages (Future)
   - Profile (Current User)

## Deep Links & Nested Navigation
- Sub-routes (e.g., `/profile/edit`, `/profile/user/:id/followers`) push over the bottom navigation bar using `parentNavigatorKey: rootNavigatorKey` when necessary, or within the shell if intended.
- Profile routing supports deep linking to specific users: `/profile/user/123`.

## Route Guards
`GoRouter` redirects users globally based on `authState`:
- Unauthenticated users attempting to access main routes are redirected to `/login`.
- Authenticated users attempting to access auth routes are redirected to the initial main route.
