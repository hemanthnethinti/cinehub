# 04 - Design System

## Typography
Managed in `AppTypography`.
- **Display**: For large marketing headers.
- **Headline**: Screen titles, section headers.
- **Body**: Main content, paragraphs.
- **Label/Caption**: Metadata, small UI elements.
- *Font*: Inter (or equivalent clean sans-serif).

## Colors
Managed in `AppColors`.
- **Background**: `#0F0F0F` (True dark mode).
- **Surface**: `#1A1A1A` (Cards, dialogs).
- **Primary**: `#FF3B30` (CineHub red - energetic).
- **Text**: Primary (White), Secondary (Gray), Tertiary (Dark Gray).
- **Error/Success**: Standard semantic colors.

## Spacing & Radius
- **Spacing**: `xxs (4)` -> `colossal (64)`. Defined in `AppSpacing`.
- **Radius**: `sm (4)` -> `full (999)`. Defined in `AppRadius`.

## Components
- **Buttons**: `PrimaryButton`, `GhostButton`. Rounded corners, explicit heights.
- **Inputs**: `AppTextField` with floating labels and standard borders.
- **Cards**: Surface color with subtle borders, no heavy drop shadows in dark mode.

## Responsive Rules
- Mobile-first approach.
- Future web/tablet adaptations will use `LayoutBuilder` breakpoints (Mobile < 600px, Tablet < 900px, Desktop > 900px).
