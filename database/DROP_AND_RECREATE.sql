-- ============================================
-- DROP AND RECREATE DATABASE
-- Cách 2: Xóa và tạo lại database hoàn toàn
-- ============================================

-- Step 1: Drop existing database
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VaccinationDB;
    PRINT 'Database VaccinationDB đã được xóa';
END
GO

-- Step 2: Chạy lại file schema.sql để tạo database mới
-- Sau khi chạy file này, hãy chạy file schema.sql

PRINT '==============================================';
PRINT 'Bước tiếp theo:';
PRINT '1. Chạy file: database/schema.sql';
PRINT '2. Database mới sẽ có admin password: Admin@123';
PRINT '==============================================';
