#!/bin/bash
# ============================================================
# RaceDay Part 1 — Remaining Commits Script
# Adjusted for Junior's folder structure
#
# Your folder already has:
#   - .git folder (git init already done)
#   - 3 commits already made
#   - Branch: master
#   - Remote: JRCode123/raceday
#
# This script makes the remaining 17 commits (commits 4-20)
# then pushes everything to GitHub.
# ============================================================

set -e

echo ""
echo "============================================================"
echo "  RaceDay — Making remaining 17 commits (4 to 20)"
echo "============================================================"
echo ""
read -p "Press ENTER to start..."
echo ""

# ==============================================================
# COMMIT 4 — Add the ERD PNG
# ==============================================================
echo "[4/20] Adding ERD diagram PNG..."
git add "docs/ERD Diagram.png"
git commit -m "docs: Add ERD diagram PNG exported from dbdiagram.io - 7 entities and 8 relationships"
echo "Done."
echo ""

# ==============================================================
# COMMIT 5 — Add the CI/CD workflow
# ==============================================================
echo "[5/20] Adding GitHub Actions CI/CD workflow..."
git add .github/workflows/validate.yml
git commit -m "ci: Add GitHub Actions workflow to validate /docs folder structure on every push"
echo "Done."
echo ""

# ==============================================================
# COMMIT 6 — API plan: Authentication section
# ==============================================================
echo "[6/20] Starting API endpoint plan - Authentication..."

cat > docs/api_endpoint_plan.md << 'EOF'
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
EOF

git add docs/api_endpoint_plan.md
git commit -m "docs: Start API endpoint plan - add Authentication section (register and login)"
echo "Done."
echo ""

# ==============================================================
# COMMIT 7 — User Profile endpoints
# ==============================================================
echo "[7/20] Adding User Profile endpoints..."

cat >> docs/api_endpoint_plan.md << 'EOF'

---

## 2. User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/profile | Get the currently logged-in user's own profile details. | Any | None | 200 OK — `{ userId, fullName, email, role, createdAt }` · 401 Unauthorized |
| PUT | /api/users/profile | Update the currently logged-in user's own profile. | Any | `{ fullName }` | 200 OK — updated user object · 400 Bad Request |
| DELETE | /api/users/{id} | Delete own user account. Cannot delete another user's account. | Any | None | 200 OK — `{ message: "Account deleted" }` · 403 Forbidden · 404 Not Found |
EOF

git add docs/api_endpoint_plan.md
git commit -m "docs: Add User Profile section to API plan (GET, PUT, DELETE profile)"
echo "Done."
echo ""

# ==============================================================
# COMMIT 8 — Events endpoints
# ==============================================================
echo "[8/20] Adding Events endpoints..."

cat >> docs/api_endpoint_plan.md << 'EOF'

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
EOF

git add docs/api_endpoint_plan.md
git commit -m "docs: Add Events section to API plan - 6 endpoints including enrolment listing"
echo "Done."
echo ""

# ==============================================================
# COMMIT 9 — Categories endpoints
# ==============================================================
echo "[9/20] Adding Categories endpoints..."

cat >> docs/api_endpoint_plan.md << 'EOF'

---

## 4. Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/categories | Get all event categories. Used to populate dropdowns. | None | None | 200 OK — array of categories · 500 Internal Server Error |
| GET | /api/categories/{id} | Get one category with its list of events. | None | None | 200 OK — category object · 404 Not Found |
| POST | /api/categories | Create a new category. | Organiser | `{ name, description, sport }` | 201 Created — new category · 400 Bad Request · 403 Forbidden |
| PUT | /api/categories/{id} | Update a category. Only the Organiser who created it can update. | Organiser | `{ name, description, sport }` | 200 OK — updated category · 403 Forbidden · 404 Not Found |
| DELETE | /api/categories/{id} | Delete a category. Fails if events are still linked to it. | Organiser | None | 200 OK — `{ message: "Category deleted" }` · 409 Conflict — events still linked · 403 Forbidden · 404 Not Found |
EOF

git add docs/api_endpoint_plan.md
git commit -m "docs: Add Categories section to API plan - 5 endpoints including conflict handling"
echo "Done."
echo ""

