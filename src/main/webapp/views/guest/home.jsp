<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Child Vaccination Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-heart-pulse"></i> Vaccination System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i> Logout
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="jumbotron text-center bg-primary text-white p-5 rounded">
            <h1 class="display-4">Child Vaccination Management System</h1>
            <p class="lead">Protecting children's health through comprehensive vaccination management</p>
            <hr class="my-4 bg-white">
            <p>Manage vaccination schedules, book appointments, and track immunization records</p>
            <c:choose>
                <c:when test="${sessionScope.user == null}">
                    <a class="btn btn-light btn-lg" href="${pageContext.request.contextPath}/register">Get Started</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-light btn-lg" href="${pageContext.request.contextPath}/parent/dashboard">My Dashboard</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="row mt-5">
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-shield-check text-primary" style="font-size: 3rem;"></i>
                        <h5 class="card-title mt-3">Safe & Reliable</h5>
                        <p class="card-text">WHO-approved vaccines administered by certified medical professionals</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check text-success" style="font-size: 3rem;"></i>
                        <h5 class="card-title mt-3">Easy Scheduling</h5>
                        <p class="card-text">Book appointments online at your convenience</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-file-medical text-info" style="font-size: 3rem;"></i>
                        <h5 class="card-title mt-3">Digital Records</h5>
                        <p class="card-text">Access vaccination history anytime, anywhere</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <h3>Available Vaccines</h3>
                <div class="list-group">
                    <c:forEach items="${vaccines}" var="vaccine" begin="0" end="4">
                        <div class="list-group-item">
                            <h6 class="mb-1">${vaccine.vaccineName}</h6>
                            <small class="text-muted">${vaccine.diseasesPrevented}</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="col-md-6">
                <h3>Vaccination Centers</h3>
                <div class="list-group">
                    <c:forEach items="${centers}" var="center" begin="0" end="4">
                        <div class="list-group-item">
                            <h6 class="mb-1">${center.centerName}</h6>
                            <small class="text-muted">${center.address}, ${center.city}</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-light mt-5 py-3">
        <div class="container text-center">
            <p class="text-muted mb-0">&copy; 2025 Child Vaccination Management System. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
