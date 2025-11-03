<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Quản trị hệ thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css"><%-- CSS dùng chung --%>
    <style>
        /* ====== Reset nhỏ & tone màu chữ ====== */
        body{color:#0f172a;background:#f5f7fb;}
        .text-muted{color:#6b7280!important}

        /* ====== Card khung nội dung ====== */
        .content-card{border:1px solid #e5e7eb;border-radius:14px;background:#fff;box-shadow:0 6px 18px rgba(2,6,23,.04);margin-bottom:18px}
        .content-card-header{padding:14px 18px;border-bottom:1px solid #eef2f7;background:#f9fafb}
        .content-card-title{margin:0;font-weight:700;color:#0f172a;font-size:1.05rem}
        .content-card-sub{margin:0;font-size:.875rem;color:#6b7280}
        .content-card-body{padding:18px}

        /* ====== KPI grid ====== */
        .kpi-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px}
        @media (max-width: 1200px){.kpi-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
        @media (max-width: 576px){.kpi-grid{grid-template-columns:1fr}}

        .kpi-card{border:1px solid #e5e7eb;border-radius:12px;padding:16px;background:#fff}
        .kpi-title{display:flex;align-items:center;gap:8px;font-weight:700;color:#1f2937;margin-bottom:6px;font-size:.95rem}
        .kpi-value{font-size:1.75rem;font-weight:800;color:#0f172a;margin:0;line-height:1.15}
        .kpi-sub{font-size:.8rem;color:#6b7280;margin-top:4px}

        /* ====== Badge tone ====== */
        .badge-pill{border-radius:9999px;padding:.35rem .6rem;font-weight:600;font-size:.75rem}
        .badge-green{background:rgba(34,197,94,.15);color:#16a34a}
        .badge-amber{background:rgba(245,158,11,.15);color:#b45309}
        .badge-blue{background:rgba(59,130,246,.15);color:#2563eb}
        .badge-red{background:rgba(239,68,68,.15);color:#dc2626}

        /* ====== Bảng ====== */
        .table thead th{color:#334155;font-weight:700}
        .table td,.table th{vertical-align:middle}
        .table-hover tbody tr:hover{background-color:#f5f7fb}
        .table-wrapper{overflow:auto}

        /* ====== Page header (không animation) ====== */
        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}
        .page-title{margin:0;color:#0f172a;font-weight:800;font-size:1.25rem}
        .page-subtitle{margin:4px 0 0 0;font-size:.9rem;color:#6b7280}

        /* Giữ nhẹ nhàng: bỏ transform/scale */
        .table tbody tr{cursor:default}
    </style>
</head>
<body>

<%-- NAVBAR giữ nguyên --%>
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

        <%-- SIDEBAR giữ nguyên --%>
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-menu-link">
                        <i class="bi bi-speedometer2"></i><span>Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-menu-link">
                        <i class="bi bi-people"></i><span>Tài khoản</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN -->
        <main class="dashboard-main">

            <!-- HEADER -->
            <div class="page-header">
                <div>
                    <h3 class="page-title">Dashboard</h3>
                    <p class="page-subtitle">Tổng quan hệ thống & hoạt động người dùng</p>
                </div>
            </div>

            <!-- ===== KHỐI TỔNG QUAN (KPI) đặt trong CARD ===== -->
            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title"><i class="bi bi-grid-1x2"></i> Tổng quan</h5>
                    <p class="content-card-sub">Số liệu chính của hệ thống</p>
                </div>
                <div class="content-card-body">
                    <c:set var="totalUsers" value="0" />
                    <c:forEach var="e" items="${usersByRole}">
                        <c:set var="totalUsers" value="${totalUsers + e.value}" />
                    </c:forEach>

                    <c:set var="activeCount" value="0"/>
                    <c:set var="inactiveCount" value="0"/>
                    <c:forEach var="e" items="${activeInactive}">
                        <c:choose>
                            <c:when test="${fn:toLowerCase(e.key) == 'active'}">
                                <c:set var="activeCount" value="${e.value}"/>
                            </c:when>
                            <c:when test="${fn:toLowerCase(e.key) == 'inactive'}">
                                <c:set var="inactiveCount" value="${e.value}"/>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <div class="kpi-grid">
                        <div class="kpi-card">
                            <div class="kpi-title"><i class="bi bi-people-fill"></i> Tổng người dùng</div>
                            <p class="kpi-value">${totalUsers}</p>
                            <div class="kpi-sub">Tổng hợp theo vai trò</div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-title"><i class="bi bi-person-plus-fill"></i> Người dùng mới (tháng)</div>
                            <p class="kpi-value">${newUsers}</p>
                            <div class="kpi-sub">Đăng ký mới trong tháng hiện tại</div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-title"><i class="bi bi-person-check-fill"></i> Đang hoạt động</div>
                            <p class="kpi-value">${activeCount}</p>
                            <div class="kpi-sub"><span class="badge badge-pill badge-green">Active</span></div>
                        </div>
                        <div class="kpi-card">
                            <div class="kpi-title"><i class="bi bi-person-dash-fill"></i> Bị vô hiệu</div>
                            <p class="kpi-value">${inactiveCount}</p>
                            <div class="kpi-sub"><span class="badge badge-pill badge-amber">Inactive</span></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== USERS BY ROLE ===== -->
            <div class="content-card">
                <div class="content-card-header d-flex align-items-center justify-content-between">
                    <h5 class="content-card-title mb-0"><i class="bi bi-shield-check"></i> Người dùng theo vai trò</h5>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-sliders"></i> Quản lý tài khoản
                    </a>
                </div>
                <div class="content-card-body">
                    <div class="table-wrapper">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width:60%">Vai trò</th>
                                <th style="width:40%">Số lượng</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="entry" items="${usersByRole}">
                                <tr>
                                    <td>
                    <span class="badge badge-pill badge-blue">
                      <i class="bi bi-person-badge"></i>
                      <strong class="ms-1">${entry.key}</strong>
                    </span>
                                    </td>
                                    <td><strong>${entry.value}</strong></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== ACTIVE / INACTIVE ===== -->
            <div class="content-card">
                <div class="content-card-header">
                    <h5 class="content-card-title"><i class="bi bi-activity"></i> Trạng thái tài khoản</h5>
                </div>
                <div class="content-card-body">
                    <div class="table-wrapper">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width:60%">Trạng thái</th>
                                <th style="width:40%">Số lượng</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="entry" items="${activeInactive}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${fn:toLowerCase(entry.key) == 'active'}">
                                                <span class="badge badge-pill badge-green"><i class="bi bi-check-circle-fill"></i> Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pill badge-amber"><i class="bi bi-x-circle-fill"></i> Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${entry.value}</strong></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== RECENT LOGINS ===== -->
            <div class="content-card">
                <div class="content-card-header d-flex align-items-center justify-content-between">
                    <div>
                        <h5 class="content-card-title mb-0"><i class="bi bi-clock-history"></i> Đăng nhập gần đây</h5>
                        <p class="content-card-sub mb-0">Hiển thị 10 bản ghi mới nhất</p>
                    </div>
                </div>
                <div class="content-card-body">
                    <div class="table-wrapper">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width:15%">User ID</th>
                                <th style="width:45%">Họ tên</th>
                                <th style="width:40%">Lần đăng nhập cuối</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="login" items="${recentLogins}">
                                <tr>
                                    <td><code>${login.UserID}</code></td>
                                    <td><i class="bi bi-person-circle me-1"></i>${login.FullName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${login.LastLogin != null}">
                                                <fmt:formatDate value="${login.LastLogin}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Fix case đóng modal còn backdrop
    document.addEventListener('hidden.bs.modal', function () {
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
        if (document.querySelectorAll('.modal.show').length === 0) {
            document.body.classList.remove('modal-open');
            document.body.style.removeProperty('padding-right');
            document.body.style.removeProperty('overflow');
        }
    });
</script>
</body>
</html>