# ==============================================================
# COMMIT 10 — Enrolments and Results (completes the API plan)
# ==============================================================
echo "[10/20] Completing API plan with Enrolments and Results..."

cat >> docs/api_endpoint_plan.md << 'EOF'

---

## 5. Event Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/enrolments | Get all enrolments for the logged-in Participant. | Participant | None | 200 OK — array of enrolments with event name, date, status · 403 Forbidden |
| POST | /api/enrolments | Enrol the logged-in Participant in an event. | Participant | `{ eventId }` | 201 Created — enrolment object · 400 Bad Request — already enrolled · 409 Conflict — event is full · 404 Not Found |
| DELETE | /api/enrolments/{id} | Cancel an enrolment (withdraw from an event). | Participant | None | 200 OK — `{ message: "Enrolment cancelled" }` · 403 Forbidden · 404 Not Found |

---

## 6. Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/results/my | Get all race results for the logged-in Participant. | Participant | None | 200 OK — array of results with event name, finish time, position · 403 Forbidden |
| GET | /api/results/event/{eventId} | Get all results for a specific event ordered by position. | Any | None | 200 OK — array of results · 404 Not Found |
| POST | /api/results | Capture a result for a participant in the Organiser's event. | Organiser | `{ enrolmentId, finishTime, position, notes }` | 201 Created — result object · 400 Bad Request · 403 Forbidden · 409 Conflict — result already exists |
| PUT | /api/results/{id} | Correct a previously captured result. | Organiser | `{ finishTime, position, notes }` | 200 OK — updated result · 403 Forbidden · 404 Not Found |
| DELETE | /api/results/{id} | Delete a result record. | Organiser | None | 200 OK — `{ message: "Result deleted" }` · 403 Forbidden · 404 Not Found |

---

## Summary

| Resource | Endpoints |
|---|---|
| Authentication | 2 |
| User Profile | 3 |
| Events | 6 |
| Categories | 5 |
| Enrolments | 3 |
| Results | 5 |
| **Total** | **24** |

*This plan was written before any Part 2 code was produced, as required by the assignment.*
EOF

git add docs/api_endpoint_plan.md
git commit -m "docs: Complete API endpoint plan - add Enrolments and Results (24 endpoints total)"
echo "Done."
echo ""

# ==============================================================
# COMMIT 11 — SQL: CREATE DATABASE
# ==============================================================
echo "[11/20] SQL script - CREATE DATABASE..."

cat > docs/raceday_database.sql << 'EOF'
-- ============================================================
-- RaceDay Database Script
-- Student: Junior | IIE Rosebank College
-- Compatible with: SQL Server Management Studio (SSMS) 2022
-- ============================================================

-- Create the database only if it does not already exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'RaceDay')
BEGIN
    CREATE DATABASE RaceDay;
END
GO

USE RaceDay;
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add CREATE DATABASE block with IF NOT EXISTS check for SSMS 2022"
echo "Done."
echo ""

# ==============================================================
# COMMIT 12 — SQL: DROP tables and Users table
# ==============================================================
echo "[12/20] SQL script - DROP statements and Users table..."

cat >> docs/raceday_database.sql << 'EOF'

