<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="topbar-nav" style="display: flex; justify-content: space-between; align-items: center; padding: 12px 24px; background-color: #ffffff; border-bottom: 1px solid #dee2e6; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
    <div style="display: flex; align-items: center; gap: 16px;">
        <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; font-weight: bold; color: #007bff; font-size: 18px;">🔐 JPA SYSTEM</a>
        <a href="${pageContext.request.contextPath}/video" style="text-decoration: none; font-weight: 600; color: #007bff; font-size: 14px; padding: 5px 12px; background: #e7f3fe; border: 1px solid #b8daff; border-radius: 4px;">🎬 Video Của User (/video)</a>
        <c:if test="${sessionScope.account != null}">
            <c:choose>
                <c:when test="${sessionScope.account.roleid == 1}">
                    <a href="${pageContext.request.contextPath}/admin/videos" style="text-decoration: none; font-weight: 600; color: #28a745; font-size: 14px; padding: 5px 12px; background: #e8f5e9; border: 1px solid #c8e6c9; border-radius: 4px;">📺 Quản Lý Tất Cả Video (Admin)</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/videos" style="text-decoration: none; font-weight: 600; color: #28a745; font-size: 14px; padding: 5px 12px; background: #e8f5e9; border: 1px solid #c8e6c9; border-radius: 4px;">📺 Quản Lý Video Của Tôi</a>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
    <c:choose>
        <c:when test="${sessionScope.account == null}">
            <div style="display: flex; align-items: center; gap: 10px;">
                <a href="${pageContext.request.contextPath}/login" style="display: inline-block; padding: 7px 16px; background: #007bff; color: #fff; text-decoration: none; border-radius: 4px; font-weight: 600; font-size: 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">🔑 Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" style="display: inline-block; padding: 7px 16px; background: #28a745; color: #fff; text-decoration: none; border-radius: 4px; font-weight: 600; font-size: 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">📝 Đăng ký</a>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display: flex; align-items: center; gap: 14px;">
                <span style="color: #333; font-weight: 500;">
                    👤 Xin chào, <strong>${sessionScope.account.fullName}</strong> (${sessionScope.account.userName})
                </span>
                <a href="${pageContext.request.contextPath}/logout" style="padding: 6px 14px; background: #dc3545; color: #fff; text-decoration: none; border-radius: 4px; font-weight: 600; font-size: 13px;">Đăng Xuất</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
