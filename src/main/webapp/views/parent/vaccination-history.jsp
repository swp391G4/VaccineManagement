<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vaccination History - Vaccination System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .child-card {
            transition: all 0.3s;
            cursor: pointer;
            border: 1px solid #dee2e6;
            height: 100%;
        }
        .child-card:hover {
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
            transform: translateY(-5px);
            border-color: #0d6efd;
        }
        .child-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin: 0 auto 1rem;
        }
        .child-avatar.male {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
        }
        .child-avatar.female {
            background: linear-gradient(135deg, #e91e63 0%, #c2185b 100%);
        }
        .child-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        .child-info-item i {
            width: 20px;
            margin-right: 8px;
            color: #6c757d;
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
                <li class="breadcrumb-item active" aria-current="page">Vaccination History</li>
            </ol>
        </nav>

        <div class="mb-4">
            <h2><i class="bi bi-clipboard2-pulse"></i> Vaccination History</h2>
            <p class="text-muted">Select a child to view their vaccination records</p>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${empty children}">
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="bi bi-person-x" style="font-size: 4rem; color: #6c757d;"></i>
                        <h4 class="mt-3 mb-2">No Children Found</h4>
                        <p class="text-muted mb-4">You haven't added any children yet. Add a child to view their vaccination history.</p>
                        <a href="${pageContext.request.contextPath}/parent/children/add" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add Child
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach items="${children}" var="child">
                        <div class="col-md-6 col-lg-4">
                            <div class="card child-card" onclick="location.href='${pageContext.request.contextPath}/parent/vaccination-history/${child.childId}'">
                                <div class="card-body text-center">
                                    <div class="child-avatar ${child.gender != null ? child.gender.toLowerCase() : ''}">
                                        <c:choose>
                                            <c:when test="${child.gender == 'Male'}">
                                                <i class="bi bi-person"></i>
                                            </c:when>
                                            <c:when test="${child.gender == 'Female'}">
                                                <i class="bi bi-person-dress"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-person"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h5 class="card-title mb-3">${child.fullName}</h5>
                                    
                                    <div class="text-start">
                                        <div class="child-info-item">
                                            <i class="bi bi-calendar3"></i>
                                            <span><strong>DOB:</strong> ${child.dateOfBirth}</span>
                                        </div>
                                        <div class="child-info-item">
                                            <i class="bi bi-gender-ambiguous"></i>
                                            <span><strong>Gender:</strong> ${child.gender != null ? child.gender : 'N/A'}</span>
                                        </div>
                                        <div class="child-info-item">
                                            <i class="bi bi-droplet-fill"></i>
                                            <span><strong>Blood Type:</strong> ${child.bloodType != null ? child.bloodType : 'N/A'}</span>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-3">
                                        <span class="badge bg-primary">
                                            <i class="bi bi-eye"></i> View Records
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
