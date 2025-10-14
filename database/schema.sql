-- ============================================
-- Child Vaccination Management System
-- MSSQL Database Schema
-- ============================================
-- HƯỚNG DẪN: Chạy file này để tạo database hoàn chỉnh
-- Admin login: admin@vaccination.com / Admin@123
-- ============================================

-- Step 1: Drop existing database if exists (để tạo mới hoàn toàn)
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VaccinationDB;
    PRINT 'Database cũ đã được xóa';
END
GO

-- Step 2: Create new database
CREATE DATABASE VaccinationDB;
GO

PRINT 'Database mới đã được tạo';
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

-- Vaccination Schedule Template (Lịch khuyến nghị tiêm chủng)
CREATE TABLE VaccinationScheduleTemplate (
    TemplateID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineID INT NOT NULL,
    StageName NVARCHAR(200) NOT NULL,
    AgeInMonths INT NOT NULL,
    DoseNumber INT NOT NULL,
    Description NVARCHAR(MAX),
    IsMandatory BIT DEFAULT 1,
    DisplayOrder INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    INDEX idx_age (AgeInMonths),
    INDEX idx_vaccine (VaccineID)
);

-- Insert Default Admin User (password: Admin@123)
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive) 
VALUES ('admin@vaccination.com', 
        'Admin@123',
        'System Administrator', 
        '0123456789', 
        'ADMIN', 
        1);

-- Insert Sample Vaccination Centers
INSERT INTO Centers (CenterName, Address, City, PhoneNumber, Email, OperatingHours, Capacity) VALUES
('Hanoi Vaccination Center', '123 Hoang Quoc Viet, Cau Giay', 'Hanoi', '024-1234-5678', 'hanoi@vaccination.com', 'Mon-Sat: 8:00-17:00', 100),
('District 1 Medical Center', '456 Nguyen Trai, Thanh Xuan', 'Hanoi', '024-2345-6789', 'district1@vaccination.com', 'Mon-Fri: 8:00-18:00', 80),
('Children Hospital Center', '789 La Thanh, Dong Da', 'Hanoi', '024-3456-7890', 'children@vaccination.com', 'Mon-Sun: 7:00-19:00', 150);

-- Insert Vaccines (MIỄN PHÍ - Chương trình TCMR và TRẢ PHÍ - Dịch vụ)
-- VACCINE MIỄN PHÍ (IsFree = 1)
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, RecommendedAge, Price, IsFree) VALUES
-- Giai đoạn sơ sinh
('Viêm gan B (mũi 0)', 'POLYVAC', 'Vaccine viêm gan B mũi 0', 'Viêm gan B', 'Sơ sinh (24h đầu)', 0, 1),
('Lao (BCG)', 'Serum Institute', 'Vaccine phòng bệnh lao', 'Lao', 'Sơ sinh', 0, 1),

-- 5 trong 1 (Quintanrix/Pentaxim)
('5 trong 1 (mũi 1)', 'GSK', 'Vaccine 5 trong 1', 'Bạch hầu, Ho gà, Uốn ván, Viêm gan B, Hib', '2 tháng tuổi', 0, 1),
('5 trong 1 (mũi 2)', 'GSK', 'Vaccine 5 trong 1', 'Bạch hầu, Ho gà, Uốn ván, Viêm gan B, Hib', '3 tháng tuổi', 0, 1),
('5 trong 1 (mũi 3)', 'GSK', 'Vaccine 5 trong 1', 'Bạch hầu, Ho gà, Uốn ván, Viêm gan B, Hib', '4 tháng tuổi', 0, 1),

-- Bại liệt (uống)
('Bại liệt (uống lần 1)', 'Bio Farma', 'Vaccine bại liệt uống', 'Bại liệt', '2 tháng tuổi', 0, 1),
('Bại liệt (uống lần 2)', 'Bio Farma', 'Vaccine bại liệt uống', 'Bại liệt', '3 tháng tuổi', 0, 1),
('Bại liệt (uống lần 3)', 'Bio Farma', 'Vaccine bại liệt uống', 'Bại liệt', '4 tháng tuổi', 0, 1),

