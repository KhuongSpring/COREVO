# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository structure

This is a monorepo with three independent projects — treat them as separate apps, not a shared build:

- **`corevo/`** — Spring Boot 3.5 (Java 21) REST API backend. This is the primary/most active codebase.
- **`corevo_fe/Hit_Tech_React_Native/my-app/`** — Expo/React Native (TypeScript) mobile app, the end-user client.
- **`frontend/`** — Vite + React (JSX) admin dashboard for managing users/exercises.

There is no root-level build; each project has its own toolchain and must be built/run from its own directory.

## Backend (`corevo/`)

### Commands

```bash
cd corevo
./mvnw spring-boot:run          # run the app locally (reads .env via spring.config.import)
./mvnw clean package            # build
./mvnw test                     # run all tests
./mvnw test -Dtest=ClassName#methodName   # run a single test
```

Copy `.env.example` to `.env` and fill in DB/JWT/Cloudinary/mail/OAuth2/Redis values before running — `application.properties` pulls almost everything from env vars (`spring.config.import=optional:file:.env[.properties]`).

Full stack (MySQL + Redis + app) via Docker:
```bash
cd corevo
docker compose up -d
```
MySQL is exposed on host port `3307`, Redis on `6380` (both remapped from their defaults to avoid local conflicts).

Swagger/OpenAPI UI is available once running (see `config/OpenApiConfig.java`) for exploring/testing endpoints.

### Architecture

Layered MVC under `com.example.corevo`:

- `controller/` — HTTP only. Every controller is annotated `@RestApiV1` (a meta-annotation in `base/RestApiV1.java` combining `@RestController` + `@RequestMapping("/api/v1")`), not `@RequestMapping` directly. Responses are always wrapped via `VsResponseUtil.success(...)` / `.error(...)` into a `RestData<T>` envelope — never return raw entities/DTOs from a controller.
- `service/` + `service/impl/` — interface/implementation split; business logic lives only in `impl`. `@Transactional` on state-changing methods.
- `repository/` — Spring Data JPA repositories. All repository method calls are wrapped by `aop/RepositoryAspect.java`, which logs a `SLOW QUERY` warning when execution exceeds `application.repository.query-limit-warning-ms` (configurable via `QUERY_LIMIT_WARNING_MS` env var).
- `domain/entity/` — JPA entities (subpackaged by domain: `feed/`, `training/`, `user/`, etc.).
- `domain/dto/request/` and `domain/dto/response/` — DTOs, subpackaged by feature (`auth/`, `feed/`, `training/`, `user/...`). Controllers must never expose `@Entity` objects directly.
- `domain/mapper/` — MapStruct mappers (entity ⇄ DTO), one per feature.
- `constant/UrlConstant.java` — all route paths are centralized here as nested static classes per feature (e.g. `UrlConstant.Auth.LOGIN`), each with a private `PRE_FIX`. Controllers reference these constants in `@GetMapping`/`@PostMapping` rather than inlining path strings.
- `constant/ErrorMessage.java` / `SuccessMessage.java` — centralized user-facing message keys (resolved via `MessageSource`, so error responses are localized).
- `exception/` — custom runtime exceptions (`NotFoundException`, `UnauthorizedException`, `ForbiddenException`, `InvalidException`, `UploadFileException`, `InternalServerException`, all likely extending `VsException`) caught centrally by `exception/GlobalExceptionHandler.java` (`@RestControllerAdvice`), which also handles Bean Validation (`ConstraintViolationException`, `BindException`) and returns field-level error maps.
- `security/` — JWT-based auth: `JwtAuthenticationFilter`, `JwtService`(+impl), `CustomUserDetails`, `SecurityUtils` (use `SecurityUtils.getCurrentUserId()` to get the authenticated user's UUID in controllers/services — wrap in try/catch where the endpoint also supports anonymous access, as seen in `PostController`), `RequestLogFilter`. Config in `config/SecurityConfig.java`. Google OAuth2 login is also wired up (`spring-boot-starter-oauth2-client`).
- `config/` — `RedisConfig` (caching), `CloudinaryConfig` (image upload/storage), `EnvConfig`, `WebMvcConfig`, `OpenApiConfig` (Swagger), `UserInfoProperties`.
- `helper/` and `helper/training_helper/` — reusable domain logic that doesn't belong in a service (e.g. training-plan generation helpers).
- User IDs and most entity primary keys are `UUID`, not `Long`.

Domain areas present: auth (JWT + OTP + Google OAuth2 + account recovery), user profile/health data, training plans/schedules/exercises/progress (a rules/workflow-driven plan builder — seed data lives in `src/main/resources/data/*.json`), a social feed (posts/comments), and static policy pages (privacy/terms served from `src/main/resources/policies/`).

### Code style rules (enforced by project convention, see `corevo/.agent/rules/spring-boot.md`)

- Java 21, Spring Boot 3.x, `jakarta.*` imports (not `javax.*`).
- Lombok is used heavily (`@Data`, `@Builder`, `@RequiredArgsConstructor`, `@Slf4j`, `@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)`).
- **Constructor injection only** — never `@Autowired` on fields; use `private final` fields + `@RequiredArgsConstructor`.
- Annotations go on their own line each — never inline multiple annotations before a method/class.
- Class member order: static constants/fields → injected dependencies → public methods → private/helper methods.
- All controller methods and DTO fields should carry Swagger annotations (`@Operation(summary=..., description=...)`, `@Schema(description=...)`).
- Passwords hashed with BCrypt before persisting.

## Mobile app (`corevo_fe/Hit_Tech_React_Native/my-app/`)

```bash
cd corevo_fe/Hit_Tech_React_Native/my-app
npm install
npm start           # expo start
npm run android
npm run ios
npm run web
npm run lint
```

- Expo Router (file-based routing) under `app/`, with route groups: `(auth)`, `(onboarding)`, `(personal-health)`, `(settings)`, `(tabs)`, `(training)`, `(training-setup)` — group folder names determine navigation grouping, not URL segments.
- State managed with `zustand` (`store/authStore.ts`, `store/themeStore.ts`, `store/userStore.ts`).
- API access centralized in `services/` (`services/api/client.ts` for the base Axios client, `services/api/trainingService.ts`, `services/api/userService.ts`, `services/authService.ts`) and `services/storage.ts` for local persistence.
- `constants/ApiEndpoints.ts` centralizes backend route paths, mirroring the backend's `UrlConstant`.
- `utils/mappingHelpers.ts` / `utils/trainingHelpers.ts` / `utils/trainingImageHelper.ts` convert between backend DTO shapes and frontend view models.

## Admin dashboard (`frontend/`)

```bash
cd frontend
npm install
npm run dev
npm run build
npm run lint
npm run preview
```

- Vite + React (JSX, not TSX) + SCSS modules per component/page.
- Structure: `pages/<feature>/` for route-level views (`Auth/`, `exercise/`, `home/`), `components/<feature>/` for feature-scoped components (`exercise/`, `header/`, `sidebar/`, `user/`), each with a co-located `.scss` file.
- `context/AuthContext.jsx` holds auth state.
- Deployed via Vercel (`vercel.json` present).
