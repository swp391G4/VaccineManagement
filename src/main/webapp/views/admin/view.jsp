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
        .field-label{color:#64748b;font-size:12px}
        .field-value{font-weight:600}
        .badge-role{font-size:12px;border-radius:999px;padding:4px 8px;border:1px solid #e2e8f0;background:#f8fafc}
        .status-yes{background:#e6f9ee;color:#047857;border:1px solid #bbf7d0;border-radius:999px;padding:.2rem .5rem;font-size:.75rem}
        .status-no{background:#fff7ed;color:#9a3412;border:1px solid #fed7aa;border-radius:999px;padding:.2rem .5rem;font-size:.75rem}
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
                    <h1 class="page-title">User Detail</h1>
                    <p class="page-subtitle">Xem thông tin người dùng</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>

            <div class="section-card mt-3">
                <div class="section-header"><h2 class="section-title">Thông tin chung</h2></div>
                <div class="p-3">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="field-label">ID</div>
                            <div class="field-value">${user.UserID}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-label">Trạng thái</div>
                            <div>
                                <c:choose>
                                    <c:when test="${user.IsActive}">
                                        <span class="status-yes">Yes</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-no">No</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="field-label">Name</div>
                            <div class="field-value">${user.FullName}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-label">Email</div>
                            <div class="field-value">${user.Email}</div>
                        </div>

                        <div class="col-md-6">
                            <div class="field-label">Phone</div>
                            <div class="field-value">${user.PhoneNumber}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-label">Role</div>
                            <div class="field-value"><span class="badge-role">${user.Role}</span></div>
                        </div>

                        <div class="col-md-6">
                            <div class="field-label">Created At</div>
                            <div class="field-value">${user.CreatedAt}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-label">Last Login</div>
                            <div class="field-value">${user.LastLogin}</div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
