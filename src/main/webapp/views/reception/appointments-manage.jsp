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
    <title>Reception • Manage Payments</title>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%=ctx%>/css/dashboard.css">
    <style>
        .card-ghost{border:1px solid rgba(2,6,23,.06); box-shadow:0 6px 18px rgba(2,6,23,.06); border-radius:16px}
        .table tbody tr:hover{background:rgba(59,130,246,.06)}
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
                <li class="sidebar-menu-item"><a href="<%=ctx%>/reception/appointmentsManage" class="sidebar-menu-link active">
                    <i class="bi bi-cash-coin"></i><span>Thanh toán</span></a></li>
            </ul>
        </aside>

        <main class="dashboard-main">
            <div class="page-header">
                <h1 class="page-title">Quản lý thanh toán</h1>
                <p class="page-subtitle">Các cuộc hẹn đã xác nhận</p>
            </div>

            <div class="card card-ghost mt-3">
                <div class="card-header">
                    <strong>Appointments Pending Payment</strong>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th style="width:80px">ID</th>
                                <th>Trẻ</th>
                                <th>Vaccine</th>
                                <th>Ngày</th>
                                <th>Giờ</th>
                                <th>Trạng thái</th>
                                <th>Thanh toán</th>
                                <th style="width:260px">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if (appointments != null && !appointments.isEmpty()) {
                                    for (Appointment app : appointments) {
                            %>
                            <tr>
                                <td><%= app.getAppointmentId() %></td>
                                <td><%= app.getChildName()!=null ? app.getChildName() : app.getChildId() %></td>
                                <td><%= app.getVaccineName()!=null ? app.getVaccineName() : app.getVaccineId() %></td>
                                <td><%= app.getAppointmentDate() %></td>
                                <td><%= app.getAppointmentTime()!=null ? app.getAppointmentTime() : "-" %></td>
                                <td><span class="badge bg-secondary"><%= app.getStatus() %></span></td>
                                <td><span class="badge bg-light text-dark"><%= app.getPaymentStatus() %></span></td>
                                <td class="d-flex gap-1 flex-wrap">
                                    <!-- Mark as paid -->
                                    <form action="<%=ctx%>/reception/completePayment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-success"
                                                <%= "PAID".equalsIgnoreCase(app.getPaymentStatus()) ? "disabled" : "" %>>
                                            <i class="bi bi-cash"></i> Mark as Paid
                                        </button>
                                    </form>

                                    <!-- Mark as unpaid -->
                                    <form action="<%=ctx%>/reception/cancelPayment" method="post" class="d-inline">
                                        <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-warning"
                                                <%= "UNPAID".equalsIgnoreCase(app.getPaymentStatus()) ? "disabled" : "" %>>
                                            <i class="bi bi-cash-stack"></i> Mark as Unpaid
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">No pending payments found.</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer text-end">
                    <a href="<%=ctx%>/reception/appointments-list" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
