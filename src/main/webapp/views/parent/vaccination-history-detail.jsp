<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vaccination Records - ${child.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .child-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        .child-info-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            display: inline-block;
            margin-right: 1rem;
            margin-bottom: 0.5rem;
        }
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item {
            position: relative;
            padding-bottom: 2rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -2.5rem;
            top: 0;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #0d6efd;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #0d6efd;
        }
        .record-card {
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 1.5rem;
            background: white;
            transition: all 0.3s;
        }
        .record-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .info-row {
            display: flex;
            margin-bottom: 0.75rem;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 150px;
        }
        .info-value {
            color: #6c757d;
        }
        .section-divider {
            border-top: 1px solid #dee2e6;
            margin: 1rem 0;
        }
        .next-dose-badge {
            background-color: #fff3cd;
            color: #856404;
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            border: 1px solid #ffeaa7;
        }
        @media (max-width: 768px) {
            .info-row {
                flex-direction: column;
            }
            .info-label {
                min-width: auto;
                margin-bottom: 0.25rem;
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
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/vaccination-history">Vaccination History</a></li>
                <li class="breadcrumb-item active" aria-current="page">${child.fullName}</li>
            </ol>
        </nav>

        <div class="child-header">
            <div class="d-flex justify-content-between align-items-start flex-wrap">
                <div>
                    <h2 class="mb-3">
                        <i class="bi bi-person-circle"></i> ${child.fullName}
                    </h2>
                    <div>
                        <div class="child-info-badge">
                            <i class="bi bi-calendar3"></i> DOB: ${child.dateOfBirth}
                        </div>
                        <div class="child-info-badge">
                            <i class="bi bi-gender-ambiguous"></i> ${child.gender != null ? child.gender : 'N/A'}
                        </div>
                        <div class="child-info-badge">
                            <i class="bi bi-droplet-fill"></i> Blood Type: ${child.bloodType != null ? child.bloodType : 'N/A'}
                        </div>
                    </div>
                </div>
                <div class="mt-3 mt-md-0">
                    <button class="btn btn-light" disabled>
                        <i class="bi bi-download"></i> Download Certificate
                    </button>
                    <button class="btn btn-outline-light ms-2" disabled>
                        <i class="bi bi-printer"></i> Print
                    </button>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><i class="bi bi-clipboard2-pulse"></i> Vaccination Records</h4>
            <a href="${pageContext.request.contextPath}/parent/vaccination-history" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> Back to List
            </a>
        </div>

        <c:choose>
            <c:when test="${empty records}">
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-clipboard-x" style="font-size: 4rem; color: #6c757d;"></i>
                        <h4 class="mt-3 mb-2">No Vaccination Records Yet</h4>
                        <p class="text-muted mb-4">This child has not received any vaccinations yet.</p>
                        <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-primary">
                            <i class="bi bi-calendar-plus"></i> Book Appointment
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="timeline">
                    <c:forEach items="${records}" var="record">
                        <div class="timeline-item">
                            <div class="record-card">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h5 class="mb-0">
                                        <i class="bi bi-shield-fill-check text-success"></i> 
                                        ${record.vaccine.vaccineName}
                                    </h5>
                                    <span class="badge bg-primary">
                                        <fmt:formatDate value="${record.vaccinationDate}" pattern="MMM dd, yyyy"/>
                                    </span>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-building"></i> Manufacturer:
                                    </div>
                                    <div class="info-value">${record.vaccine.manufacturer}</div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="bi bi-clock"></i> Date & Time:
                                    </div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${record.vaccinationDate}" pattern="MMMM dd, yyyy 'at' hh:mm a"/>
                                    </div>
                                </div>

                                <c:if test="${not empty record.batchNumber}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-upc-scan"></i> Batch Number:
                                        </div>
                                        <div class="info-value">${record.batchNumber}</div>
                                    </div>
                                </c:if>

                                <c:if test="${record.doseNumber != null}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-hash"></i> Dose:
                                        </div>
                                        <div class="info-value">
                                            Dose ${record.doseNumber}
                                            <c:if test="${not empty record.vaccine.dosageSchedule}">
                                                of ${record.vaccine.dosageSchedule}
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty record.staff}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-person-badge"></i> Administered By:
                                        </div>
                                        <div class="info-value">${record.staff.fullName}</div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty record.healthCheckNotes || not empty record.vaccinationNotes || not empty record.sideEffectsReported}">
                                    <div class="section-divider"></div>
                                </c:if>

                                <c:if test="${not empty record.healthCheckNotes}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-heart-pulse"></i> Health Check:
                                        </div>
                                        <div class="info-value">${record.healthCheckNotes}</div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty record.vaccinationNotes}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-journal-medical"></i> Notes:
                                        </div>
                                        <div class="info-value">${record.vaccinationNotes}</div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty record.sideEffectsReported}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="bi bi-exclamation-triangle"></i> Side Effects:
                                        </div>
                                        <div class="info-value text-warning">${record.sideEffectsReported}</div>
                                    </div>
                                </c:if>

                                <c:if test="${record.nextDoseDate != null}">
                                    <div class="section-divider"></div>
                                    <div class="next-dose-badge">
                                        <i class="bi bi-calendar-check"></i> 
                                        <strong>Next Dose Scheduled:</strong> ${record.nextDoseDate}
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/parent/booking/step1" class="btn btn-primary">
                        <i class="bi bi-calendar-plus"></i> Book Next Appointment
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
