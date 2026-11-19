<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Quản Trị Video - JPA System</sitemesh:write></title>

    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f4f6f9;
            color: #333;
        }
        .main-wrapper {
            min-height: calc(100vh - 230px);
        }
        .admin-banner {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #fff;
            padding: 10px 24px;
            font-size: 13px;
        }
    </style>

    <!-- Sitemesh Head Content Injection -->
    <sitemesh:write property="head" />
</head>
<body class="d-flex flex-column h-100">

    <!-- Header / Navbar Bootstrap -->
    <jsp:include page="/common/web/header.jsp" />

    <!-- Admin Status Ribbon -->
    <div class="admin-banner d-flex justify-content-between align-items-center">
        <div>
            <i class="bi bi-shield-lock-fill me-1 text-warning"></i>
            <span>Bảng Điều Khiển Quản Trị Video (JPA CRUD & Phân Quyền)</span>
        </div>
        <div>
            <span class="badge bg-warning text-dark">
                User: ${sessionScope.account != null ? sessionScope.account.userName : 'Guest'} 
                (Role: ${sessionScope.account != null ? sessionScope.account.roleid : 'None'})
            </span>
        </div>
    </div>

    <!-- Main Content (Sitemesh Body Injection) -->
    <main class="main-wrapper flex-shrink-0">
        <sitemesh:write property="body" />
    </main>

    <!-- Footer Bootstrap -->
    <jsp:include page="/common/web/footer.jsp" />

    <!-- Bootstrap 5.3.3 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
