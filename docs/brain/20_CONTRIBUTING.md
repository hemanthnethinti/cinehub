# 20 - Contributing

## Coding Standards
- Follow standard Dart and Node.js linting rules.
- Run `flutter analyze` locally before pushing.

## Git Workflow
- Create feature branches from `main` (e.g., `feat/auth`, `fix/login-crash`).
- Squash and merge PRs to keep the commit history clean.
- Use conventional commits (`feat:`, `fix:`, `chore:`).

## Folder Rules
- No cross-feature dependencies in the frontend. If a feature needs data from another feature, it must go through the Domain layer or a shared module.

## Code Review Checklist
- [ ] Does it break Clean Architecture?
- [ ] Are widgets free of business logic?
- [ ] Is there proper error handling?
- [ ] Are loading and empty states considered?
