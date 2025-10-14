<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Children - Vaccination System</title>
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="bi bi-people"></i> My Children</h2>
                    <a href="${pageContext.request.contextPath}/parent/children/add" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Add Child
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty children}">
                        <div class="card">
                            <div class="card-body text-center py-5">
                                <i class="bi bi-people" style="font-size: 4rem; color: #6c757d;"></i>
                                <h4 class="mt-3">No Children Added Yet</h4>
                                <p class="text-muted">Start by adding your child's profile to manage their vaccinations</p>
                                <a href="${pageContext.request.contextPath}/parent/children/add" class="btn btn-primary mt-2">
                                    <i class="bi bi-plus-circle"></i> Add Your First Child
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Full Name</th>
                                                <th>Date of Birth</th>
                                                <th>Age</th>
                                                <th>Gender</th>
                                                <th>Blood Type</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${children}" var="child" varStatus="status">
                                                <tr>
                                                    <td>${status.count}</td>
                                                    <td>
                                                        <strong>${child.fullName}</strong>
                                                    </td>
                                                    <td>${child.dateOfBirth}</td>
                                                    <td>
                                                        <c:set var="years" value="${child.ageYears}" />
                                                        <c:set var="months" value="${child.ageRemainingMonths}" />
                                                        <c:choose>
                                                            <c:when test="${child.ageInMonths < 12}">
                                                                ${child.ageInMonths} months
                                                            </c:when>
                                                            <c:when test="${months == 0}">
                                                                ${years} year${years > 1 ? 's' : ''}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${years} year${years > 1 ? 's' : ''} ${months} month${months > 1 ? 's' : ''}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${child.gender == 'Male'}">
                                                                <span class="badge bg-primary">
                                                                    <i class="bi bi-gender-male"></i> Male
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${child.gender == 'Female'}">
                                                                <span class="badge bg-danger">
                                                                    <i class="bi bi-gender-female"></i> Female
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${child.gender}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty child.bloodType}">
                                                                <span class="badge bg-info">${child.bloodType}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" 
                                                               class="btn btn-sm btn-outline-info" title="View Details">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/recommended-vaccines?childId=${child.childId}" 
                                                               class="btn btn-sm btn-outline-warning" title="Recommended Vaccines">
                                                                <i class="bi bi-clipboard2-pulse"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}" 
                                                               class="btn btn-sm btn-outline-primary" title="Book Appointment">
                                                                <i class="bi bi-calendar-plus"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" 
                                                               class="btn btn-sm btn-outline-success" title="View History">
                                                                <i class="bi bi-clipboard-pulse"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="mt-3 text-muted">
                                    <i class="bi bi-info-circle"></i> 
                                    Total: <strong>${children.size()}</strong> child${children.size() > 1 ? 'ren' : ''}
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
