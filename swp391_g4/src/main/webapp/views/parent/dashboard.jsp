<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent Dashboard - Vaccination System</title>
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
        <div class="row">
            <div class="col-md-3">
                <div class="list-group">
                    <a href="${pageContext.request.contextPath}/parent/dashboard" class="list-group-item list-group-item-action active">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/children" class="list-group-item list-group-item-action">
                        <i class="bi bi-people"></i> My Children
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/appointments" class="list-group-item list-group-item-action">
                        <i class="bi bi-calendar-check"></i> Appointments
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/vaccinations" class="list-group-item list-group-item-action">
                        <i class="bi bi-clipboard-pulse"></i> Vaccination Records
                    </a>
                </div>
            </div>

            <div class="col-md-9">
                <h2 class="mb-4">Dashboard</h2>

                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-people"></i> My Children
                                </h5>
                                <h2>${children.size()}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-success">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-calendar-check"></i> Appointments
                                </h5>
                                <h2>0</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-info">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="bi bi-clipboard-pulse"></i> Vaccinations
                                </h5>
                                <h2>0</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">My Children</h5>
                        <a href="${pageContext.request.contextPath}/parent/children/add" class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-circle"></i> Add Child
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty children}">
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> 
                                    You haven't added any children yet. Click "Add Child" to get started.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Date of Birth</th>
                                                <th>Gender</th>
                                                <th>Blood Type</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${children}" var="child">
                                                <tr>
                                                    <td>${child.fullName}</td>
                                                    <td>${child.dateOfBirth}</td>
                                                    <td>${child.gender}</td>
                                                    <td>${child.bloodType != null ? child.bloodType : 'N/A'}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" 
                                                           class="btn btn-sm btn-info">
                                                            <i class="bi bi-eye"></i> View
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/parent/appointments/book?childId=${child.childId}" 
                                                           class="btn btn-sm btn-primary">
                                                            <i class="bi bi-calendar-plus"></i> Book Appointment
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Upcoming Appointments</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-secondary">
                            <i class="bi bi-calendar"></i> No upcoming appointments
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
