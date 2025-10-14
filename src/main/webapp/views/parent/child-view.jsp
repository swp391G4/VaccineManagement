<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Child Details - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
                            <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
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
        <div class="row">
            <div class="col-md-3">
                <div class="list-group">
                    <a href="${pageContext.request.contextPath}/parent/dashboard" class="list-group-item list-group-item-action">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/children" class="list-group-item list-group-item-action active">
                        <i class="bi bi-people"></i> My Children
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/booking/step1" class="list-group-item list-group-item-action">
                        <i class="bi bi-calendar-plus"></i> Book Appointment
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/appointments" class="list-group-item list-group-item-action">
                        <i class="bi bi-calendar-check"></i> My Appointments
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="list-group-item list-group-item-action">
                        <i class="bi bi-clipboard-pulse"></i> Vaccination History
                    </a>
                </div>
            </div>

            <div class="col-md-9">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/children">My Children</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${child.fullName}</li>
                    </ol>
                </nav>

                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="bi bi-person-badge"></i> Child Profile
                        </h4>
                        <div>
                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                               class="btn btn-light btn-sm">
                                <i class="bi bi-calendar-plus"></i> Book Appointment
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="text-muted small">Full Name</label>
                                <h5><i class="bi bi-person"></i> ${child.fullName}</h5>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="text-muted small">Date of Birth</label>
                                <h5><i class="bi bi-calendar"></i> ${child.dateOfBirth}</h5>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="text-muted small">Age</label>
                                <h5>
                                    <i class="bi bi-hourglass-split"></i> 
                                    <c:set var="ageMonths" value="${child.getAgeInMonths()}" />
                                    <c:set var="years" value="${ageMonths / 12}" />
                                    <c:set var="months" value="${ageMonths % 12}" />
                                    <c:choose>
                                        <c:when test="${ageMonths < 12}">
                                            ${ageMonths} months
                                        </c:when>
                                        <c:when test="${months == 0}">
                                            ${years} year${years > 1 ? 's' : ''}
                                        </c:when>
                                        <c:otherwise>
                                            ${years} year${years > 1 ? 's' : ''} ${months} month${months > 1 ? 's' : ''}
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="text-muted small">Gender</label>
                                <h5>
                                    <c:choose>
                                        <c:when test="${child.gender == 'Male'}">
                                            <i class="bi bi-gender-male text-primary"></i> Male
                                        </c:when>
                                        <c:when test="${child.gender == 'Female'}">
                                            <i class="bi bi-gender-female text-danger"></i> Female
                                        </c:when>
                                        <c:otherwise>
                                            ${child.gender}
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="text-muted small">Blood Type</label>
                                <h5>
                                    <i class="bi bi-droplet-fill text-danger"></i> 
                                    ${not empty child.bloodType ? child.bloodType : 'N/A'}
                                </h5>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="text-muted small">Weight</label>
                                <h5>
                                    <i class="bi bi-bar-chart"></i> 
                                    ${not empty child.weight ? child.weight : 'Not recorded'}${not empty child.weight ? ' kg' : ''}
                                </h5>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="text-muted small">Height</label>
                                <h5>
                                    <i class="bi bi-rulers"></i> 
                                    ${not empty child.height ? child.height : 'Not recorded'}${not empty child.height ? ' cm' : ''}
                                </h5>
                            </div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label class="text-muted small">Medical History</label>
                                <div class="alert alert-info mb-0">
                                    <i class="bi bi-file-medical"></i> 
                                    ${not empty child.medicalHistory ? child.medicalHistory : 'No medical history recorded'}
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label class="text-muted small">Allergies</label>
                                <div class="alert alert-warning mb-0">
                                    <i class="bi bi-exclamation-triangle"></i> 
                                    ${not empty child.allergies ? child.allergies : 'No known allergies'}
                                </div>
                            </div>
                        </div>

                        <hr>

                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/parent/children" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" 
                               class="btn btn-success">
                                <i class="bi bi-clipboard-pulse"></i> View Vaccination History
                            </a>
                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                               class="btn btn-primary">
                                <i class="bi bi-calendar-plus"></i> Book New Appointment
                            </a>
                        </div>
                    </div>
                    <div class="card-footer text-muted">
                        <small>
                            <i class="bi bi-clock"></i> Created: ${child.createdAt}
                            <c:if test="${not empty child.updatedAt}">
                                | Updated: ${child.updatedAt}
                            </c:if>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
