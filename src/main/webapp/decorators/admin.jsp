<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Quản Trị Video - JPA System</sitemesh:write></title>

    <!-- Bootstrap 5.3 CSS Template -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f4f6f9;
            color: #333;
        }
        .main-wrapper {
            min-height: calc(100vh - 220px);
        }
        .admin-banner {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #fff;
            padding: 10px 24px;
            font-size: 13px;
        }
    </style>

    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column h-100">

    <!-- Header Navbar Component Bootstrap (Static Include an toan tuyet doi) -->
    <%@ include file="/common/web/header.jsp" %>

    <!-- Admin Banner Ribbon -->
    <div class="admin-banner d-flex justify-content-between align-items-center">
        <div>
            <i class="bi bi-shield-lock-fill me-1 text-warning"></i>
            <span>Bảng Điều Khiển Quản Trị Video (JPA CRUD &amp; Phân Quyền)</span>
        </div>
        <div>
            <span class="badge bg-warning text-dark">
                User: ${sessionScope.account != null ? sessionScope.account.userName : 'Guest'} 
                (Role: ${sessionScope.account != null ? sessionScope.account.roleid : 'None'})
            </span>
        </div>
    </div>

    <!-- Main Content Body Injection từ SiteMesh -->
    <main class="main-wrapper flex-shrink-0">
        <sitemesh:write property="body"/>
    </main>

    <!-- Footer Component Bootstrap (Static Include an toan tuyet doi) -->
    <%@ include file="/common/web/footer.jsp" %>

    <!-- Bootstrap 5.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
