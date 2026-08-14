# Claude Working Agreements (backend)

How Claude should operate in this directory — process and behavior, not project facts. For what
the project *is*, see [../CLAUDE.md](../CLAUDE.md) (repo-root, covers all three projects) and the
"Backend (`corevo/`)" section within it.

## 1. Plan Mode Default
- Enter plan mode for any non-trivial task (3+ steps, or a real architectural decision).
- Use plan mode for verification steps too, not just for building.
- Write the spec/approach out before touching code, to cut down on rework.

## 2. Self-Improvement Loop
- After any correction from the user, capture the pattern (see [[feedback memory]] conventions)
  so the same mistake isn't repeated next session.
- Prefer a durable rule over a one-off fix when the correction generalizes.

## 3. Verification Before Done
- Verification is compile-only: `./mvnw compile` (or `./mvnw test-compile` if test sources
  changed) to catch errors, then read the diff.
- Don't run `./mvnw test`, `./mvnw spring-boot:run`, `docker compose up`, or curl endpoints as
  part of "verifying" a change unless the user explicitly asks for that in that turn.

## 4. Demand Elegance (Balanced)
- For non-trivial changes, pause and ask "is there a more elegant way?" before finalizing.
- Skip this for simple, obvious fixes — don't overengineer a one-line change.

## 5. Backdated Push Requests ("push vào ngày ...")
- When the user asks to commit/push with a specific date (e.g. "push với ngày 29/06/2026"), set
  **only the author date** to that date — via `git commit --date="YYYY-MM-DD HH:MM:SS" -m "..."`,
  or `git commit --amend --date="YYYY-MM-DD HH:MM:SS" --no-edit` for an existing commit. Do **not**
  also set `GIT_COMMITTER_DATE` / `--date` on the committer side.
- Why: GitHub's contribution graph squares key off the **author date**, but the commit
  history/list ordering keys off the **committer date**. Backdating both (e.g. via
  `GIT_AUTHOR_DATE=... GIT_COMMITTER_DATE=...`) makes the commit sort as if it were made on that
  old date, so it gets buried at the bottom of the history relative to its actual parent commit —
  not what the user wants. Leaving the committer date as the real "now" (git's default when only
  `--date`/author date is overridden) keeps the commit correctly ordered as the latest, while still
  marking the requested day on the contribution graph.
- If the commit is already pushed, this requires `git commit --amend` + `git push --force-with-lease`
  — confirm with the user before force-pushing, per the general Git Safety Protocol.

## 6. No Auto Commit/Push
- After finishing a code fix, stop and let the user review the diff. Do **not** run
  `git commit` or `git push` unless the user explicitly asks for it in that turn.
- Approval to commit/push earlier in a conversation does not carry forward to later changes —
  each new fix needs its own explicit go-ahead, even mid-session.
- Why: user was getting fixes auto-committed and pushed without a chance to review first.
- This does not relax the general Git Safety Protocol (force-push, `--no-verify`, etc. still
  need explicit confirmation every time regardless) — it tightens it: plain commit/push now
  need the same explicit ask, not just an inferred "seems like they'd want this."

## 7. Full Autonomy for Reversible Work
- Within `corevo/`, proceed without pausing for per-action confirmation on reversible, local
  work: reading files, running read-only inspection commands (`git show`, `git log`, `git diff`,
  `grep`, `./mvnw compile`), and editing/writing files (code, DTOs, entities, mappers, config).
- Why: user explicitly granted full authority for this kind of work and doesn't want to approve
  each step — repeated confirmation prompts for read-only or easily-reversible edits are pure
  friction.
- This does **not** extend to destructive or state-changing git operations (`git commit`,
  `git push`, `git reset --hard`, force-push, `--no-verify`, deleting files/branches) — those
  still require explicit confirmation each time per rule 6 and the general Git Safety Protocol.

## 8. API Docs Stay in the Code
- Corevo documents its API via **springdoc annotations directly in Java** (`@Operation`,
  `@Schema`, wired through `config/OpenApiConfig.java`) — there is no separate hand-maintained
  OpenAPI YAML tree in this project (unlike some other repos this working-agreement style has
  been used on).
- Whenever a change touches what an endpoint does or how a request/response field should be
  interpreted (new endpoint, changed field semantics, new/changed DTO shape), update the
  `@Operation(summary=..., description=...)` / `@Schema(description=...)` annotations on the
  same controller/DTO in the **same change** — don't ship the behavior change and leave the
  Swagger annotations stale or missing.
- Verify by checking the Swagger UI description text mentally matches the new behavior; there is
  no `npm run lint` doc-validation step for this project (that's a different repo's workflow).

## Core Principles
- **Simplicity first** — smallest change that solves the problem; minimize code generated.
- **No laziness** — fix root causes, no temporary/band-aid fixes.
- **Match existing patterns** — new code follows the layered MVC structure and conventions of
  already-implemented domains (`feed`, `training`, `user`, `auth`); see the Architecture section
  in [../CLAUDE.md](../CLAUDE.md) for the concrete shape (`RestData<T>` envelope via
  `VsResponseUtil`, `@RestApiV1`, service interface/impl split, `GlobalExceptionHandler`, etc).

## Project-Specific Ground Rules
- Java 21 + Spring Boot 3.5, Maven build (`./mvnw`), group ID `com.example` / package root
  `com.example.corevo`.
- **Lombok is used** in this project — do not remove Lombok annotations or avoid Lombok
  (`@Data`, `@Builder`, `@RequiredArgsConstructor`, `@Slf4j`, `@FieldDefaults`).
- **Constructor injection only** — never `@Autowired` on fields; use `private final` +
  `@RequiredArgsConstructor`.
- Controllers must never return raw entities/DTOs unwrapped — always
  `VsResponseUtil.success(...)` / `.error(...)`.
- Route paths belong in `constant/UrlConstant.java` (nested per-feature classes), not inlined
  string literals in `@GetMapping`/`@PostMapping`.
- User-facing messages belong in `constant/ErrorMessage.java` / `SuccessMessage.java`
  (resolved via `MessageSource`), not inline strings in exceptions/controllers.
- Entity primary keys (user IDs, most domain IDs) are `UUID`, not `Long`.
- `.env` (from `.env.example`) drives config via `spring.config.import` — don't hardcode secrets
  or connection strings into `application.properties`.
