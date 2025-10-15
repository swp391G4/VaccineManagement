-- ============================================
-- Child Vaccination Management System
-- MSSQL Database Schema - LICH TIEM TCMR CHINH XAC
-- ============================================
-- HUONG DAN: Chay file nay de tao database hoan chinh
-- Admin login: admin@vaccination.com / Admin@123
-- ============================================

-- Step 1: Drop existing database if exists (de tao moi hoan toan)
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VaccinationDB;
    PRINT 'Database cu da duoc xoa';
END
GO

-- Step 2: Create new database
CREATE DATABASE VaccinationDB;
GO

PRINT 'Database moi da duoc tao';
GO

USE VaccinationDB;
GO

-- Users Table (Parent, Staff, Admin)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
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
    IsFree BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    SideEffects NVARCHAR(MAX),
    Contraindications NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX idx_active (IsActive),
    INDEX idx_free (IsFree)
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

-- Vaccination Schedule Template (Lich khuyen nghi tiem chung TCMR)
CREATE TABLE VaccinationScheduleTemplate (
    TemplateID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineID INT NOT NULL,
    StageName NVARCHAR(200) NOT NULL,
    AgeInMonths DECIMAL(5,2) NOT NULL,
    DoseNumber INT NOT NULL,
    Description NVARCHAR(MAX),
    IsMandatory BIT DEFAULT 1,
    DisplayOrder INT,
    CanCombineWith NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    INDEX idx_age (AgeInMonths),
    INDEX idx_vaccine (VaccineID)
);

-- Insert Default Admin User (password: Admin@123)
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) 
VALUES ('admin@vaccination.com', 'Admin@123', 'System Administrator', '0900000000', 'ADMIN', 1);

-- Insert Sample Centers
INSERT INTO Centers (CenterName, Address, City, PhoneNumber, Email, OperatingHours, IsActive) VALUES
('Trung tam Y te Quan 1', '123 Le Loi, Quan 1', 'Ho Chi Minh', '0283822222', 'q1@health.gov.vn', 'Mon-Sat: 7:00-17:00', 1),
('Benh vien Nhi Dong 1', '341 Su Van Hanh, Quan 10', 'Ho Chi Minh', '0283865100', 'nhi1@health.gov.vn', 'Mon-Sun: 7:00-20:00', 1),
('Trung tam Y te Du phong TP.HCM', '159 Hung Phu, Quan 8', 'Ho Chi Minh', '0283855555', 'yte-dp@health.gov.vn', 'Mon-Fri: 7:00-16:30', 1);

-- ============================================
-- VACCINES - LICH TIEM TCMR CHINH XAC
-- ============================================

