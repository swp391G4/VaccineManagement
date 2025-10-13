<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .status-badge {
            padding: 0.35rem 0.65rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .status-PENDING { background-color: #ffc107; color: #000; }
        .status-CONFIRMED { background-color: #198754; color: #fff; }
        .status-COMPLETED { background-color: #0dcaf0; color: #000; }
        .status-CANCELLED { background-color: #dc3545; color: #fff; }
        .status-REJECTED { background-color: #dc3545; color: #fff; }
        
        .payment-PAID { color: #198754; font-weight: 500; }
        .payment-UNPAID { color: #dc3545; font-weight: 500; }
        .payment-PENDING { color: #ffc107; font-weight: 500; }
        
        .appointment-card {
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }
        .appointment-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .appointment-card.PENDING { border-left-color: #ffc107; }
        .appointment-card.CONFIRMED { border-left-color: #198754; }
        .appointment-card.COMPLETED { border-left-color: #0dcaf0; }
        .appointment-card.CANCELLED { border-left-color: #dc3545; }
        
        .filter-tabs .nav-link {
            color: #6c757d;
            font-weight: 500;
        }
        .filter-tabs .nav-link.active {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
        }
        
        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/parent/dashboard">
                <i class="bi bi-heart-pulse"></i> Vaccination System
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="navbar-text text-white me-3">
                            <i class="bi bi-person-circle"></i> ${sessionScope.userName}
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">My Appointments</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-calendar-check"></i> My Appointments</h2>
            <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-primary">
                <i class="bi bi-calendar-plus"></i> Book New Appointment
            </a>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <ul class="nav nav-tabs filter-tabs mb-4" id="statusTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" 
                        type="button" role="tab" onclick="filterAppointments('ALL')">
                    All
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" 
                        type="button" role="tab" onclick="filterAppointments('PENDING')">
                    Pending
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" 
                        type="button" role="tab" onclick="filterAppointments('CONFIRMED')">
                    Confirmed
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" 
                        type="button" role="tab" onclick="filterAppointments('COMPLETED')">
                    Completed
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" 
                        type="button" role="tab" onclick="filterAppointments('CANCELLED')">
                    Cancelled
                </button>
            </li>
        </ul>

        <c:choose>
            <c:when test="${empty appointments}">
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-calendar-x" style="font-size: 4rem; color: #6c757d;"></i>
                        <h4 class="mt-3 mb-2">No Appointments Found</h4>
                        <p class="text-muted mb-4">You haven't booked any appointments yet.</p>
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-primary">
                            <i class="bi bi-calendar-plus"></i> Book Your First Appointment
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-none d-md-block">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle" id="appointmentsTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Child Name</th>
                                    <th>Vaccine Name</th>
                                    <th>Center Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Payment Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${appointments}" var="appointment">
                                    <tr class="appointment-row" data-status="${appointment.status}">
                                        <td>
                                            <i class="bi bi-person-fill text-primary"></i> 
                                            ${appointment.child.fullName}
                                        </td>
                                        <td>
                                            <i class="bi bi-shield-fill-check text-success"></i> 
                                            ${appointment.vaccine.vaccineName}
                                        </td>
                                        <td>
                                            <i class="bi bi-hospital"></i> 
                                            ${appointment.center.centerName}
                                        </td>
                                        <td>
                                            <i class="bi bi-calendar3"></i> 
                                            ${appointment.appointmentDate}
                                        </td>
                                        <td>
                                            <i class="bi bi-clock"></i> 
                                            ${appointment.appointmentTime}
                                        </td>
                                        <td>
                                            <span class="status-badge status-${appointment.status}">
                                                ${appointment.status}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="payment-${appointment.paymentStatus}">
                                                <i class="bi ${appointment.paymentStatus == 'PAID' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                ${appointment.paymentStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/parent/appointments/${appointment.appointmentId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye"></i> View Details
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="d-md-none">
                    <c:forEach items="${appointments}" var="appointment">
                        <div class="card appointment-card ${appointment.status} mb-3" data-status="${appointment.status}">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h5 class="card-title mb-0">
                                        <i class="bi bi-person-fill text-primary"></i> ${appointment.child.fullName}
                                    </h5>
                                    <span class="status-badge status-${appointment.status}">
                                        ${appointment.status}
                                    </span>
                                </div>
                                
                                <p class="mb-2">
                                    <strong><i class="bi bi-shield-fill-check text-success"></i> Vaccine:</strong> 
                                    ${appointment.vaccine.vaccineName}
                                </p>
                                <p class="mb-2">
                                    <strong><i class="bi bi-hospital"></i> Center:</strong> 
                                    ${appointment.center.centerName}
                                </p>
                                <p class="mb-2">
                                    <strong><i class="bi bi-calendar3"></i> Date:</strong> 
                                    ${appointment.appointmentDate} at ${appointment.appointmentTime}
                                </p>
                                <p class="mb-3">
                                    <strong>Payment:</strong> 
                                    <span class="payment-${appointment.paymentStatus}">
                                        <i class="bi ${appointment.paymentStatus == 'PAID' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                        ${appointment.paymentStatus}
                                    </span>
                                </p>
                                
                                <a href="${pageContext.request.contextPath}/parent/appointments/${appointment.appointmentId}" 
                                   class="btn btn-sm btn-primary w-100">
                                    <i class="bi bi-eye"></i> View Details
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterAppointments(status) {
            const rows = document.querySelectorAll('.appointment-row');
            const cards = document.querySelectorAll('.appointment-card');
            
            if (status === 'ALL') {
                rows.forEach(row => row.style.display = '');
                cards.forEach(card => card.style.display = '');
            } else {
                rows.forEach(row => {
                    if (row.dataset.status === status) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
                
                cards.forEach(card => {
                    if (card.dataset.status === status) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
        }
    </script>
</body>
</html>