-- Sởi và Viêm não Nhật Bản
('Sởi đơn (mũi 1)', 'Serum Institute', 'Vaccine phòng bệnh sởi', 'Sởi', '9 tháng tuổi', 0, 1),
('Viêm não Nhật Bản (mũi 1)', 'VABIOTECH', 'Vaccine phòng viêm não Nhật Bản', 'Viêm não Nhật Bản', '12 tháng tuổi', 0, 1),
('Viêm não Nhật Bản (mũi 2)', 'VABIOTECH', 'Vaccine phòng viêm não Nhật Bản', 'Viêm não Nhật Bản', '12 tháng + 1-2 tuần', 0, 1),
('Viêm não Nhật Bản (mũi 3)', 'VABIOTECH', 'Vaccine phòng viêm não Nhật Bản', 'Viêm não Nhật Bản', '24 tháng tuổi', 0, 1),

-- 18 tháng
('Sởi - Rubella (MR)', 'Serum Institute', 'Vaccine phòng sởi và rubella', 'Sởi, Rubella', '18 tháng tuổi', 0, 1),
('DPT (mũi 4 - nhắc lại)', 'VABIOTECH', 'Vaccine nhắc lại bạch hầu, ho gà, uốn ván', 'Bạch hầu, Ho gà, Uốn ván', '18 tháng tuổi', 0, 1);

-- VACCINE TRẢ PHÍ (IsFree = 0) - Dịch vụ
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, RecommendedAge, Price, IsFree) VALUES
-- Tiêu chảy Rotavirus
('Tiêu chảy do Rota (liều 1)', 'GSK/MSD', 'Vaccine phòng tiêu chảy do Rotavirus', 'Viêm dạ dày-ruột do Rotavirus', '2 tháng tuổi', 800000, 0),
('Tiêu chảy do Rota (liều 2)', 'GSK/MSD', 'Vaccine phòng tiêu chảy do Rotavirus', 'Viêm dạ dày-ruột do Rotavirus', '3 tháng tuổi', 800000, 0),
('Tiêu chảy do Rota (liều 3)', 'GSK/MSD', 'Vaccine phòng tiêu chảy do Rotavirus', 'Viêm dạ dày-ruột do Rotavirus', '4 tháng tuổi', 800000, 0),

-- Phế cầu (Pneumococcal)
('Phế cầu (mũi 1)', 'Pfizer', 'Vaccine phòng phế cầu khuẩn', 'Viêm phổi, viêm màng não, viêm tai giữa do phế cầu', '2 tháng tuổi', 1200000, 0),
('Phế cầu (mũi 2)', 'Pfizer', 'Vaccine phòng phế cầu khuẩn', 'Viêm phổi, viêm màng não, viêm tai giữa do phế cầu', '3 tháng tuổi', 1200000, 0),
('Phế cầu (mũi 3)', 'Pfizer', 'Vaccine phòng phế cầu khuẩn', 'Viêm phổi, viêm màng não, viêm tai giữa do phế cầu', '4 tháng tuổi', 1200000, 0),
('Phế cầu (mũi 4 - nhắc lại)', 'Pfizer', 'Vaccine phòng phế cầu khuẩn', 'Viêm phổi, viêm màng não, viêm tai giữa do phế cầu', '12 tháng tuổi', 1200000, 0),

-- MMR và Thủy đậu (12 tháng)
('Sởi - Quai bị - Rubella (MMR)', 'Merck', 'Vaccine phòng sởi, quai bị, rubella', 'Sởi, Quai bị, Rubella', '12 tháng tuổi', 350000, 0),
('Thủy đậu (mũi 1)', 'GSK', 'Vaccine phòng thủy đậu', 'Thủy đậu', '12 tháng tuổi', 450000, 0);

-- Insert Vaccination Schedule Template (Lịch tiêm khuyến nghị theo tuổi)
-- Giai đoạn 1: Sơ sinh
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(1, 'Giai đoạn sơ sinh', 0, 1, 'Tiêm trong vòng 24 giờ đầu sau sinh', 1, 1),
(2, 'Giai đoạn sơ sinh', 0, 1, 'Tiêm càng sớm càng tốt, 1 lần duy nhất', 1, 2);

-- Giai đoạn 2: 2 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(3, 'Bé 2 tháng tuổi', 2, 1, 'Mũi 1 vaccine 5 trong 1', 1, 3),
(6, 'Bé 2 tháng tuổi', 2, 1, 'Uống lần 1 vaccine bại liệt', 1, 4),
(15, 'Bé 2 tháng tuổi', 2, 1, 'Liều 1 vaccine Rota (tự nguyện, trả phí)', 0, 5),
(18, 'Bé 2 tháng tuổi', 2, 1, 'Mũi 1 vaccine phế cầu (tự nguyện, trả phí)', 0, 6);

