# 11 - UI Guidelines

## Visual Language
CineHub uses a dark-themed, premium aesthetic. Interfaces should feel cinematic, relying on high contrast, smooth typography, and subtle surface borders rather than heavy shadows.

## Interaction Rules
- **Tappable areas**: Minimum 48x48 logical pixels.
- **Feedback**: Every button or list tile must have a visual pressed state (e.g., InkWell).
- **Destructive Actions**: Always require confirmation dialogs and use `AppColors.error`.

## Animation Rules
- Keep animations subtle and fast (150ms - 300ms).
- Use `TweenAnimationBuilder` for progress bars and stat changes.
- Avoid heavy, full-screen transitions unless navigating to a highly distinct module (e.g., watching a video).

## States
- **Loading**: Use shimmer effects (`ProfileLoadingSkeleton`) for complex layouts, or a centered `CircularProgressIndicator` for simple screens.
- **Empty**: Always use an empty state graphic/icon with actionable text (e.g., `EmptyProfileState`).
- **Error**: Display a user-friendly message and a "Retry" button. Never show raw stack traces.
