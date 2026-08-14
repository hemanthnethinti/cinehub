# 21 - Lessons Learned

## Phase 2 (User Profile)
- **Problem**: Infinite pagination states became complicated when using standard `StatefulWidget` scrolling combined with Riverpod `FutureProvider`.
- **Solution**: Cached the profiles list manually in the StatefulWidget state while using Riverpod's `FutureProvider.family` to fetch specific pages.
- **Tech Debt**: The `followersProvider` and `followingProvider` were not marked as `autoDispose`. Thus, pull-to-refresh requires explicit `ref.invalidate()` to clear memory, otherwise it fetches stale cache. **Must fix in Phase 3.**

## Phase 1 (Auth)
- **Problem**: Managing auth state across the entire app was initially brittle.
- **Solution**: Created a unified `AuthNotifier` that is globally available and controls GoRouter's `redirect` logic.
- **Mistake**: Forgot to handle the "Token Expired" 401 error globally in the Dio interceptor.
