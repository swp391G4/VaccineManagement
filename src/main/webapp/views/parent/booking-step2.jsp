<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Step 2 - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .summary-card {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
        }
        .time-slot {
            cursor: pointer;
            transition: all 0.3s;
        }
        .time-slot:hover {
            transform: scale(1.05);
        }
        .time-slot.selected {
            background-color: #0d6efd !important;
            color: white !important;
        }
        .center-card {
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        .center-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .center-card.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
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
                <li class="breadcrumb-item active" aria-current="page">Book Appointment - Step 2</li>
            </ol>
        </nav>

        <div class="card mb-4 summary-card">
            <div class="card-body">
                <h5 class="mb-3"><i class="bi bi-info-circle"></i> Booking Summary</h5>
                <div class="row">
                    <div class="col-md-6">
                        <p class="mb-1"><strong><i class="bi bi-person-fill"></i> Child:</strong> ${child.fullName}</p>
                        <p class="mb-1 text-muted small">DOB: ${child.dateOfBirth} | ${child.gender}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1"><strong><i class="bi bi-shield-fill-check"></i> Vaccine:</strong> ${vaccine.vaccineName}</p>
                        <p class="mb-1 text-muted small">
                            Price: <strong class="text-success"><fmt:formatNumber value="${vaccine.price}" type="currency" currencySymbol="$"/></strong>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="bi bi-calendar-check"></i> Book Appointment - Step 2: Select Center, Date & Time
                </h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="get" action="${pageContext.request.contextPath}/parent/booking/confirm" id="step2Form">
                    <input type="hidden" name="childId" value="${child.childId}">
                    <input type="hidden" name="vaccineId" value="${vaccine.vaccineId}">

                    <div class="mb-4">
                        <h5 class="mb-3"><i class="bi bi-building"></i> Select Vaccination Center</h5>
                        <c:choose>
                            <c:when test="${empty centers}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-info-circle"></i> No vaccination centers available.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3">
                                    <c:forEach items="${centers}" var="center">
                                        <div class="col-md-6">
                                            <div class="card center-card h-100 ${selectedCenterId == center.centerId ? 'selected' : ''}" 
                                                 onclick="selectCenter(${center.centerId})">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input center-radio" type="radio" 
                                                               name="centerId" value="${center.centerId}" 
                                                               id="center${center.centerId}" 
                                                               ${selectedCenterId == center.centerId ? 'checked' : ''} required
                                                               onchange="updateTimeSlots()">
                                                        <label class="form-check-label w-100" for="center${center.centerId}">
                                                            <h6 class="mb-2">
                                                                <i class="bi bi-hospital"></i> ${center.centerName}
                                                            </h6>
                                                            <p class="mb-1 small">
                                                                <i class="bi bi-geo-alt"></i> ${center.address}
                                                                <c:if test="${not empty center.city}">, ${center.city}</c:if>
                                                            </p>
                                                            <c:if test="${not empty center.phoneNumber}">
                                                                <p class="mb-1 small">
                                                                    <i class="bi bi-telephone"></i> ${center.phoneNumber}
                                                                </p>
                                                            </c:if>
                                                            <c:if test="${not empty center.operatingHours}">
                                                                <p class="mb-0 small text-muted">
                                                                    <i class="bi bi-clock"></i> ${center.operatingHours}
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
                        <h5 class="mb-3"><i class="bi bi-calendar3"></i> Select Appointment Date</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>
                                <jsp:useBean id="maxDate" class="java.util.Date"/>
                                <jsp:setProperty name="maxDate" property="time" value="${now.time + 30 * 24 * 60 * 60 * 1000}"/>
                                <fmt:formatDate value="${maxDate}" pattern="yyyy-MM-dd" var="maxDateStr"/>
                                
                                <input type="date" class="form-control" name="date" id="appointmentDate" 
                                       value="${selectedDate}" min="${today}" max="${maxDateStr}" required
                                       onchange="updateTimeSlots()">
                                <small class="form-text text-muted">
                                    Select a date within the next 30 days
                                </small>
                            </div>
                        </div>
                    </div>

                    <hr>

                    <div class="mb-4" id="timeSlotsSection" style="${not empty availableSlots ? '' : 'display:none;'}">
                        <h5 class="mb-3"><i class="bi bi-clock"></i> Select Time Slot</h5>
                        <c:choose>
                            <c:when test="${not empty availableSlots}">
                                <div class="row g-2">
                                    <c:forEach items="${availableSlots}" var="slot">
                                        <div class="col-6 col-md-3 col-lg-2">
                                            <button type="button" class="btn btn-outline-primary w-100 time-slot" 
                                                    onclick="selectTimeSlot('${slot}', this)">
                                                <i class="bi bi-clock"></i> ${slot}
                                            </button>
                                        </div>
                                    </c:forEach>
                                </div>
                                <input type="hidden" name="time" id="selectedTime" required>
                            </c:when>
                            <c:when test="${selectedDate != null and selectedCenterId != null}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-info-circle"></i> No available time slots for this date. Please select another date.
                                </div>
                            </c:when>
                        </c:choose>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back
                        </a>
                        <button type="submit" class="btn btn-primary" id="nextButton">
                            Next Step <i class="bi bi-arrow-right"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectCenter(centerId) {
            document.querySelectorAll('.center-card').forEach(card => card.classList.remove('selected'));
            document.getElementById('center' + centerId).checked = true;
            document.getElementById('center' + centerId).closest('.center-card').classList.add('selected');
            updateTimeSlots();
        }

        function updateTimeSlots() {
            const centerId = document.querySelector('input[name="centerId"]:checked')?.value;
            const date = document.getElementById('appointmentDate').value;
            
            if (centerId && date) {
                const url = '${pageContext.request.contextPath}/parent/booking/step2?childId=${child.childId}&vaccineId=${vaccine.vaccineId}&centerId=' + centerId + '&date=' + date;
                window.location.href = url;
            }
        }

        function selectTimeSlot(time, button) {
            document.querySelectorAll('.time-slot').forEach(btn => {
                btn.classList.remove('selected', 'btn-primary');
                btn.classList.add('btn-outline-primary');
            });
            
            button.classList.remove('btn-outline-primary');
            button.classList.add('btn-primary', 'selected');
            
            document.getElementById('selectedTime').value = time;
        }

        document.querySelectorAll('.center-radio').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.center-card').forEach(card => card.classList.remove('selected'));
                if (this.checked) {
                    this.closest('.center-card').classList.add('selected');
                }
            });
        });

        <c:if test="${not empty availableSlots}">
            document.getElementById('timeSlotsSection').style.display = 'block';
        </c:if>
    </script>
</body>
</html>
