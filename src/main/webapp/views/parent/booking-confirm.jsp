<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Appointment - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .summary-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .summary-section h6 {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .info-value {
            color: #212529;
        }
        .total-cost {
            background-color: #d1e7dd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }
        .total-cost h4 {
            color: #198754;
            margin-bottom: 0;
        }
        .confirm-icon {
            font-size: 4rem;
            color: #0d6efd;
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

    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/booking/step1">Step 1</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/booking/step2?childId=${child.childId}&vaccineId=${vaccine.vaccineId}">Step 2</a></li>
                <li class="breadcrumb-item active" aria-current="page">Confirm Appointment</li>
            </ol>
        </nav>

        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="bi bi-check-circle"></i> Confirm Appointment Details
                </h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="text-center mb-4">
                    <i class="bi bi-clipboard-check confirm-icon"></i>
                    <h5 class="mt-3">Please review your appointment details</h5>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="summary-section">
                            <h6><i class="bi bi-person-fill"></i> Child Information</h6>
                            <div class="info-row">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">${child.fullName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">${child.dateOfBirth}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Gender:</span>
                                <span class="info-value">${child.gender}</span>
                            </div>
                            <c:if test="${not empty child.bloodType}">
                                <div class="info-row">
                                    <span class="info-label">Blood Type:</span>
                                    <span class="info-value">${child.bloodType}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty child.allergies}">
                                <div class="info-row">
                                    <span class="info-label">Allergies:</span>
                                    <span class="info-value text-danger">${child.allergies}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="summary-section">
                            <h6><i class="bi bi-shield-fill-check"></i> Vaccine Information</h6>
                            <div class="info-row">
                                <span class="info-label">Vaccine Name:</span>
                                <span class="info-value">${vaccine.vaccineName}</span>
                            </div>
                            <c:if test="${not empty vaccine.manufacturer}">
                                <div class="info-row">
                                    <span class="info-label">Manufacturer:</span>
                                    <span class="info-value">${vaccine.manufacturer}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty vaccine.diseasesPrevented}">
                                <div class="info-row">
                                    <span class="info-label">Prevents:</span>
                                    <span class="info-value">${vaccine.diseasesPrevented}</span>
                                </div>
                            </c:if>
                            <div class="info-row">
                                <span class="info-label">Price:</span>
                                <span class="info-value text-success fw-bold">
                                    <fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="summary-section">
                            <h6><i class="bi bi-hospital"></i> Vaccination Center</h6>
                            <div class="info-row">
                                <span class="info-label">Center Name:</span>
                                <span class="info-value">${center.centerName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Address:</span>
                                <span class="info-value">
                                    ${center.address}<c:if test="${not empty center.city}">, ${center.city}</c:if>
                                </span>
                            </div>
                            <c:if test="${not empty center.phoneNumber}">
                                <div class="info-row">
                                    <span class="info-label">Phone:</span>
                                    <span class="info-value">${center.phoneNumber}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty center.operatingHours}">
                                <div class="info-row">
                                    <span class="info-label">Hours:</span>
                                    <span class="info-value">${center.operatingHours}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="summary-section">
                            <h6><i class="bi bi-calendar-event"></i> Appointment Schedule</h6>
                            <div class="info-row">
                                <span class="info-label">Date:</span>
                                <span class="info-value fw-bold">${appointmentDate}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Time:</span>
                                <span class="info-value fw-bold">${appointmentTime}</span>
                            </div>
                        </div>

                        <div class="total-cost">
                            <p class="mb-2 text-muted">Total Cost</p>
                            <h4><fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/></h4>
                            <small class="text-muted">Payment will be processed after confirmation</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-info mt-4">
                    <i class="bi bi-info-circle"></i> 
                    <strong>Important:</strong> Please arrive 15 minutes before your appointment time. 
                    Bring your child's health records and any relevant medical documents.
                </div>

                <form method="post" action="${pageContext.request.contextPath}/parent/booking/create" id="confirmForm">
                    <input type="hidden" name="childId" value="${child.childId}">
                    <input type="hidden" name="vaccineId" value="${vaccine.vaccineId}">
                    <input type="hidden" name="centerId" value="${center.centerId}">
                    <input type="hidden" name="date" value="${appointmentDate}">
                    <input type="hidden" name="time" value="${appointmentTime}">

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/parent/booking/step2?childId=${child.childId}&vaccineId=${vaccine.vaccineId}" 
                           class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to Edit
                        </a>
                        <div>
                            <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-outline-secondary me-2">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-check-circle"></i> Confirm Appointment
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('confirmForm').addEventListener('submit', function(e) {
            if (!confirm('Are you sure you want to confirm this appointment?')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
