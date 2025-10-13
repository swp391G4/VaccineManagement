-- Child Vaccination Management System - MSSQL Database Schema

-- Drop existing tables if they exist
IF OBJECT_ID('VaccinationRecords', 'U') IS NOT NULL DROP TABLE VaccinationRecords;
IF OBJECT_ID('Appointments', 'U') IS NOT NULL DROP TABLE Appointments;
IF OBJECT_ID('VaccineStock', 'U') IS NOT NULL DROP TABLE VaccineStock;
IF OBJECT_ID('StaffAssignments', 'U') IS NOT NULL DROP TABLE StaffAssignments;
IF OBJECT_ID('WorkingSchedule', 'U') IS NOT NULL DROP TABLE WorkingSchedule;
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('Children', 'U') IS NOT NULL DROP TABLE Children;
IF OBJECT_ID('Vaccines', 'U') IS NOT NULL DROP TABLE Vaccines;
IF OBJECT_ID('Centers', 'U') IS NOT NULL DROP TABLE Centers;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;

-- Create Database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    CREATE DATABASE VaccinationDB;
END
GO

USE VaccinationDB;
GO

-- Users Table (Parent, Staff, Admin)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('ADMIN', 'RECEPTION', 'MEDICAL', 'PARENT')),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME,
    INDEX idx_email (Email),
    INDEX idx_role (Role)
);

-- Vaccination Centers Table
CREATE TABLE Centers (
    CenterID INT IDENTITY(1,1) PRIMARY KEY,
    CenterName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    City NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    OperatingHours NVARCHAR(200),
    Capacity INT DEFAULT 50,
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX idx_active (IsActive)
);

-- Vaccines Table
CREATE TABLE Vaccines (
    VaccineID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineName NVARCHAR(200) NOT NULL,
    Manufacturer NVARCHAR(200),
    Description NVARCHAR(MAX),
    DiseasesPrevented NVARCHAR(500),
    DosageSchedule NVARCHAR(500),
    RecommendedAge NVARCHAR(100),
    Price DECIMAL(10,2) DEFAULT 0,
    IsActive BIT DEFAULT 1,
    SideEffects NVARCHAR(MAX),
    Contraindications NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX idx_active (IsActive)
);

-- Children Table
CREATE TABLE Children (
    ChildID INT IDENTITY(1,1) PRIMARY KEY,
    ParentID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    BloodType NVARCHAR(10),
    MedicalHistory NVARCHAR(MAX),
    Allergies NVARCHAR(MAX),
    Weight DECIMAL(5,2),
    Height DECIMAL(5,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentID) REFERENCES Users(UserID),
    INDEX idx_parent (ParentID),
    INDEX idx_dob (DateOfBirth)
);

-- Vaccine Stock Table (per Center)
CREATE TABLE VaccineStock (
    StockID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineID INT NOT NULL,
    CenterID INT NOT NULL,
    BatchNumber NVARCHAR(100) NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    ExpiryDate DATE NOT NULL,
    ReceivedDate DATE DEFAULT CAST(GETDATE() AS DATE),
    Status NVARCHAR(20) CHECK (Status IN ('AVAILABLE', 'RESERVED', 'EXPIRED', 'DEPLETED')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_center_vaccine (CenterID, VaccineID),
    INDEX idx_expiry (ExpiryDate)
);

-- Working Schedule Table
CREATE TABLE WorkingSchedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    CenterID INT NOT NULL,
    DayOfWeek NVARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    SlotDuration INT DEFAULT 30,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_center_day (CenterID, DayOfWeek)
);

-- Staff Assignments Table
CREATE TABLE StaffAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CenterID INT NOT NULL,
    AssignedDate DATE DEFAULT CAST(GETDATE() AS DATE),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_staff_center (UserID, CenterID)
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    ChildID INT NOT NULL,
    VaccineID INT NOT NULL,
    CenterID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status NVARCHAR(20) DEFAULT 'PENDING' CHECK (Status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'REJECTED', 'NO_SHOW')),
    PaymentStatus NVARCHAR(20) DEFAULT 'UNPAID' CHECK (PaymentStatus IN ('UNPAID', 'PAID', 'REFUNDED')),
    PaymentAmount DECIMAL(10,2),
    Notes NVARCHAR(MAX),
    ConfirmedBy INT,
    ConfirmedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ChildID) REFERENCES Children(ChildID),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    FOREIGN KEY (ConfirmedBy) REFERENCES Users(UserID),
    INDEX idx_child (ChildID),
    INDEX idx_appointment_date (AppointmentDate),
    INDEX idx_status (Status)
);

