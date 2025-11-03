<%@ page import="com.vaccination.model.Appointment" %>
<%
    Appointment app = (Appointment) request.getAttribute("appointment");
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
    <title>Reception • Appointment Detail</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%=ctx%>/css/dashboard.css">
    <style>
        .card-ghost{border:1px solid rgba(2,6,23,.06); box-shadow:0 6px 18px rgba(2,6,23,.06); border-radius:16px}
        .kv th{width:220px}
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
                <a href="<%=ctx%>/logout" class="btn-logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </div>
</nav>

<div class="dashboard-container">
    <div class="dashboard-row">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-menu-item"><a href="<%=ctx%>/reception/appointments-list" class="sidebar-menu-link">
                    <i class="bi bi-calendar2-check"></i><span>Cuộc hẹn</span></a></li>
                <li class="sidebar-menu-item"><a href="<%=ctx%>/reception/appointmentsManage" class="sidebar-menu-link">
                    <i class="bi bi-cash-coin"></i><span>Thanh toán</span></a></li>
            </ul>
        </aside>

        <main class="dashboard-main">
            <div class="page-header">
                <h1 class="page-title">Chi tiết cuộc hẹn</h1>
                <p class="page-subtitle">Xem thông tin và ghi chú</p>
            </div>

            <div class="card card-ghost mt-3">
                <div class="card-body">
                    <%
                        if (app == null) {
                    %>
                    <div class="alert alert-danger mb-0">Appointment not found.</div>
                    <%
                    } else {
                        String status = app.getStatus() != null ? app.getStatus().toUpperCase() : "";
                    %>
                    <table class="table kv">
                        <tr><th>ID</th><td><%= app.getAppointmentId() %></td></tr>
                        <tr><th>Child</th><td><%= app.getChildName()!=null ? app.getChildName() : app.getChildId() %></td></tr>
                        <tr><th>Vaccine</th><td><%= app.getVaccineName()!=null ? app.getVaccineName() : app.getVaccineId() %></td></tr>
                        <tr><th>Date</th><td><%= app.getAppointmentDate() %></td></tr>
                        <tr><th>Time</th><td><%= app.getAppointmentTime()!=null ? app.getAppointmentTime() : "-" %></td></tr>
                        <tr><th>Status</th><td><span class="badge bg-secondary"><%= app.getStatus() %></span></td></tr>
                        <tr><th>Payment Status</th><td><span class="badge bg-light text-dark"><%= app.getPaymentStatus() %></span></td></tr>
                        <tr>
                            <th>Notes</th>
                            <td>
                                <form action="<%=ctx%>/reception/updateNote" method="post" class="d-flex gap-2">
                                    <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                    <textarea name="notes" class="form-control" rows="2" style="max-width:680px"><%= app.getNotes()!=null?app.getNotes():"" %></textarea>
                                    <button type="submit" class="btn btn-primary"><i class="bi bi-save2"></i> Lưu</button>
                                </form>
                            </td>
                        </tr>
                    </table>

                    <div class="d-flex gap-2">
                        <% if ("PENDING".equals(status)) { %>
                        <form action="<%=ctx%>/reception/confirmAppointment" method="post" class="d-inline">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-success"><i class="bi bi-check2-circle"></i> Confirm</button>
                        </form>
                        <form action="<%=ctx%>/reception/cancelAppointment" method="post" class="d-inline">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle"></i> Reject</button>
                        </form>
                        <% } else if ("CANCELLED".equals(status)) { %>
                        <form action="<%=ctx%>/reception/confirmAppointment" method="post" class="d-inline">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-success"><i class="bi bi-check2-circle"></i> Confirm</button>
                        </form>
                        <% } else if ("CONFIRMED".equals(status)) { %>
                        <form action="<%=ctx%>/reception/cancelAppointment" method="post" class="d-inline">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle"></i> Reject</button>
                        </form>
                        <% } %>
                        <a href="<%=ctx%>/reception/appointments-list" class="btn btn-secondary ms-auto"><i class="bi bi-arrow-left"></i> Quay lại</a>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
