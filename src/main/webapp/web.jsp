<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Hệ Thống Video JPA - Bootstrap Template</sitemesh:write></title>

    <!-- Bootstrap 5.3 CSS Template -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        body {
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }
        .main-wrapper {
            min-height: calc(100vh - 220px);
        }
    </style>

    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column h-100">

    <!-- Header Navbar Component Bootstrap (Static Include an toan tuyet doi) -->
    <%@ include file="/common/web/header.jsp" %>

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