-- Vaccination Records Table
CREATE TABLE VaccinationRecords (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    ChildID INT NOT NULL,
    VaccineID INT NOT NULL,
    VaccinationDate DATETIME NOT NULL,
    BatchNumber NVARCHAR(100),
    DoseNumber INT,
    AdministeredBy INT NOT NULL,
    HealthCheckNotes NVARCHAR(MAX),
    VaccinationNotes NVARCHAR(MAX),
    SideEffectsReported NVARCHAR(MAX),
    NextDoseDate DATE,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (ChildID) REFERENCES Children(ChildID),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (AdministeredBy) REFERENCES Users(UserID),
    INDEX idx_child_vaccine (ChildID, VaccineID),
    INDEX idx_vaccination_date (VaccinationDate)
);

-- Notifications Table
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) CHECK (Type IN ('REMINDER', 'CONFIRMATION', 'CANCELLATION', 'UPDATE', 'SYSTEM')),
    IsRead BIT DEFAULT 0,
    RelatedAppointmentID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    ReadAt DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RelatedAppointmentID) REFERENCES Appointments(AppointmentID),
    INDEX idx_user_read (UserID, IsRead)
);

-- Insert Default Admin User (password: Admin@123)
INSERT INTO Users (Email, PasswordHash, FullName, PhoneNumber, Role, IsActive) 
VALUES ('admin@vaccination.com', 
        'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
        'System Administrator', 
        '0123456789', 
        'ADMIN', 
        1);

-- Insert Sample Vaccination Centers
INSERT INTO Centers (CenterName, Address, City, PhoneNumber, Email, OperatingHours, Capacity) VALUES
('Hanoi Vaccination Center', '123 Hoang Quoc Viet, Cau Giay', 'Hanoi', '024-1234-5678', 'hanoi@vaccination.com', 'Mon-Sat: 8:00-17:00', 100),
('District 1 Medical Center', '456 Nguyen Trai, Thanh Xuan', 'Hanoi', '024-2345-6789', 'district1@vaccination.com', 'Mon-Fri: 8:00-18:00', 80),
('Children Hospital Center', '789 La Thanh, Dong Da', 'Hanoi', '024-3456-7890', 'children@vaccination.com', 'Mon-Sun: 7:00-19:00', 150);

-- Insert Common Vaccines
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, RecommendedAge, Price) VALUES
('BCG Vaccine', 'Serum Institute', 'Bacillus Calmette-Guérin vaccine', 'Tuberculosis', '0-12 months', 50000),
('Hepatitis B', 'GSK', 'Hepatitis B vaccine', 'Hepatitis B', '0-6 months', 80000),
('DPT Vaccine', 'Sanofi Pasteur', 'Diphtheria, Pertussis, Tetanus vaccine', 'Diphtheria, Pertussis, Tetanus', '2-6 months', 120000),
('Polio Vaccine', 'Serum Institute', 'Oral Polio Vaccine', 'Poliomyelitis', '2-18 months', 60000),
('MMR Vaccine', 'Merck', 'Measles, Mumps, Rubella vaccine', 'Measles, Mumps, Rubella', '9-18 months', 200000),
('Varicella Vaccine', 'GSK', 'Chickenpox vaccine', 'Chickenpox', '12-24 months', 350000),
('Pneumococcal', 'Pfizer', 'Pneumococcal conjugate vaccine', 'Pneumococcal diseases', '2-12 months', 1200000),
('Rotavirus', 'GSK', 'Rotavirus vaccine', 'Rotavirus gastroenteritis', '2-6 months', 800000);

-- Insert Sample Vaccine Stock
INSERT INTO VaccineStock (VaccineID, CenterID, BatchNumber, Quantity, ExpiryDate, Status) VALUES
(1, 1, 'BCG2024001', 500, '2025-12-31', 'AVAILABLE'),
(2, 1, 'HBV2024001', 400, '2025-11-30', 'AVAILABLE'),
(3, 1, 'DPT2024001', 300, '2025-10-31', 'AVAILABLE'),
(1, 2, 'BCG2024002', 300, '2025-12-31', 'AVAILABLE'),
(2, 2, 'HBV2024002', 250, '2025-11-30', 'AVAILABLE'),
(5, 3, 'MMR2024001', 200, '2025-09-30', 'AVAILABLE');

-- Insert Working Schedules
INSERT INTO WorkingSchedule (CenterID, DayOfWeek, StartTime, EndTime, SlotDuration) VALUES
(1, 'Monday', '08:00', '17:00', 30),
(1, 'Tuesday', '08:00', '17:00', 30),
(1, 'Wednesday', '08:00', '17:00', 30),
(1, 'Thursday', '08:00', '17:00', 30),
(1, 'Friday', '08:00', '17:00', 30),
(1, 'Saturday', '08:00', '12:00', 30);

GO
