<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recommended Vaccines - Vaccination System</title>
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
                    <a href="${pageContext.request.contextPath}/parent/children" class="list-group-item list-group-item-action">
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
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}">${child.fullName}</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Recommended Vaccines</li>
                    </ol>
                </nav>

                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h4 class="mb-0"><i class="bi bi-person"></i> ${child.fullName}</h4>
                                <p class="text-muted mb-0">
                                    Age: <strong>${child.ageYears} year${child.ageYears > 1 ? 's' : ''}${child.ageRemainingMonths > 0 ? ' '.concat(child.ageRemainingMonths).concat(' month').concat(child.ageRemainingMonths > 1 ? 's' : '') : ''}</strong> 
                                    (${ageInMonths} months)
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <a href="${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}" class="btn btn-outline-primary">
                                    <i class="bi bi-clipboard-pulse"></i> View History
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i> 
                    <strong>Lịch tiêm khuyến nghị</strong> - Dưới đây là danh sách vaccine phù hợp với độ tuổi của bé.
                    <span class="badge bg-success ms-2">MIỄN PHÍ</span> là vaccine trong Chương trình TCMR Bộ Y tế.
                    <span class="badge bg-warning text-dark ms-1">TRẢ PHÍ</span> là vaccine dịch vụ (tự nguyện).
                </div>

                <c:forEach items="${groupedTemplates}" var="entry">
                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">
                                <i class="bi bi-bookmark-fill"></i> ${entry.key}
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;">#</th>
                                            <th style="width: 35%;">Vaccine</th>
                                            <th style="width: 20%;">Phòng bệnh</th>
                                            <th style="width: 15%;">Phân loại</th>
                                            <th style="width: 10%;">Trạng thái</th>
                                            <th style="width: 15%;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${entry.value}" var="template" varStatus="status">
                                            <c:set var="vaccine" value="${template.vaccine}" />
                                            <c:set var="isVaccinated" value="${vaccinatedVaccineIds.contains(vaccine.vaccineId)}" />
                                            <c:set var="appointment" value="${appointmentByVaccineId[vaccine.vaccineId]}" />
                                            <tr>
                                                <td>${status.count}</td>
                                                <td>
                                                    <strong>${vaccine.vaccineName}</strong>
                                                    <br>
                                                    <small class="text-muted">${template.description}</small>
                                                </td>
                                                <td>${vaccine.diseasesPrevented}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${vaccine.free}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle"></i> MIỄN PHÍ
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="bi bi-cash"></i> TRẢ PHÍ
                                                            </span>
                                                            <br>
                                                            <small>${vaccine.price > 0 ? vaccine.price.toString().concat(' VNĐ') : 'N/A'}</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isVaccinated}">
                                                            <span class="badge bg-primary">
                                                                <i class="bi bi-check-lg"></i> Đã tiêm
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${not empty appointment}">
                                                            <span class="badge bg-info text-dark">
                                                                <i class="bi bi-calendar-event"></i> Đã đặt lịch
                                                            </span>
                                                            <br>
                                                            <small class="text-muted">${appointment.appointmentDate}</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">
                                                                <i class="bi bi-clock"></i> Chưa có lịch
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${isVaccinated}">
                                                            <button class="btn btn-sm btn-outline-secondary" disabled>
                                                                <i class="bi bi-check"></i> Hoàn thành
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${vaccine.free}">
                                                            <%-- Vaccine MIỄN PHÍ: Đã tự động tạo lịch hoặc xem lịch hẹn --%>
                                                            <c:choose>
                                                                <c:when test="${not empty appointment}">
                                                                    <a href="${pageContext.request.contextPath}/parent/appointments" 
                                                                       class="btn btn-sm btn-outline-info">
                                                                        <i class="bi bi-calendar-check"></i> Xem lịch hẹn
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">
                                                                        <i class="bi bi-info-circle"></i> Tự động tạo lịch
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <%-- Vaccine TRẢ PHÍ: Cần đặt lịch thủ công --%>
                                                            <a href="${pageContext.request.contextPath}/parent/booking/step1?childId=${child.childId}&vaccineId=${vaccine.vaccineId}" 
                                                               class="btn btn-sm btn-primary">
                                                                <i class="bi bi-calendar-plus"></i> Đặt lịch
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty groupedTemplates}">
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle"></i> 
                        Không có vaccine khuyến nghị cho độ tuổi này.
                    </div>
                </c:if>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/parent/children/view?id=${child.childId}" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
