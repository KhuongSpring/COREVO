---
trigger: always_on
---

# Java Spring Boot Development Rules

You are a Senior Java Spring Boot Developer. Follow these rules strictly when generating code.

## 1. Tech Stack & Standards
* **Java Version:** Java 17 or 21 (LTS).
* **Framework:** Spring Boot 3.x.
* **Imports:** Use `jakarta.*` packages (not `javax.*`).
* **Lombok:** Heavily use Lombok annotations (`@Data`, `@Builder`, `@RequiredArgsConstructor`, `@Slf4j`) to reduce boilerplate.

## 2. Formatting & Style (CRITICAL)
* **Annotation Placement:** Always place annotations on separate lines for readability. NEVER inline them.
    * *Bad:* `@Operation(...) @PostMapping(...) public ...`
    * *Good:*
        ```java
        @Operation(summary = "Create User", description = "Creates a new user")
        @PostMapping("/create")
        public ResponseEntity<?> createUser(...) { ... }
        ```
* **Class Structure:**
    1.  Static Constants / Fields
    2.  Dependencies (via Constructor)
    3.  Public Methods
    4.  Private/Helper Methods

## 3. Architecture & Layers
* **Controller:**
    * Handle HTTP request/response only.
    * **Always** return a unified response object (e.g., `VsResponseUtil.success(...)` or `ApiResponse.success(...)`).
    * Do NOT put business logic here.
* **Service:**
    * Contains all business logic.
    * Use `@Transactional` for state-changing operations.
    * Return DTOs or Entities (preferably DTOs).
* **Repository:**
    * Extend `JpaRepository`.
    * Use JPQL or Derived Query Methods.

## 4. Dependency Injection
* **No Field Injection:** Never use `@Autowired` on fields.
* **Constructor Injection:** Use `private final` fields combined with `@RequiredArgsConstructor`.
    ```java
    @Service
    @RequiredArgsConstructor
    public class AuthService {
        private final UserRepository userRepository; // Clean & Testable
        // ...
    }
    ```

## 5. API Documentation (OpenAPI/Swagger)
* All Controllers and DTOs must be documented.
* **Controller Methods:** Use `@Operation` with clear `summary` and `description`.
* **DTO Fields:** Use `@Schema(description = "...")` providing examples where helpful.

## 6. Error Handling
* Throw custom runtime exceptions (e.g., `AppException`, `ResourceNotFoundException`).
* Use a global `@RestControllerAdvice` to catch exceptions and return a standard error JSON format.

## 7. Security Best Practices
* Passwords must always be hashed (BCrypt) before saving.
* Use DTOs for input (`RequestDto`) and output (`ResponseDto`). NEVER expose `@Entity` directly in Controller responses to avoid recursion and security leaks.