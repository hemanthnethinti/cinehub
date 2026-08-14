# 10 - Component Library

## Shared Widgets (`lib/shared/widgets/`)

### Buttons
- **`PrimaryButton`**: Used for primary calls to action (e.g., Login, Save Profile). Supports `isLoading`.
- **`GhostButton`**: Used for secondary actions (e.g., Cancel, Outline buttons).

### Inputs
- **`AppTextField`**: Standardized text input field with consistent padding, border radius, and typography. Supports `validator` and `obscureText`.

### Profile Widgets (`lib/features/profile/presentation/widgets/`)
- **`ProfileAvatar`**: Displays a user's avatar or fallback initials. Supports tap callbacks for uploading.
- **`ProfileHeader`**: The top section of a user profile containing avatar, name, and role.
- **`UserListTile`**: Reusable tile for displaying users in Followers/Following lists.
- **`SkillsBottomSheet`**: Dedicated bottom sheet for adding/editing user skills.
- **`EmptyProfileState`**: Standardized empty state graphic and message.
- **`ProfileCompletionCard`**: Dynamic progress card showing remaining setup steps.
