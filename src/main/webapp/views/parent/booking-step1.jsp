<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Step 1 - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .child-card, .vaccine-card {
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        .child-card:hover, .vaccine-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .child-card.selected, .vaccine-card.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }
        .vaccine-price {
            font-size: 1.2rem;
            font-weight: bold;
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

    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active" aria-current="page">Book Appointment - Step 1</li>
            </ol>
        </nav>

        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="bi bi-calendar-plus"></i> Book Appointment - Step 1: Select Child & Vaccine
                </h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="get" action="${pageContext.request.contextPath}/parent/booking/step2" id="bookingForm">
                    <div class="mb-4">
                        <h5 class="mb-3"><i class="bi bi-person"></i> Select Child</h5>
                        <c:choose>
                            <c:when test="${empty children}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-info-circle"></i> 
                                    You haven't added any children yet. 
                                    <a href="${pageContext.request.contextPath}/parent/children/add" class="alert-link">
                                        Click here to add a child
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3">
                                    <c:forEach items="${children}" var="child">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="card child-card h-100" onclick="selectChild(${child.childId})">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input child-radio" type="radio" 
                                                               name="childId" value="${child.childId}" 
                                                               id="child${child.childId}" required>
                                                        <label class="form-check-label w-100" for="child${child.childId}">
                                                            <h6 class="mb-2"><i class="bi bi-person-fill"></i> ${child.fullName}</h6>
                                                            <p class="mb-1 small text-muted">
                                                                <i class="bi bi-calendar3"></i> DOB: ${child.dateOfBirth}
                                                            </p>
                                                            <p class="mb-1 small text-muted">
                                                                <i class="bi bi-gender-ambiguous"></i> ${child.gender}
                                                            </p>
                                                            <c:if test="${not empty child.bloodType}">
                                                                <p class="mb-0 small text-muted">
                                                                    <i class="bi bi-droplet"></i> Blood: ${child.bloodType}
                                                                </p>
                                                            </c:if>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr>

                    <div class="mb-4">
                        <h5 class="mb-3"><i class="bi bi-shield-plus"></i> Select Vaccine</h5>
                        <c:choose>
                            <c:when test="${empty vaccines}">
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> No vaccines available at the moment.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3">
                                    <c:forEach items="${vaccines}" var="vaccine">
                                        <div class="col-md-6">
                                            <div class="card vaccine-card h-100" onclick="selectVaccine(${vaccine.vaccineId})">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input vaccine-radio" type="radio" 
                                                               name="vaccineId" value="${vaccine.vaccineId}" 
                                                               id="vaccine${vaccine.vaccineId}" required>
                                                        <label class="form-check-label w-100" for="vaccine${vaccine.vaccineId}">
                                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                                <h6 class="mb-0">
                                                                    <i class="bi bi-shield-fill-check text-primary"></i> 
                                                                    ${vaccine.vaccineName}
                                                                </h6>
                                                                <span class="vaccine-price">
                                                                    <fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/>
                                                                </span>
                                                            </div>
                                                            <c:if test="${not empty vaccine.manufacturer}">
                                                                <p class="mb-1 small text-muted">
                                                                    <i class="bi bi-building"></i> ${vaccine.manufacturer}
                                                                </p>
                                                            </c:if>
                                                            <c:if test="${not empty vaccine.description}">
                                                                <p class="mb-1 small">${vaccine.description}</p>
                                                            </c:if>
                                                            <c:if test="${not empty vaccine.diseasesPrevented}">
                                                                <p class="mb-1 small">
                                                                    <strong>Prevents:</strong> ${vaccine.diseasesPrevented}
                                                                </p>
                                                            </c:if>
                                                            <c:if test="${not empty vaccine.recommendedAge}">
                                                                <p class="mb-0 small text-muted">
                                                                    <i class="bi bi-clock"></i> Age: ${vaccine.recommendedAge}
                                                                </p>
                                                            </c:if>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to Dashboard
                        </a>
                        <c:if test="${not empty children and not empty vaccines}">
                            <button type="submit" class="btn btn-primary">
                                Next Step <i class="bi bi-arrow-right"></i>
                            </button>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectChild(childId) {
            document.querySelectorAll('.child-card').forEach(card => card.classList.remove('selected'));
            document.getElementById('child' + childId).checked = true;
            document.getElementById('child' + childId).closest('.child-card').classList.add('selected');
        }

        function selectVaccine(vaccineId) {
            document.querySelectorAll('.vaccine-card').forEach(card => card.classList.remove('selected'));
            document.getElementById('vaccine' + vaccineId).checked = true;
            document.getElementById('vaccine' + vaccineId).closest('.vaccine-card').classList.add('selected');
        }

        document.querySelectorAll('.child-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.child-card').forEach(card => card.classList.remove('selected'));
                if (this.checked) {
                    this.closest('.child-card').classList.add('selected');
                }
            });
        });

        document.querySelectorAll('.vaccine-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.vaccine-card').forEach(card => card.classList.remove('selected'));
                if (this.checked) {
                    this.closest('.vaccine-card').classList.add('selected');
                }
            });
        });
    </script>
</body>
</html>
