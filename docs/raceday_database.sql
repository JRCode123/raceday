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
