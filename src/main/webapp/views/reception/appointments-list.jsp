<%@ page import="java.util.List" %>
<%@ page import="com.vaccination.model.Appointment" %>
<%
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Appointments - Reception</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <h2>Appointment Management</h2>

    <div class="mb-3">
        <a href="<%= request.getContextPath() %>/reception/appointmentsManage" class="btn btn-primary">
            Manage Payments
        </a>
    </div>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Child ID</th>
                <th>Vaccine</th>
                <th>Date</th>
                <th>Time</th>
                <th>Status</th>
                <th>Actions</th>
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
                <td><%= app.getChildId() %></td>
                <td><%= app.getVaccineId() %></td>
                <td><%= app.getAppointmentDate() %></td>
                <td><%= app.getAppointmentTime() != null ? app.getAppointmentTime() : "-" %></td>
                <td><%= app.getStatus() %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/reception/appointmentDetail?id=<%= app.getAppointmentId() %>" 
                       class="btn btn-info btn-sm">View</a>

                    <% if ("PENDING".equals(status)) { %>
                        <form action="<%= request.getContextPath() %>/reception/confirmAppointment" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                        </form>
                        <form action="<%= request.getContextPath() %>/reception/cancelAppointment" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                        </form>

                    <% } else if ("CANCELLED".equals(status)) { %>
                        <form action="<%= request.getContextPath() %>/reception/confirmAppointment" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                        </form>

                    <% } else if ("CONFIRMED".equals(status)) { %>
                        <form action="<%= request.getContextPath() %>/reception/cancelAppointment" method="post" style="display:inline;">
                            <input type="hidden" name="appointmentId" value="<%= app.getAppointmentId() %>">
                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                        </form>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="7" class="text-center text-muted">No appointments found.</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
</body>
</html>
