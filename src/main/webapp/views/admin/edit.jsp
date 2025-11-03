<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Quản trị hệ thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .section-card{background:#fff;border:1px solid #e5e7eb;border-radius:16px;box-shadow:0 4px 14px rgba(2,6,23,0.04)}
        .section-header{padding:16px 18px;border-bottom:1px solid #eef2f7}
        .section-title{margin:0;font-size:18px;font-weight:700;color:#0f172a}
        .form-label{font-weight:600}
    </style>
</head>
<body>

<nav class="dashboard-navbar">
    <div class="dashboard-container">
        <div style="display:flex;justify-content:space-between;align-items:center;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand-custom">
                <i class="bi bi-shield-lock-fill"></i>
                <span>Vaccine For Kids - Admin</span>
            </a>
            <div style="display:flex;align-items:center;gap:.75rem;">
                <div class="navbar-user-info">
                    <i class="bi bi-person-circle"></i>
                    <span>${sessionScope.userName}</span>
                    <span class="badge text-bg-danger ms-2">ADMIN</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR (Admin) -->
        <aside class="sidebar slide-in-left">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-menu-link">
                        <i class="bi bi-speedometer2"></i><span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-menu-link active">
                        <i class="bi bi-people"></i><span>Tài khoản</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN -->
        <main class="dashboard-main">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Edit User</h1>
                    <p class="page-subtitle">Cập nhật thông tin người dùng</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
            </c:if>

            <div class="section-card mt-3">
                <div class="section-header"><h2 class="section-title">Thông tin cơ bản</h2></div>
                <div class="p-3">
                    <!-- Giữ nguyên action/field như bạn đang dùng -->
                    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post" class="row g-3">
                        <input type="hidden" name="id" value="${user.UserID}">

                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <input name="fullName" value="${user.FullName}" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Phone</label>
                            <input name="phone" value="${user.PhoneNumber}" class="form-control">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Role</label>
                            <select name="role" class="form-select">
                                <option value="ADMIN" <c:if test="${user.Role == 'ADMIN'}">selected</c:if>>ADMIN</option>
                                <option value="RECEPTION" <c:if test="${user.Role == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                                <option value="MEDICAL" <c:if test="${user.Role == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                                <option value="PARENT" <c:if test="${user.Role == 'PARENT'}">selected</c:if>>PARENT</option>
                            </select>
                        </div>

                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Update
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
