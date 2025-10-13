# HƯỚNG DẪN CẬP NHẬT DATABASE

## ⚠️ QUAN TRỌNG: Database đã được sửa đổi

Code hiện tại đã được cập nhật để sử dụng **plain text password** (không mã hóa):
- **Cột cũ**: `PasswordHash` (đã bỏ)
- **Cột mới**: `Password` (plain text)

## 📋 CÁC BƯỚC THỰC HIỆN

### Bước 1: Xóa database cũ
Mở **SQL Server Management Studio** hoặc **Azure Data Studio**, chạy file:
```
database/DROP_AND_RECREATE.sql
```

Hoặc chạy lệnh SQL sau:
```sql
USE master;
GO

ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE VaccinationDB;
GO
```

### Bước 2: Tạo database mới
Chạy file:
```
database/schema.sql
```

Database mới sẽ có:
- ✅ Cột `Password` (plain text, không hash)
- ✅ Admin account: `admin@vaccination.com` / `Admin@123`
- ✅ 3 Vaccination Centers
- ✅ 8 loại Vaccines
- ✅ Vaccine Stock
- ✅ Working Schedules

### Bước 3: Test đăng nhập
Truy cập: `http://localhost:5000/login`

**Thông tin đăng nhập Admin:**
- Email: `admin@vaccination.com`
- Password: `Admin@123`

## 📝 THAY ĐỔI TRONG CODE

### 1. Database Schema
```sql
-- CŨ (đã xóa):
PasswordHash NVARCHAR(255) NOT NULL

-- MỚI:
Password NVARCHAR(255) NOT NULL
```

### 2. Model User.java
```java
// CŨ (đã xóa):
private String passwordHash;
public String getPasswordHash() { ... }
public void setPasswordHash(String passwordHash) { ... }

// MỚI:
private String password;
public String getPassword() { ... }
public void setPassword(String password) { ... }
```

### 3. UserDAO.java
```java
// CŨ (đã xóa):
INSERT INTO Users (Email, PasswordHash, ...)
user.setPasswordHash(rs.getString("PasswordHash"));

// MỚI:
INSERT INTO Users (Email, Password, ...)
user.setPassword(rs.getString("Password"));
```

### 4. PasswordUtil.java
```java
// CŨ (đã xóa):
return DigestUtils.sha256Hex(password); // SHA-256 hash

// MỚI:
return password; // Plain text, không mã hóa
```

## ⚠️ CẢNH BÁO BẢO MẬT

**Dự án này sử dụng plain text password - CHỈ DÙNG CHO HỌC TẬP/DEMO:**
- ❌ Passwords được lưu trực tiếp trong database (không mã hóa)
- ❌ Bất kỳ ai có quyền truy cập database đều thấy được password
- ❌ KHÔNG BAO GIỜ sử dụng trong môi trường thực tế
- ✅ Trong production, PHẢI dùng bcrypt, Argon2, hoặc các thuật toán hash phù hợp

## 🔍 XÁC MINH DATABASE

Sau khi chạy schema.sql, kiểm tra:
```sql
-- Xem cấu trúc bảng Users
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Users';

-- Kết quả phải có:
-- Password | nvarchar (KHÔNG phải PasswordHash)

-- Xem admin user
SELECT UserID, Email, Password, Role 
FROM Users 
WHERE Role = 'ADMIN';

-- Kết quả phải là:
-- Email: admin@vaccination.com
-- Password: Admin@123 (plain text)
```

## 📁 FILES LIÊN QUAN

- `database/DROP_AND_RECREATE.sql` - Script xóa database
- `database/schema.sql` - Script tạo database mới
- `src/main/java/com/vaccination/model/User.java` - Model đã cập nhật
- `src/main/java/com/vaccination/dao/UserDAO.java` - DAO đã cập nhật
- `src/main/java/com/vaccination/util/PasswordUtil.java` - Không hash nữa

---

**Last Updated:** 2025-10-13
