<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="topbar-nav" style="display: flex; justify-content: space-between; align-items: center; padding: 12px 24px; background-color: #ffffff; border-bottom: 1px solid #dee2e6; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
    <div>
        <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; font-weight: bold; color: #007bff; font-size: 18px;">🔐 JPA AUTH SYSTEM</a>
    </div>
    <c:choose>
        <c:when test="${sessionScope.account == null}">
            <div>
                <a href="${pageContext.request.contextPath}/login" style="margin-right: 12px; text-decoration: none; font-weight: 600; color: #007bff;">Đăng nhập</a>
                <span>|</span>
                <a href="${pageContext.request.contextPath}/register" style="margin-left: 12px; text-decoration: none; font-weight: 600; color: #28a745;">Đăng ký</a>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display: flex; align-items: center; gap: 16px;">
                <span style="color: #333; font-weight: 500;">
                    👤 Xin chào, <strong>${sessionScope.account.fullName}</strong> (${sessionScope.account.userName})
                </span>
                <span>|</span>
                <a href="${pageContext.request.contextPath}/logout" style="text-decoration: none; color: #dc3545; font-weight: 600;">Đăng Xuất</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