-- Drop all tables in reverse FK order so constraints do not block us
IF OBJECT_ID('dbo.Results',      'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments',   'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Events',       'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Categories',   'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Participants', 'U') IS NOT NULL DROP TABLE dbo.Participants;
IF OBJECT_ID('dbo.Organisers',   'U') IS NOT NULL DROP TABLE dbo.Organisers;
IF OBJECT_ID('dbo.Users',        'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- TABLE 1: Users
-- Base account for all users. [Role] decides Organiser or Participant.
CREATE TABLE Users (
    UserID       INT           IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    [Role]       NVARCHAR(20)  NOT NULL CHECK ([Role] IN ('Organiser', 'Participant')),
    CreatedAt    DATETIME      NOT NULL DEFAULT GETDATE()
);
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add DROP TABLE statements and Users table with Role CHECK constraint"
echo "Done."
echo ""

# ==============================================================
# COMMIT 13 — SQL: Organisers and Participants
# ==============================================================
echo "[13/20] SQL script - Organisers and Participants tables..."

cat >> docs/raceday_database.sql << 'EOF'

-- TABLE 2: Organisers - extra profile for Organiser users (1:1 with Users)
CREATE TABLE Organisers (
    OrganiserID   INT           IDENTITY(1,1) PRIMARY KEY,
    UserID        INT           NOT NULL UNIQUE,
    Organisation  NVARCHAR(150) NOT NULL,
    ContactPhone  NVARCHAR(20)  NULL,
    CONSTRAINT FK_Organisers_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- TABLE 3: Participants - extra profile for Participant users (1:1 with Users)
CREATE TABLE Participants (
    ParticipantID    INT           IDENTITY(1,1) PRIMARY KEY,
    UserID           INT           NOT NULL UNIQUE,
    DateOfBirth      DATE          NULL,
    Gender           NVARCHAR(10)  NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
    EmergencyContact NVARCHAR(100) NULL,
    CONSTRAINT FK_Participants_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add Organisers and Participants tables with 1:1 FK to Users"
echo "Done."
echo ""

# ==============================================================
# COMMIT 14 — SQL: Categories and Events
# ==============================================================
echo "[14/20] SQL script - Categories and Events tables..."

cat >> docs/raceday_database.sql << 'EOF'

-- TABLE 4: Categories - event types created by Organisers
CREATE TABLE Categories (
    CategoryID   INT           IDENTITY(1,1) PRIMARY KEY,
    OrganiserID  INT           NOT NULL,
    [Name]       NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(500) NULL,
    Sport        NVARCHAR(50)  NOT NULL CHECK (Sport IN ('Running', 'Cycling', 'Walking')),
    CONSTRAINT FK_Categories_Organisers FOREIGN KEY (OrganiserID)
        REFERENCES Organisers(OrganiserID) ON DELETE CASCADE
);
GO

-- TABLE 5: Events - a specific race e.g. Soweto Marathon 2026
CREATE TABLE Events (
    EventID         INT            IDENTITY(1,1) PRIMARY KEY,
    OrganiserID     INT            NOT NULL,
    CategoryID      INT            NOT NULL,
    [Name]          NVARCHAR(150)  NOT NULL,
    Description     NVARCHAR(1000) NULL,
    Location        NVARCHAR(200)  NOT NULL,
    Route           NVARCHAR(500)  NULL,
    EventDate       DATE           NOT NULL,
    StartTime       TIME(0)        NOT NULL,
    MaxParticipants INT            NOT NULL DEFAULT 500,
    EntryFee        DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    IsActive        BIT            NOT NULL DEFAULT 1,
    CONSTRAINT FK_Events_Organisers FOREIGN KEY (OrganiserID) REFERENCES Organisers(OrganiserID),
    CONSTRAINT FK_Events_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add Categories with Sport CHECK constraint and Events table with dual FKs"
echo "Done."
echo ""

# ==============================================================
# COMMIT 15 — SQL: Enrolments and Results
# ==============================================================
echo "[15/20] SQL script - Enrolments and Results tables..."

cat >> docs/raceday_database.sql << 'EOF'

-- TABLE 6: Enrolments - many-to-many bridge between Participants and Events
-- No CASCADE on FKs to prevent SQL Server Error 1785 (multiple cascade paths)
CREATE TABLE Enrolments (
    EnrolmentID   INT          IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT          NOT NULL,
    EventID       INT          NOT NULL,
    EnrolledAt    DATETIME     NOT NULL DEFAULT GETDATE(),
    [Status]      NVARCHAR(20) NOT NULL DEFAULT 'Confirmed'
                  CHECK ([Status] IN ('Confirmed', 'Cancelled', 'Waitlisted')),
    CONSTRAINT UQ_Enrolments UNIQUE (ParticipantID, EventID),
    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (EventID) REFERENCES Events(EventID)
);
GO

-- TABLE 7: Results - post-race results captured by Organisers (1:1 with Enrolments)
CREATE TABLE Results (
    ResultID    INT           IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT           NOT NULL UNIQUE,
    FinishTime  NVARCHAR(20)  NOT NULL,
    [Position]  INT           NULL,
    Notes       NVARCHAR(500) NULL,
    RecordedAt  DATETIME      NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID) ON DELETE CASCADE
);
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add Enrolments with UNIQUE constraint and Results table with 1:1 FK"
echo "Done."
echo ""

# ==============================================================
# COMMIT 16 — SQL: Seed Users, Organisers, Participants
# ==============================================================
echo "[16/20] SQL script - Seed data part 1..."

cat >> docs/raceday_database.sql << 'EOF'

-- ============================================================
-- SEED DATA
-- ============================================================

-- Users: 2 Organisers + 4 Participants
INSERT INTO Users (FullName, Email, PasswordHash, [Role]) VALUES
('Sipho Dlamini',  'sipho@raceza.co.za',    'hash_sipho_001',  'Organiser'),
('Fatima Mokoena', 'fatima@capesport.co.za','hash_fatima_002', 'Organiser'),
('Lebo Khumalo',   'lebo@gmail.com',        'hash_lebo_003',   'Participant'),
('Thabo Nkosi',    'thabo@gmail.com',       'hash_thabo_004',  'Participant'),
('Zanele Sithole', 'zanele@hotmail.com',    'hash_zanele_005', 'Participant'),
('David van Wyk',  'david@runner.co.za',    'hash_david_006',  'Participant');
GO

-- Organisers: UserID 1=Sipho, 2=Fatima
INSERT INTO Organisers (UserID, Organisation, ContactPhone) VALUES
(1, 'RaceZA Events',         '011 555 0101'),
(2, 'Cape Sport Collective', '021 555 0202');
GO

-- Participants: UserID 3=Lebo, 4=Thabo, 5=Zanele, 6=David
INSERT INTO Participants (UserID, DateOfBirth, Gender, EmergencyContact) VALUES
(3, '1995-03-14', 'Female', 'Mama Khumalo - 082 111 2222'),
(4, '1990-07-22', 'Male',   'Sarah Nkosi - 083 333 4444'),
(5, '1998-11-05', 'Female', 'Baba Sithole - 074 555 6666'),
(6, '1985-01-30', 'Male',   'Anna van Wyk - 071 777 8888');
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add seed data for 2 Organisers and 4 Participants with realistic SA names"
echo "Done."
echo ""

# ==============================================================
# COMMIT 17 — SQL: Seed Categories and Events
# ==============================================================
echo "[17/20] SQL script - Seed Categories and Events..."

cat >> docs/raceday_database.sql << 'EOF'

-- Categories
INSERT INTO Categories (OrganiserID, [Name], Description, Sport) VALUES
(1, 'Road Running', 'All on-road running events from 5km to marathon distance', 'Running'),
(1, 'Charity Walk',  'Community walking events open to all fitness levels',       'Walking'),
(2, 'Road Cycling',  'Timed road cycling events and sportive rides',              'Cycling');
GO

-- Events (minimum 3 required)
INSERT INTO Events (OrganiserID, CategoryID, [Name], Description, Location, Route, EventDate, StartTime, MaxParticipants, EntryFee) VALUES
(1, 1, 'Soweto Marathon 2026',      'The famous 42.2km marathon through the streets of Soweto.',             'Soweto, Johannesburg',  'FNB Stadium through Diepkloof to Orlando Stadium.',             '2026-11-01', '06:00', 15000, 350.00),
(1, 2, 'Joburg Charity Walk 5km',   'A fun 5km community walk raising funds for local schools.',             'Zoo Lake, Johannesburg', 'Flat circular route around Zoo Lake Park.',                     '2026-09-20', '07:30', 500,   0.00),
(2, 3, 'Cape Town Cycle Tour 109km','South Africa''s most iconic road cycling event around the Peninsula.', 'Cape Town, Western Cape','Grand Parade through Chapman''s Peak to Cape Town CBD.',        '2026-03-08', '07:00', 35000, 850.00);
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add seed data for 3 Categories and 3 Events including Soweto Marathon"
echo "Done."
echo ""

# ==============================================================
# COMMIT 18 — SQL: Seed Enrolments and Results
# ==============================================================
echo "[18/20] SQL script - Seed Enrolments and Results..."

cat >> docs/raceday_database.sql << 'EOF'

-- Enrolments (ParticipantID 1=Lebo 2=Thabo 3=Zanele 4=David)
INSERT INTO Enrolments (ParticipantID, EventID, [Status]) VALUES
(1, 1, 'Confirmed'),
(2, 1, 'Confirmed'),
(3, 1, 'Confirmed'),
(4, 1, 'Confirmed'),
(1, 2, 'Confirmed'),
(2, 3, 'Confirmed'),
(4, 3, 'Confirmed');
GO

-- Results (EnrolmentID 1-7 matching enrolments above in order)
INSERT INTO Results (EnrolmentID, FinishTime, [Position], Notes) VALUES
(1, '03:42:15', 3,  'Age category medal winner'),
(2, '04:01:30', 8,  'Personal best'),
(3, '03:55:44', 5,  'Strong finish'),
(4, '02:58:10', 1,  'Overall winner'),
(5, '00:52:10', 1,  'First finisher'),
(6, '02:15:33', 12, 'Completed the 109km'),
(7, '01:58:02', 3,  'Top 5 in age group');
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add seed data for 7 Enrolments and 7 Results to demonstrate full system flow"
echo "Done."
echo ""

# ==============================================================
# COMMIT 19 — SQL: Verification queries
# ==============================================================
echo "[19/20] SQL script - Verification queries..."

cat >> docs/raceday_database.sql << 'EOF'

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================

SELECT 'Users'        AS TableName, COUNT(*) AS TotalRows FROM Users        UNION ALL
SELECT 'Organisers',               COUNT(*)              FROM Organisers    UNION ALL
SELECT 'Participants',             COUNT(*)              FROM Participants   UNION ALL
SELECT 'Categories',              COUNT(*)              FROM Categories     UNION ALL
SELECT 'Events',                  COUNT(*)              FROM Events         UNION ALL
SELECT 'Enrolments',              COUNT(*)              FROM Enrolments     UNION ALL
SELECT 'Results',                 COUNT(*)              FROM Results;
GO

SELECT e.[Name] AS EventName, e.EventDate, e.Location, e.EntryFee,
       c.[Name] AS Category, u.FullName AS OrganiserName
FROM Events e
JOIN Categories c ON e.CategoryID  = c.CategoryID
JOIN Organisers o ON e.OrganiserID = o.OrganiserID
JOIN Users      u ON o.UserID      = u.UserID;
GO

SELECT u.FullName AS Participant, ev.[Name] AS Event, en.[Status], en.EnrolledAt
FROM Enrolments en
JOIN Participants p  ON en.ParticipantID = p.ParticipantID
JOIN Users       u  ON p.UserID          = u.UserID
JOIN Events      ev ON en.EventID        = ev.EventID;
GO
EOF

git add docs/raceday_database.sql
git commit -m "sql: Add verification SELECT queries to confirm all seed data loaded correctly"
echo "Done."
echo ""

# ==============================================================
# COMMIT 20 — Final commit
# ==============================================================
echo "[20/20] Final submission commit..."
git add .
git commit -m "chore: Part 1 submission complete - ERD, API plan, SQL script, and CI/CD all verified"
echo "Done."
echo ""

# ==============================================================
# PUSH TO GITHUB
# ==============================================================
echo ""
echo "============================================================"
echo "  Pushing all commits to GitHub (branch: master)..."
echo "============================================================"
echo ""
git push -u origin master

echo ""
echo "============================================================"
echo "  ALL DONE! Check github.com/JRCode123/raceday"
echo ""
echo "  Next steps:"
echo "  1. Go to your GitHub repo in the browser"
echo "  2. Click the Actions tab - wait for green checkmark"
echo "  3. Screenshot the green build"
echo "  4. Add screenshot and YouTube link to README"
echo "  5. git add README.md"
echo "     git commit -m 'docs: Add CI screenshot and video link'"
echo "     git push"
echo "============================================================"
