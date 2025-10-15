# HUONG DAN CAP NHAT DATABASE VOI LICH TCMR CHINH XAC

## ⚠️ QUAN TRONG: DATABASE HIEN TAI CHUA DUNG LICH TCMR!

Database cu co lich tiem KHONG CHINH XAC. Vi du:
- ❌ Bai liet UONG o 2,3,4 thang (SAI!)
- ❌ VNNB mui 2 o 12 thang (SAI!)
- ❌ Thieu 7 tuoi (84 thang): Td

## ✅ DATABASE MOI - LICH TCMR CHINH XAC

File moi: `database/schema_tcmr_fixed.sql`

### Lich tiem dung theo TCMR:

**0-24 gio sau sinh:**
- Viem gan B (mui so sinh)

**Trong 1 thang dau:**
- Lao (BCG)

**2 thang tuoi:**
- 5 trong 1 (mui 1)
- Rota (lieu 1) - dich vu
- Phe cau (mui 1) - dich vu

**3 thang tuoi:**
- 5 trong 1 (mui 2)
- Rota (lieu 2) - dich vu

**4 thang tuoi:**
- 5 trong 1 (mui 3)
- Phe cau (mui 2) - dich vu

**5 thang tuoi:**
- Bai liet IPV (TIEM, khong uong!)

**6 thang tuoi:**
- Phe cau (mui 3) - dich vu
- Cum (hang nam) - dich vu

**9 thang tuoi:**
- Soi (mui 1)

**12 thang tuoi:**
- Viem nao Nhat Ban (mui 1)
- Phe cau (mui nhac lai) - dich vu
- Thuy dau (mui 1) - dich vu

**12.5 thang (12 thang + 1-2 tuan):**
- Viem nao Nhat Ban (mui 2)

**18 thang tuoi:**
- 5 trong 1 (mui nhac lai)
- Soi-Rubella MR (mui 2)
- Thuy dau (mui 2) - dich vu

**24 thang tuoi (2 tuoi):**
- Viem nao Nhat Ban (mui 3)

**7 tuoi (84 thang - lop 2):**
- Bach hau - Uon van giam lieu (Td)

## 📋 CACH CAP NHAT:

### Buoc 1: Mo SQL Server Management Studio hoac Azure Data Studio

### Buoc 2: Chay file SQL moi
```
database/schema_tcmr_fixed.sql
```

File nay se:
1. ✅ Xoa database cu
2. ✅ Tao database moi voi lich TCMR chinh xac
3. ✅ Them tat ca vaccines (mien phi + tra phi)
4. ✅ Them vaccination schedule template dung
5. ✅ Them sample data (admin, centers, staff)

### Buoc 3: Restart server (neu chua)

Server se tu dong compile va chay voi database moi.

## 🎯 THAY DOI CHINH:

### 1. Database Schema
- ✅ `AgeInMonths` la DECIMAL(5,2) - support 0.5, 12.5...
- ✅ Them cot `CanCombineWith` - ghi chu vaccines co the tiem cung ngay

### 2. Auto-Schedule Logic
- ✅ Tao TAT CA appointments theo lich TCMR (khong chi tuoi hien tai)
- ✅ Tinh ngay tiem = DOB + AgeInMonths (support decimal)
- ✅ Staggered times: Vaccines cung ngay cach nhau 30 phut

### 3. Recommended Vaccines UI
- ✅ Hien thi vaccines tu tuoi hien tai tro di
- ✅ Phan biet: Da dat lich / Chua dat lich / Tra phi

## 🧪 TEST SAU KHI CAP NHAT:

1. **Them be moi** (vi du: be 2 thang tuoi)
2. **Kiem tra:** He thong tu dong tao appointments cho TAT CA vaccines mien phi:
   - 0 gio: Viem gan B
   - 0.5 thang: BCG
   - 2 thang: 5 trong 1 mui 1
   - 3 thang: 5 trong 1 mui 2
   - 4 thang: 5 trong 1 mui 3
   - 5 thang: Bai liet IPV
   - 9 thang: Soi
   - 12 thang: VNNB mui 1
   - 12.5 thang: VNNB mui 2
   - 18 thang: 5 trong 1 nhac lai + MR
   - 24 thang: VNNB mui 3
   - 84 thang: Td

3. **Kiem tra thoi gian:** Vaccines cung ngay phai co thoi gian khac nhau (9:00, 9:30, 10:00...)

## ⚠️ LUU Y:

- ❗ Chay file SQL nay se **XOA TAT CA** data cu
- ❗ Admin mac dinh: admin@vaccination.com / Admin@123
- ❗ Password van la PLAIN TEXT (khong hash)
- ❗ Tieng Viet KHONG DAU trong database

## 📞 HO TRO:

Neu gap loi, kiem tra:
1. SQL Server dang chay
2. Credentials dung: dodt / 123456789
3. Port 1433 khong bi block
4. File SQL chay het (khong co error)
