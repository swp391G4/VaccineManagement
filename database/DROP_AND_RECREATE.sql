-- ============================================
-- DROP AND RECREATE DATABASE
-- Xóa và tạo lại database hoàn toàn
-- ============================================

-- HƯỚNG DẪN SỬ DỤNG:
-- 1. Chạy file này trước: database/DROP_AND_RECREATE.sql
-- 2. Sau đó chạy file: database/schema.sql
-- 3. Login với: admin@vaccination.com / Admin@123

-- ============================================

-- Step 1: Drop existing database
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VaccinationDB;
    PRINT 'Database VaccinationDB đã được xóa thành công!';
END
GO

PRINT '==============================================';
PRINT 'Bước tiếp theo:';
PRINT '1. Chạy file: database/schema.sql';
PRINT '2. Database mới sẽ có:';
PRINT '   - Cột Password (không còn PasswordHash)';
PRINT '   - Admin: admin@vaccination.com / Admin@123';
PRINT '3. Code đã được cập nhật để dùng plain text';
PRINT '==============================================';
