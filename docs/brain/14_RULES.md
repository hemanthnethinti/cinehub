# 14 - Rules

## Implementation Rules
- **Never duplicate widgets**: Always check `lib/shared/widgets/` before creating a new one.
- **Never duplicate providers**: Reuse existing Riverpod providers.
- **Never duplicate repositories**: Centralize data access per feature.
- **Never modify unrelated code**: Scope changes strictly to the feature being developed.

## Architecture Rules
- Domain layer must never import Flutter UI packages or HTTP packages.
- Presentation layer must never execute raw HTTP requests. Use UseCases.
- Backend controllers must not contain complex business logic (delegate to services).

## Coding Standards
- Use explicit types, avoid `dynamic`.
- Use `const` constructors wherever possible in Flutter.
- Write descriptive, doc-commented code (`///`).

## Development Workflow
- **Always run `flutter analyze`** before considering a feature complete.
- **Always run tests** (`flutter test`) to verify regressions.
- **Always update documentation** (`docs/brain`) at the end of every phase.
- **Always stop after one completed phase** to await approval.