-- VACCINE MIEN PHI (IsFree = 1)
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, DosageSchedule, RecommendedAge, Price, IsFree, IsActive) VALUES
-- 0-24 gio
('Viem gan B (mui so sinh)', 'Vac-xin Viet Nam', 'Vaccine phong viem gan B cho tre so sinh', 'Viem gan B', 'Tiem trong 24 gio dau sau sinh', '0-24 gio', 0, 1, 1),
-- Trong 1 thang
('Lao (BCG)', 'Vac-xin Viet Nam', 'Vaccine phong benh lao', 'Lao', 'Tiem 1 mui trong thang dau', '0-1 thang', 0, 1, 1),
-- 2 thang
('5 trong 1 (mui 1)', 'Vac-xin Viet Nam', 'Vaccine phong bach hau, ho ga, uon van, Hib, viem gan B', 'Bach hau, Ho ga, Uon van, Hib, Viem gan B', 'Mui 1/4 - tiem o 2 thang tuoi', '2 thang', 0, 1, 1),
-- 3 thang  
('5 trong 1 (mui 2)', 'Vac-xin Viet Nam', 'Vaccine phong bach hau, ho ga, uon van, Hib, viem gan B', 'Bach hau, Ho ga, Uon van, Hib, Viem gan B', 'Mui 2/4 - tiem o 3 thang tuoi', '3 thang', 0, 1, 1),
-- 4 thang
('5 trong 1 (mui 3)', 'Vac-xin Viet Nam', 'Vaccine phong bach hau, ho ga, uon van, Hib, viem gan B', 'Bach hau, Ho ga, Uon van, Hib, Viem gan B', 'Mui 3/4 - tiem o 4 thang tuoi', '4 thang', 0, 1, 1),
-- 5 thang
('Bai liet IPV (mui 1)', 'Vac-xin Viet Nam', 'Vaccine phong bai liet (tiem)', 'Bai liet', 'Tiem mui 1 o 5 thang tuoi', '5 thang', 0, 1, 1),
-- 9 thang
('Soi (mui 1)', 'Vac-xin Viet Nam', 'Vaccine phong benh soi', 'Soi', 'Tiem mui 1 o 9 thang tuoi', '9 thang', 0, 1, 1),
-- 12 thang
('Viem nao Nhat Ban (mui 1)', 'Vac-xin Viet Nam', 'Vaccine phong viem nao Nhat Ban', 'Viem nao Nhat Ban', 'Tiem mui 1 o 12 thang tuoi', '12 thang', 0, 1, 1),
-- 12.5 thang (12 thang + 1-2 tuan)
('Viem nao Nhat Ban (mui 2)', 'Vac-xin Viet Nam', 'Vaccine phong viem nao Nhat Ban', 'Viem nao Nhat Ban', 'Tiem mui 2 cach mui 1 tu 1-2 tuan', '12.5 thang', 0, 1, 1),
-- 18 thang
('5 trong 1 (mui nhac lai)', 'Vac-xin Viet Nam', 'Vaccine phong bach hau, ho ga, uon van, Hib, viem gan B - nhac lai', 'Bach hau, Ho ga, Uon van, Hib, Viem gan B', 'Mui 4/4 - nhac lai o 18 thang', '18 thang', 0, 1, 1),
('Soi - Rubella MR (mui 2)', 'Vac-xin Viet Nam', 'Vaccine phong soi va rubella', 'Soi, Rubella', 'Tiem mui 2 o 18 thang tuoi', '18 thang', 0, 1, 1),
-- 24 thang
('Viem nao Nhat Ban (mui 3)', 'Vac-xin Viet Nam', 'Vaccine phong viem nao Nhat Ban', 'Viem nao Nhat Ban', 'Tiem mui 3 cach mui 2 mot nam', '24 thang', 0, 1, 1),
-- 7 tuoi (84 thang)
('Bach hau - Uon van giam lieu (Td)', 'Vac-xin Viet Nam', 'Vaccine phong bach hau va uon van giam lieu', 'Bach hau, Uon van', 'Tiem nhac lai o 7 tuoi', '7 tuoi', 0, 1, 1);

