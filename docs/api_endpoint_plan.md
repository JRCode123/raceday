# RaceDay — API Endpoint Plan

**IIE Rosebank College | POE Part 1 — Section B**
**Student:** Junior
**System:** RaceDay — South African Road Running, Walking & Cycling Event Management Platform

> Role options: **None** (public), **Any** (any logged-in user), **Organiser**, **Participant**

---

## 1. Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/auth/register | Register a new user account (Organiser or Participant). Hashes the password before saving. | None | `{ fullName, email, password, role }` | 201 Created — `{ userId, email, role }` · 400 Bad Request — missing/invalid fields · 409 Conflict — email already registered |
| POST | /api/auth/login | Log in with email and password. Returns a JWT token used for all protected routes. | None | `{ email, password }` | 200 OK — `{ token, userId, role }` · 401 Unauthorized — wrong credentials |

---

## 2. User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/profile | Get the currently logged-in user's own profile details. | Any | None | 200 OK — `{ userId, fullName, email, role, createdAt }` · 401 Unauthorized |
| PUT | /api/users/profile | Update the currently logged-in user's own profile. | Any | `{ fullName }` | 200 OK — updated user object · 400 Bad Request |
| DELETE | /api/users/{id} | Delete own user account. Cannot delete another user's account. | Any | None | 200 OK — `{ message: "Account deleted" }` · 403 Forbidden · 404 Not Found |

---

## 3. Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events | Get all active upcoming events. Public — no login needed. | None | None | 200 OK — array of event objects · 500 Internal Server Error |
| GET | /api/events/{id} | Get full details of one specific event by its ID. | None | None | 200 OK — full event object · 404 Not Found |
| POST | /api/events | Create a new event linked to the logged-in Organiser. | Organiser | `{ categoryId, name, description, location, route, eventDate, startTime, maxParticipants, entryFee }` | 201 Created — new event · 400 Bad Request · 403 Forbidden |
| PUT | /api/events/{id} | Update an event. Only the Organiser who created it can edit. | Organiser | `{ name, description, location, route, eventDate, startTime, maxParticipants, entryFee, isActive }` | 200 OK — updated event · 403 Forbidden · 404 Not Found |
| DELETE | /api/events/{id} | Delete an event. Only the owning Organiser can delete. | Organiser | None | 200 OK — `{ message: "Event deleted" }` · 403 Forbidden · 404 Not Found |
| GET | /api/events/{id}/enrolments | List all participants enrolled in a specific event. | Organiser | None | 200 OK — array of enrolments · 403 Forbidden · 404 Not Found |
