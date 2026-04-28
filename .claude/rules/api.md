# Rule: API Routes

<!-- rule_meta
applies_to: src/api/**
description: Standards and constraints that apply exclusively to files under src/api/.
load_on: file_open | tool_use
-->

---

## Scope

These rules apply **only** to files matching `src/api/**`.
They are automatically loaded when Claude opens or edits any file in that directory.

---

## 1. HTTP & REST Conventions

- Use RESTful resource naming: `GET /users`, `POST /users`, `GET /users/:id`.
- HTTP method semantics must be respected:
  - `GET` — read only, no side effects.
  - `POST` — create a new resource.
  - `PUT` / `PATCH` — update; prefer `PATCH` for partial updates.
  - `DELETE` — remove.
- Return appropriate status codes:
  - `200` OK, `201` Created, `204` No Content
  - `400` Bad Request, `401` Unauthorised, `403` Forbidden, `404` Not Found
  - `422` Unprocessable Entity (validation), `500` Internal Server Error

---

## 2. Input Validation

- **Every** incoming request body and query param must be validated.
- Use a schema-validation library (e.g. Zod, Joi, Yup). Do not write ad-hoc checks.
- Return `422` with a structured error body on validation failure:

```json
{
  "error": "VALIDATION_ERROR",
  "details": [
    { "field": "email", "message": "must be a valid email address" }
  ]
}
```

---

## 3. Authentication & Authorisation

- All routes are authenticated by default. Use `@public` decorator / comment only
  after explicit review.
- Never trust client-supplied user IDs. Read identity from the verified JWT payload.
- Authorise at the route handler level — never rely solely on middleware.

---

## 4. Error Handling

- Never leak stack traces or internal paths in API responses.
- Log full error details server-side; return only a sanitised message to clients.
- All async route handlers must be wrapped with an error-catching utility:

```ts
// ✅ correct
router.get('/users/:id', asyncHandler(async (req, res) => { ... }));

// ❌ wrong — unhandled promise rejection
router.get('/users/:id', async (req, res) => { ... });
```

---

## 5. Database Access

- No raw SQL string interpolation — always use parameterised queries or an ORM.
- Database calls belong in a service/repository layer, not directly in route handlers.
- Limit query result sets — always apply pagination (`limit` / `offset` or cursor).

---

## 6. Logging

- Log every request at `INFO` level: `method`, `path`, `statusCode`, `durationMs`.
- Log errors at `ERROR` level with a correlation ID.
- Never log request bodies at `INFO` or above — they may contain PII.

---

## 7. Rate Limiting

- Apply rate limiting middleware to all public endpoints.
- Auth endpoints (login, register, password-reset) must have stricter limits.

---

*Scope: `src/api/**` only · Global rules still apply from CLAUDE.md*