-- VACCINE TRA PHI (IsFree = 0) - DICH VU
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, DosageSchedule, RecommendedAge, Price, IsFree, IsActive) VALUES
('Rota (lieu 1)', 'GSK', 'Vaccine phong viem duong ruot do Rotavirus', 'Viem duong ruot Rotavirus', 'Uong lieu 1 o 2 thang tuoi', '2 thang', 650000, 0, 1),
('Rota (lieu 2)', 'GSK', 'Vaccine phong viem duong ruot do Rotavirus', 'Viem duong ruot Rotavirus', 'Uong lieu 2 o 3 thang tuoi', '3 thang', 650000, 0, 1),
('Phe cau (mui 1)', 'Pfizer', 'Vaccine phong nhiem khuan phe cau', 'Viem phoi, Viem mang nao do phe cau', 'Tiem mui 1 o 2 thang tuoi', '2 thang', 1200000, 0, 1),
('Phe cau (mui 2)', 'Pfizer', 'Vaccine phong nhiem khuan phe cau', 'Viem phoi, Viem mang nao do phe cau', 'Tiem mui 2 o 4 thang tuoi', '4 thang', 1200000, 0, 1),
('Phe cau (mui 3)', 'Pfizer', 'Vaccine phong nhiem khuan phe cau', 'Viem phoi, Viem mang nao do phe cau', 'Tiem mui 3 o 6 thang tuoi', '6 thang', 1200000, 0, 1),
('Phe cau (mui nhac lai)', 'Pfizer', 'Vaccine phong nhiem khuan phe cau', 'Viem phoi, Viem mang nao do phe cau', 'Tiem nhac lai o 12-15 thang tuoi', '12 thang', 1200000, 0, 1),
('Thuy dau (mui 1)', 'GSK', 'Vaccine phong benh thuy dau', 'Thuy dau', 'Tiem mui 1 o 12 thang tuoi', '12 thang', 450000, 0, 1),
('Thuy dau (mui 2)', 'GSK', 'Vaccine phong benh thuy dau', 'Thuy dau', 'Tiem mui 2 o 18-24 thang tuoi', '18 thang', 450000, 0, 1),
('Cum (hang nam)', 'Sanofi', 'Vaccine phong benh cum mua', 'Cum', 'Tiem hang nam tu 6 thang tuoi', '6 thang', 350000, 0, 1),
('6 trong 1', 'GSK/Sanofi', 'Vaccine phong bach hau, ho ga, uon van, Hib, viem gan B, bai liet', 'Bach hau, Ho ga, Uon van, Hib, Viem gan B, Bai liet', 'Thay the 5 trong 1 (tu nguyen)', '2 thang', 850000, 0, 1);

-- ============================================
-- VACCINATION SCHEDULE TEMPLATE - LICH TCMR
-- ============================================

-- 0-24 GIO SAU SINH (AgeInMonths = 0)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(1, '0-24 gio sau sinh', 0, 1, 'Tiem 1 mui duy nhat trong 24 gio dau', 1, 1, NULL);

-- TRONG 1 THANG DAU (AgeInMonths = 0.5 ~ 2 tuan)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(2, 'Trong 1 thang dau', 0.5, 1, 'Tiem 1 mui (cach vaccine viem gan B it nhat 24h)', 1, 2, NULL);

-- 2 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(3, '2 thang tuoi', 2, 1, '5 trong 1 - mui 1', 1, 3, '15'),
(15, '2 thang tuoi', 2, 1, 'Rota - lieu 1 (dich vu, tu nguyen)', 0, 4, '3'),
(17, '2 thang tuoi', 2, 1, 'Phe cau - mui 1 (dich vu, tu nguyen)', 0, 5, '3,15');

-- 3 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(4, '3 thang tuoi', 3, 2, '5 trong 1 - mui 2', 1, 6, '16'),
(16, '3 thang tuoi', 3, 2, 'Rota - lieu 2 (dich vu, tu nguyen)', 0, 7, '4');

-- 4 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(5, '4 thang tuoi', 4, 3, '5 trong 1 - mui 3', 1, 8, '18'),
(18, '4 thang tuoi', 4, 2, 'Phe cau - mui 2 (dich vu, tu nguyen)', 0, 9, '5');

-- 5 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(6, '5 thang tuoi', 5, 1, 'Bai liet IPV - tiem mui 1', 1, 10, NULL);

-- 6 THANG TUOI (chi co vaccine tra phi)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(19, '6 thang tuoi', 6, 3, 'Phe cau - mui 3 (dich vu, tu nguyen)', 0, 11, '23'),
(23, '6 thang tuoi', 6, 1, 'Cum - hang nam (dich vu, tu nguyen)', 0, 12, '19');

-- 9 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(7, '9 thang tuoi', 9, 1, 'Soi - mui 1 (vaccine song)', 1, 13, NULL);

-- 12 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(8, '12 thang tuoi', 12, 1, 'Viem nao Nhat Ban - mui 1', 1, 14, '20,21'),
(20, '12 thang tuoi', 12, 4, 'Phe cau - mui nhac lai (dich vu)', 0, 15, '8,21'),
(21, '12 thang tuoi', 12, 1, 'Thuy dau - mui 1 (dich vu)', 0, 16, '8,20');

