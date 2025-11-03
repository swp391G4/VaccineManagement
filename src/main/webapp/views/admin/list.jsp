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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css"><%-- dùng chung CSS --%>
    <style>
        .page-title{margin:0}
        .section-card{background:#fff;border:1px solid #e5e7eb;border-radius:16px;box-shadow:0 4px 14px rgba(2,6,23,0.04)}
        .section-header{display:flex;justify-content:space-between;align-items:center;padding:16px 18px;border-bottom:1px solid #eef2f7}
        .section-title{margin:0;font-size:18px;font-weight:700;color:#0f172a}
        .section-sub{margin:0;color:#64748b;font-size:12px}
        .table thead th{font-size:12px;color:#64748b;text-transform:uppercase;background:#f8fafc;border-bottom:1px solid #eef2f7}
        .table tbody tr{cursor:pointer;transition:all .15s ease}
        .table tbody tr:hover{background:rgba(59,130,246,.05)}
        .toolbar{display:flex;gap:.5rem;flex-wrap:wrap}
        .toolbar .form-select{min-width:190px}
        .badge-role{font-size:12px;border-radius:999px;padding:4px 8px;border:1px solid #e2e8f0;background:#f8fafc}
        .status-yes{background:#e6f9ee;color:#047857;border:1px solid #bbf7d0;border-radius:999px;padding:.2rem .5rem;font-size:.75rem}
        .status-no{background:#fff7ed;color:#9a3412;border:1px solid #fed7aa;border-radius:999px;padding:.2rem .5rem;font-size:.75rem}
        .pagination .page-link{border-radius:8px;margin:0 .15rem}
        .content-wrap{padding:18px}
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
                    <h1 class="page-title">Danh sách tài khoản</h1>
                    <p class="page-subtitle">Quản lý người dùng trong hệ thống</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Create New User
                    </a>
                </div>
            </div>

            <!-- Alerts giữ nguyên logic -->
            <c:if test="${not empty message}">
                <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> ${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> ${error}</div>
            </c:if>

            <div class="section-card mt-3">
                <div class="section-header">
                    <div>
                        <h2 class="section-title">Bảng người dùng</h2>
                        <p class="section-sub">Lọc theo vai trò để thu hẹp kết quả</p>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/users" method="get" class="toolbar">
                        <select name="role" class="form-select form-select-sm">
                            <option value="">All Roles</option>
                            <option value="ADMIN" <c:if test="${roleFilter == 'ADMIN'}">selected</c:if>>ADMIN</option>
                            <option value="RECEPTION" <c:if test="${roleFilter == 'RECEPTION'}">selected</c:if>>RECEPTION</option>
                            <option value="MEDICAL" <c:if test="${roleFilter == 'MEDICAL'}">selected</c:if>>MEDICAL</option>
                            <option value="PARENT" <c:if test="${roleFilter == 'PARENT'}">selected</c:if>>PARENT</option>
                        </select>
                        <button type="submit" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-filter-circle"></i> Filter
                        </button>
                    </form>
                </div>

                <div class="content-wrap">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
                                <th>Role</th><th>Active</th><th>Created At</th><th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.UserID}</td>
                                    <td>${user.FullName}</td>
                                    <td>${user.Email}</td>
                                    <td>${user.PhoneNumber}</td>
                                    <td><span class="badge-role">${user.Role}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.IsActive}">
                                                <span class="status-yes">Yes</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-no">No</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${user.CreatedAt}</td>
                                    <td>
                                        <div class="d-flex gap-1 flex-wrap">
                                            <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.UserID}" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye"></i> View
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.UserID}" class="btn btn-sm btn-outline-warning">
                                                <i class="bi bi-pencil"></i> Edit
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${user.UserID}">
                                                <input type="hidden" name="active" value="${!user.IsActive}">
                                                <button type="submit" class="btn btn-sm btn-${user.IsActive ? 'danger' : 'success'}">
                                                    <i class="bi bi-power"></i> ${user.IsActive ? 'Deactivate' : 'Activate'}
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/users/reset" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${user.UserID}">
                                                <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                    <i class="bi bi-arrow-counterclockwise"></i> Reset Password
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <nav class="mt-3">
                        <ul class="pagination">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}&role=${roleFilter}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
