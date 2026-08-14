# 16 - Architectural Decisions (ADRs)

## 001 - Use of Riverpod for State Management
**Reason**: Flutter's native `Provider` is too verbose and lacks compile-time safety for dependency injection. Riverpod provides safe, immutable state management.
**Trade-offs**: Learning curve for new developers.
**Consequences**: All state must be immutable. Use `freezed` or pure Dart sealed classes.

## 002 - Cloudinary for Media Storage
**Reason**: MongoDB is unsuitable for large binary files. Cloudinary offers on-the-fly transformations (cropping, compression) and a global CDN.
**Trade-offs**: Third-party dependency, potential cost at scale.
**Consequences**: The backend only stores image URLs, never Base64 or Binary.

## 003 - Clean Architecture
**Reason**: To ensure business logic remains isolated from UI and Database changes.
**Trade-offs**: More boilerplate (Interfaces, UseCases, Repositories).
**Consequences**: strict dependency flow (UI -> Domain <- Data).