-- 12.5 THANG (12 THANG + 1-2 TUAN)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(9, '12 thang + 1-2 tuan', 12.5, 2, 'Viem nao Nhat Ban - mui 2 (cach mui 1 tu 1-2 tuan)', 1, 17, NULL);

-- 18 THANG TUOI
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(10, '18 thang tuoi', 18, 4, '5 trong 1 - mui nhac lai', 1, 18, '11'),
(11, '18 thang tuoi', 18, 2, 'Soi-Rubella (MR) - mui 2', 1, 19, '10'),
(22, '18 thang tuoi', 18, 2, 'Thuy dau - mui 2 (dich vu)', 0, 20, NULL);

-- 24 THANG TUOI (2 TUOI)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(12, '24 thang tuoi (2 tuoi)', 24, 3, 'Viem nao Nhat Ban - mui 3 (cach mui 2 mot nam)', 1, 21, NULL);

-- 7 TUOI (84 THANG - LOP 2)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(13, '7 tuoi (lop 2)', 84, 1, 'Bach hau - Uon van giam lieu (Td) - mui nhac lai', 1, 22, NULL);

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Insert Sample Parent Users
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) VALUES
('parent1@test.com', '123456', 'Nguyen Van A', '0901234567', 'PARENT', 1),
('parent2@test.com', '123456', 'Tran Thi B', '0909876543', 'PARENT', 1);

-- Insert Sample Reception Staff
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) VALUES
('reception1@test.com', '123456', 'Le Van C', '0912345678', 'RECEPTION', 1);

-- Insert Sample Medical Staff
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) VALUES
('doctor1@test.com', '123456', 'Bac si Pham Thi D', '0923456789', 'MEDICAL', 1);

-- Insert Working Schedule for Centers
INSERT INTO WorkingSchedule (CenterID, DayOfWeek, StartTime, EndTime, SlotDuration, IsActive) VALUES
(1, 'Monday', '08:00', '17:00', 30, 1),
(1, 'Tuesday', '08:00', '17:00', 30, 1),
(1, 'Wednesday', '08:00', '17:00', 30, 1),
(1, 'Thursday', '08:00', '17:00', 30, 1),
(1, 'Friday', '08:00', '17:00', 30, 1),
(1, 'Saturday', '08:00', '12:00', 30, 1),
(2, 'Monday', '07:00', '20:00', 30, 1),
(2, 'Tuesday', '07:00', '20:00', 30, 1),
(2, 'Wednesday', '07:00', '20:00', 30, 1),
(2, 'Thursday', '07:00', '20:00', 30, 1),
(2, 'Friday', '07:00', '20:00', 30, 1),
(2, 'Saturday', '07:00', '20:00', 30, 1),
(2, 'Sunday', '07:00', '20:00', 30, 1);

-- Insert Staff Assignments
INSERT INTO StaffAssignments (UserID, CenterID, IsActive) VALUES
(3, 1, 1),
(4, 2, 1);

-- Insert Sample Vaccine Stock
INSERT INTO VaccineStock (VaccineID, CenterID, BatchNumber, Quantity, ExpiryDate, Status) VALUES
(1, 1, 'HBV2024001', 500, '2025-12-31', 'AVAILABLE'),
(2, 1, 'BCG2024001', 300, '2025-12-31', 'AVAILABLE'),
(3, 1, '5IN12024001', 400, '2025-12-31', 'AVAILABLE'),
(7, 1, 'MEASLES2024001', 250, '2025-12-31', 'AVAILABLE'),
(8, 1, 'JE2024001', 200, '2025-12-31', 'AVAILABLE'),
(1, 2, 'HBV2024002', 600, '2025-12-31', 'AVAILABLE'),
(2, 2, 'BCG2024002', 400, '2025-12-31', 'AVAILABLE'),
(3, 2, '5IN12024002', 500, '2025-12-31', 'AVAILABLE');

PRINT 'Database setup completed with TCMR vaccination schedule!';
GO
