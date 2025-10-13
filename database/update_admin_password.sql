-- Update Admin Password to Plain Text
-- Run this script on your MSSQL database to update admin password

USE VaccinationDB;
GO

-- Update admin password from hash to plain text
UPDATE Users 
SET PasswordHash = 'Admin@123', 
    UpdatedAt = GETDATE()
WHERE Email = 'admin@vaccination.com';

-- Verify the update
SELECT UserID, Email, PasswordHash, Role, IsActive 
FROM Users 
WHERE Email = 'admin@vaccination.com';