-- Giai đoạn 3: 3 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(4, 'Bé 3 tháng tuổi', 3, 2, 'Mũi 2 vaccine 5 trong 1', 1, 7),
(7, 'Bé 3 tháng tuổi', 3, 2, 'Uống lần 2 vaccine bại liệt', 1, 8),
(16, 'Bé 3 tháng tuổi', 3, 2, 'Liều 2 vaccine Rota (tự nguyện, trả phí)', 0, 9),
(19, 'Bé 3 tháng tuổi', 3, 2, 'Mũi 2 vaccine phế cầu (tự nguyện, trả phí)', 0, 10);

-- Giai đoạn 4: 4 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(5, 'Bé 4 tháng tuổi', 4, 3, 'Mũi 3 vaccine 5 trong 1', 1, 11),
(8, 'Bé 4 tháng tuổi', 4, 3, 'Uống lần 3 vaccine bại liệt', 1, 12),
(17, 'Bé 4 tháng tuổi', 4, 3, 'Liều 3 vaccine Rota (nếu dùng loại 3 liều, trả phí)', 0, 13),
(20, 'Bé 4 tháng tuổi', 4, 3, 'Mũi 3 vaccine phế cầu (tự nguyện, trả phí)', 0, 14);

-- Giai đoạn 5: 9 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(9, 'Bé 9 tháng tuổi', 9, 1, 'Mũi 1 vaccine sởi đơn', 1, 15);

-- Giai đoạn 6: 12 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(10, 'Bé 12 tháng tuổi', 12, 1, 'Mũi 1 vaccine viêm não Nhật Bản', 1, 16),
(22, 'Bé 12 tháng tuổi', 12, 1, 'Vaccine MMR (Sởi-Quai bị-Rubella, tự nguyện, trả phí)', 0, 17),
(23, 'Bé 12 tháng tuổi', 12, 1, 'Mũi 1 vaccine thủy đậu (tự nguyện, trả phí)', 0, 18),
(21, 'Bé 12 tháng tuổi', 12, 4, 'Mũi nhắc lại vaccine phế cầu (tự nguyện, trả phí)', 0, 19);

-- Sau 12 tháng: VNNB mũi 2 (cách mũi 1 khoảng 1-2 tuần, tính là 12.5 tháng)
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(11, 'Sau mũi VNNB 1 (1-2 tuần)', 12, 2, 'Mũi 2 vaccine viêm não Nhật Bản (cách mũi 1 từ 1-2 tuần)', 1, 20);

-- Giai đoạn 7: 18 tháng tuổi
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(13, 'Bé 18 tháng tuổi', 18, 2, 'Vaccine Sởi-Rubella (MR) - mũi sởi thứ 2', 1, 21),
(14, 'Bé 18 tháng tuổi', 18, 4, 'Mũi nhắc lại DPT', 1, 22);

-- 24 tháng: VNNB mũi 3
INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder) VALUES
(12, 'Bé 24 tháng tuổi (2 tuổi)', 24, 3, 'Mũi 3 vaccine viêm não Nhật Bản (cách mũi 2 một năm)', 1, 23);

-- Insert Sample Vaccine Stock
INSERT INTO VaccineStock (VaccineID, CenterID, BatchNumber, Quantity, ExpiryDate, Status) VALUES
(1, 1, 'HBV2024001', 500, '2025-12-31', 'AVAILABLE'),
(2, 1, 'BCG2024001', 400, '2025-11-30', 'AVAILABLE'),
(3, 1, '5IN1-2024001', 300, '2025-10-31', 'AVAILABLE'),
(1, 2, 'HBV2024002', 300, '2025-12-31', 'AVAILABLE'),
(2, 2, 'BCG2024002', 250, '2025-11-30', 'AVAILABLE'),
(9, 3, 'MEASLES2024001', 200, '2025-09-30', 'AVAILABLE');

-- Insert Working Schedules
INSERT INTO WorkingSchedule (CenterID, DayOfWeek, StartTime, EndTime, SlotDuration) VALUES
(1, 'Monday', '08:00', '17:00', 30),
(1, 'Tuesday', '08:00', '17:00', 30),
(1, 'Wednesday', '08:00', '17:00', 30),
(1, 'Thursday', '08:00', '17:00', 30),
(1, 'Friday', '08:00', '17:00', 30),
(1, 'Saturday', '08:00', '12:00', 30);

GO
