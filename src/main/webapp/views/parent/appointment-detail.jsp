<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-size: 1rem;
            font-weight: 600;
            display: inline-block;
        }
        .status-PENDING { background-color: #ffc107; color: #000; }
        .status-CONFIRMED { background-color: #198754; color: #fff; }
        .status-COMPLETED { background-color: #0dcaf0; color: #000; }
        .status-CANCELLED { background-color: #dc3545; color: #fff; }
        .status-REJECTED { background-color: #dc3545; color: #fff; }
        
        .info-section {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            font-size: 1.1rem;
            color: #212529;
        }
        
        .section-icon {
            font-size: 1.5rem;
            margin-right: 0.5rem;
        }
        
        .payment-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #198754;
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
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/appointments">Appointments</a></li>
                <li class="breadcrumb-item active" aria-current="page">Appointment Details</li>
            </ol>
        </nav>

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

        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="bi bi-calendar-check"></i> Appointment Details
                    </h4>
                    <div>
                        <span class="badge bg-light text-dark">ID: #${appointment.appointmentId}</span>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="text-center mb-4">
                    <span class="status-badge status-${appointment.status}">
                        ${appointment.status}
                    </span>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">
                                    <i class="bi bi-person-fill section-icon text-primary"></i>
                                    Child Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Full Name</div>
                                    <div class="info-value">${appointment.child.fullName}</div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Date of Birth</div>
                                    <div class="info-value">
                                        <i class="bi bi-calendar3"></i> ${appointment.child.dateOfBirth}
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value">
                                        <i class="bi bi-gender-ambiguous"></i> ${appointment.child.gender}
                                    </div>
                                </div>
                                <c:if test="${not empty appointment.child.bloodType}">
                                    <div class="mb-0">
                                        <div class="info-label">Blood Type</div>
                                        <div class="info-value">
                                            <i class="bi bi-droplet-fill text-danger"></i> ${appointment.child.bloodType}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">
                                    <i class="bi bi-shield-fill-check section-icon text-success"></i>
                                    Vaccine Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Vaccine Name</div>
                                    <div class="info-value">${appointment.vaccine.vaccineName}</div>
                                </div>
                                <c:if test="${not empty appointment.vaccine.manufacturer}">
                                    <div class="mb-3">
                                        <div class="info-label">Manufacturer</div>
                                        <div class="info-value">
                                            <i class="bi bi-building"></i> ${appointment.vaccine.manufacturer}
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty appointment.vaccine.diseasesPrevented}">
                                    <div class="mb-3">
                                        <div class="info-label">Diseases Prevented</div>
                                        <div class="info-value">${appointment.vaccine.diseasesPrevented}</div>
                                    </div>
                                </c:if>
                                <div class="mb-0">
                                    <div class="info-label">Price</div>
                                    <div class="payment-amount">
                                        <fmt:formatNumber value="${appointment.vaccine.price}" type="currency" currencySymbol="$"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">
                                    <i class="bi bi-hospital section-icon text-info"></i>
                                    Center Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Center Name</div>
                                    <div class="info-value">${appointment.center.centerName}</div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Address</div>
                                    <div class="info-value">
                                        <i class="bi bi-geo-alt-fill"></i> 
                                        ${appointment.center.address}
                                        <c:if test="${not empty appointment.center.city}">
                                            , ${appointment.center.city}
                                        </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty appointment.center.phoneNumber}">
                                    <div class="mb-3">
                                        <div class="info-label">Phone Number</div>
                                        <div class="info-value">
                                            <i class="bi bi-telephone-fill"></i> 
                                            <a href="tel:${appointment.center.phoneNumber}">${appointment.center.phoneNumber}</a>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty appointment.center.operatingHours}">
                                    <div class="mb-0">
                                        <div class="info-label">Operating Hours</div>
                                        <div class="info-value">
                                            <i class="bi bi-clock-fill"></i> ${appointment.center.operatingHours}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">
                                    <i class="bi bi-calendar-event section-icon text-warning"></i>
                                    Appointment Schedule
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Date</div>
                                    <div class="info-value">
                                        <i class="bi bi-calendar3"></i> ${appointment.appointmentDate}
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Time</div>
                                    <div class="info-value">
                                        <i class="bi bi-clock"></i> ${appointment.appointmentTime}
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Payment Status</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${appointment.paymentStatus == 'PAID'}">
                                                <span class="badge bg-success">
                                                    <i class="bi bi-check-circle-fill"></i> PAID
                                                </span>
                                            </c:when>
                                            <c:when test="${appointment.paymentStatus == 'PENDING'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-clock-fill"></i> PENDING
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">
                                                    <i class="bi bi-x-circle-fill"></i> UNPAID
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:if test="${not empty appointment.paymentAmount}">
                                    <div class="mb-0">
                                        <div class="info-label">Payment Amount</div>
                                        <div class="payment-amount">
                                            <fmt:formatNumber value="${appointment.paymentAmount}" type="currency" currencySymbol="$"/>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty appointment.notes}">
                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">
                                <i class="bi bi-journal-text section-icon"></i>
                                Notes
                            </h5>
                        </div>
                        <div class="card-body">
                            <p class="mb-0">${appointment.notes}</p>
                        </div>
                    </div>
                </c:if>

                <div class="card bg-light">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <small class="text-muted">
                                    <i class="bi bi-clock-history"></i> 
                                    Created: ${appointment.createdAt}
                                </small>
                            </div>
                            <c:if test="${not empty appointment.updatedAt}">
                                <div class="col-md-6 text-md-end">
                                    <small class="text-muted">
                                        <i class="bi bi-arrow-clockwise"></i> 
                                        Last Updated: ${appointment.updatedAt}
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4">
                    <a href="${pageContext.request.contextPath}/parent/appointments" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    
                    <c:if test="${appointment.status == 'PENDING'}">
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelModal">
                            <i class="bi bi-x-circle"></i> Cancel Appointment
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="cancelModalLabel">
                        <i class="bi bi-exclamation-triangle"></i> Cancel Appointment
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Are you sure you want to cancel this appointment?</p>
                    <p class="text-muted mb-0">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x"></i> No, Keep It
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/parent/appointments/${appointment.appointmentId}/cancel">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-check"></i> Yes, Cancel Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
