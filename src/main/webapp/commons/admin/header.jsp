<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- Admin Header Component -->
<header class="bg-dark text-white py-2 px-4 shadow-sm d-flex justify-content-between align-items-center">
    <div class="fw-bold fs-5">⚙️ Quản Trị Hệ Thống - JPA Videos</div>
    <div class="d-flex align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm">🏠 Về Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">Đăng Xuất</a>
    </div>
</header>
