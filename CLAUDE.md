# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UMP Student Grab is a ride-sharing/carpooling mobile app for university students. It consists of:
- **`server/`** — Spring Boot 3.3.5 REST API (Java 21, Maven)
- **`client (mobile)/`** — Flutter mobile app (Dart, Android + iOS)

## Server Commands

Prerequisites: Java 21, MySQL running (XAMPP recommended), configured `application.properties`.

```bash
cd server
./mvnw spring-boot:run      # Run server (default port 8080)
./mvnw clean install        # Build
./mvnw test                 # Run tests
```

## Client Commands

Prerequisites: Flutter SDK, `.env` file configured (see `.env.example`).

```bash
cd "client (mobile)"
flutter pub get             # Install dependencies
flutter run                 # Run on connected device/emulator
flutter build apk           # Build Android APK
flutter test                # Run tests
flutter analyze             # Static analysis
```

### Environment Setup

Copy `.env.example` to `.env` and fill in:
- `APP_DOMAIN` — your PC's IPv4 address (from `ipconfig`)
- `APP_PORT` — server port (default `8080`)
- `API_KEY` — must match the API key configured in the server
- `GOOGLE_MAP_API_KEY` — Google Maps API key

Also add the Google Maps API key to:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/AppDelegate.swift`

The mobile device and development PC must be on the same network.

## Architecture

### Server (Clean Architecture)

Base package: `com.ump.studentgrab`

Dependency rule: `domain` ← `application` ← `infrastructure` / `presentation`

```
presentation  →  application  →  domain
infrastructure  →  application  →  domain
```

- **`domain/model/`** — JPA entities: `User`, `Chat`, `Message`, `Token`, `ApiKey`, `Attachment`
- **`domain/enums/`** — `MessageStatus`, `MessageType`
- **`domain/repository/`** — Spring Data JPA repository interfaces
- **`application/dto/`** — `request/` (inbound) and `response/` (outbound) DTOs
- **`application/exception/`** — Typed exceptions (`ResourceNotFoundException`, `DuplicateResourceException`, etc.)
- **`application/mapper/`** — MapStruct mappers (entity ↔ DTO)
- **`application/port/`** — Output port interfaces (`EmailService`, `FileStorageService`)
- **`application/service/`** — Use case implementations (`AuthService`, `UserService`, `ChatService`, etc.)
- **`infrastructure/email/`** — `EmailServiceImpl` (JavaMailSender + Thymeleaf)
- **`infrastructure/storage/`** — `FileStorageServiceImpl` (local disk, path from env)
- **`presentation/controller/`** — Thin REST controllers; no try/catch, no business logic
- **`presentation/websocket/`** — STOMP WebSocket config + `ChatWebSocketController` (real-time chat)
- **`presentation/filter/`** — `ApiKeyFilter` (validates `X-Api-Key` for all `/api/**` except `/api/keys` and `/api/setup`), `SecretKeyFilter` (validates `X-Secret-Key` for `/api/keys`), `RequestLoggingFilter`
- **`presentation/advice/`** — `GlobalExceptionHandler` (`@RestControllerAdvice` — maps typed exceptions to HTTP responses)
- **`presentation/response/`** — `ApiResponse<T>` generic response wrapper

Security: `X-Api-Key` header validated by `ApiKeyFilter` before any controller. First-run setup via `POST /api/setup` (creates Super Admin + initial API key; disabled once a Super Admin exists).

### Server Environment Variables

Server reads secrets from environment variables (`.env` file or system env). Copy `.env.example` to `.env` in `server/` and fill in:
- `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` — MySQL connection
- `MAIL_USERNAME`, `MAIL_PASSWORD` — SMTP credentials
- `SECRET_KEY` — secret for `/api/keys` and `/api/setup` access
- `FILE_STORAGE_PATH` — local path for uploaded files (default: `./uploads`)

### Client (Feature-Based Structure)

State management via **Provider**. Each feature follows the pattern: `Screen → BL (service) → HTTP/WebSocket → Server`.

- **`Screen/`** — UI organized by feature: `Auth/`, `Home/`, `Booking/`, `Chat/`, `Account/`
- **`BL/`** — Business logic services:
  - `auth_service.dart` / `account_service.dart` — REST API calls
  - `chat_service.dart` — Chat REST API
  - `chat_websocket_service.dart` — Real-time STOMP WebSocket
  - `gmap_websocket_service.dart` — Live location sharing via WebSocket
  - `location_service.dart` — Device GPS (Geolocator)
- **`Model/`** — Dart data models
- **`widget/`** — Shared/reusable UI widgets
- **`theme/`** — App-wide theming
- **`util/`** — Helpers: `SharedPreferencesUtil` (token/session storage), `LocationManagerUtil`

### Key Data Flow

- Auth: login → receive JWT access token + refresh token → store in SharedPreferences → attach to all requests
- Chat: REST to load history → STOMP WebSocket for live messages
- Booking/Maps: Google Maps Flutter for UI, Geolocator for device GPS, WebSocket for sharing driver location with passenger

## Workflow Rules (Backend)

- Before committing any backend changes, always run `./mvnw clean install -DskipTests` from `server/` and confirm it exits clean. Fix any errors before proceeding.
- Every commit must be pushed to GitHub immediately after being created.
- Do **not** add a `Co-Authored-By` trailer to any commit message.

## Database

MySQL, auto-schema update (`spring.jpa.hibernate.ddl-auto=update`). Connection configured in `server/src/main/resources/application.properties`. Default DB name: `ump_student_grab`.
