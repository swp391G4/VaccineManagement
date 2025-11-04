<%@ page import="java.util.List" %>
<%@ page import="com.vaccination.model.Appointment" %>
<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    String ctx = request.getContextPath();
%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Noto+Sans:wght@400;600;700&display=swap" rel="stylesheet">

<style>
    html, body { font-family: "Inter","Noto Sans",system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue","Noto Sans Vietnamese","Liberation Sans",Arial,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol",sans-serif; }
</style>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Reception • Appointments</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%=ctx%>/css/dashboard.css"><!-- dùng chung layout -->
    <style>
        .page-title{margin:0}
        .table tbody tr{transition:all .15s ease}
        .table tbody tr:hover{background:rgba(59,130,246,.06)}
        .badge-soft{background:rgba(99,102,241,.12); color:#4f46e5; border:1px solid rgba(99,102,241,.2)}
        .card-ghost{border:1px solid rgba(2,6,23,.06); box-shadow:0 6px 18px rgba(2,6,23,.06); border-radius:16px}
        .toolbar {display:flex; justify-content:space-between; align-items:center; gap:1rem}
        .sidebar .sidebar-menu-link.active{background:rgba(59,130,246,.08); border-color:rgba(59,130,246,.25); color:#2563eb}
        .searchbox{max-width:260px}
    </style>
</head>
<body>
<!-- NAV -->
<nav class="dashboard-navbar">
    <div class="dashboard-container">
        <div class="d-flex justify-content-between align-items-center">
            <a href="<%=ctx%>/reception/appointments-list" class="navbar-brand-custom">
                <i class="bi bi-heart-pulse"></i>
                <span>Vaccine For Kids - Reception</span>
            </a>
            <div class="d-flex align-items-center gap-2">
                <div class="navbar-user-info">
                    <i class="bi bi-person-circle"></i>
                    <span><%= session.getAttribute("userName") %></span>
                    <span class="badge text-bg-primary ms-2">RECEPTION</span>
                </div>
                <a href="<%=ctx%>/logout" class="btn-logout">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="dashboard-container">
    <div class="dashboard-row">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item">
                    <a href="<%=ctx%>/reception/appointments-list" class="sidebar-menu-link active">
                        <i class="bi bi-calendar2-check"></i><span>Cuộc hẹn</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="<%=ctx%>/reception/appointmentsManage" class="sidebar-menu-link">
                        <i class="bi bi-cash-coin"></i><span>Thanh toán</span>
                    </a>
                </li>
            </ul>
        </aside>

        <!-- MAIN -->
        <main class="dashboard-main">
            <div class="page-header">
                <div class="toolbar">
                    <div>
                        <h1 class="page-title">Danh sách cuộc hẹn</h1>
                        <p class="page-subtitle">Quản lý & thao tác lịch tiêm tại quầy tiếp đón</p>
                    </div>
                    <div class="input-group input-group-sm searchbox">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input class="form-control" placeholder="Tìm nhanh (trên trình duyệt)…"
                               oninput="filterTable(this.value)">
                    </div>
                </div>
            </div>

            <div class="card card-ghost mt-3">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-database-gear"></i>
                        <strong>Bảng dữ liệu</strong>
                    </div>
                    <a href="<%=ctx%>/reception/appointmentsManage" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-wallet2"></i> Quản lý thanh toán
                    </a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table id="apptTable" class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width:80px">ID</th>
                                <th>Trẻ</th>
                                <th>Vaccine</th>
                                <th>Ngày</th>
                                <th>Giờ</th>
                                <th>Trạng thái</th>
                                <th style="width:260px">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if (appointments != null && !appointments.isEmpty()) {
                                    for (Appointment app : appointments) {
                                        String status = app.getStatus() != null ? app.getStatus() : "";
                            %>
                            <tr>
                                <td><%= app.getAppointmentId() %></td>
                                <td><%= app.getChildName()!=null ? app.getChildName() : app.getChildId() %></td>
                                <td><%= app.getVaccineName()!=null ? app.getVaccineName() : app.getVaccineId() %></td>
                                <td><%= app.getAppointmentDate() %></td>
                                <td><%= app.getAppointmentTime()!=null ? app.getAppointmentTime() : "-" %></td>
                                <td>
                                    <span class="badge bg-secondary"><%= status %></span>
                                </td>
                                <td class="d-flex gap-1 flex-wrap">
                                    <a href="<%=ctx%>/reception/appointmentDetail?id=<%= app.getAppointmentId() %>"
                                       class="btn btn-sm btn-info"><i class="bi bi-eye"></i> Xem</a>

                                    <%
                                        String st = status.toUpperCase();
                                        if ("PENDING".equals(st)) {
                                    %>
                                    <form action="<%=ctx%>/reception/confirmAppointment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="bi bi-check2-circle"></i> Xác nhận
                                        </button>
                                    </form>
                                    <form action="<%=ctx%>/reception/cancelAppointment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="bi bi-x-circle"></i> Từ chối
                                        </button>
                                    </form>
                                    <%
                                    } else if ("CANCELLED".equals(st)) {
                                    %>
                                    <form action="<%=ctx%>/reception/confirmAppointment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="bi bi-check2-circle"></i> Xác nhận
                                        </button>
                                    </form>
                                    <%
                                    } else if ("CONFIRMED".equals(st)) {
                                    %>
                                    <form action="<%=ctx%>/reception/cancelAppointment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="bi bi-x-circle"></i> Từ chối
                                        </button>
                                    </form>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">Không có cuộc hẹn nào.</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    function filterTable(q){
        q = (q||'').toLowerCase();
        const rows = document.querySelectorAll('#apptTable tbody tr');
        rows.forEach(r=>{
            const hit = r.innerText.toLowerCase().includes(q);
            r.style.display = hit ? '' : 'none';
        });
    }
</script>
</body>
</html>
