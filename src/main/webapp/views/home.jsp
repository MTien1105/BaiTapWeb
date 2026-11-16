<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Thông Tin Đăng Nhập</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; }
        .main-content { max-width: 650px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h1 { color: #28a745; margin-bottom: 12px; font-size: 24px; text-align: center; }
        .subtitle { color: #6c757d; font-size: 14px; text-align: center; margin-bottom: 24px; }
        .user-card { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; }
        .user-card h3 { color: #007bff; margin-bottom: 15px; font-size: 18px; border-bottom: 1px solid #dee2e6; padding-bottom: 8px; }
        .info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #e9ecef; }
        .info-row:last-child { border-bottom: none; }
        .info-label { font-weight: 600; color: #495057; }
        .info-val { color: #212529; }
        .badge { display: inline-block; padding: 3px 8px; background: #007bff; color: #fff; border-radius: 4px; font-size: 13px; font-weight: 500; }
        .badge-active { background: #28a745; color: #fff; padding: 3px 8px; border-radius: 4px; font-size: 13px; font-weight: 500; }
        .badge-sec { background: #17a2b8; color: #fff; padding: 3px 8px; border-radius: 4px; font-size: 13px; font-weight: 500; }
        .btn-logout { display: block; width: 100%; text-align: center; margin-top: 24px; padding: 12px; background: #dc3545; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; transition: background 0.2s; }
        .btn-logout:hover { background: #c82333; }
    </style>
</head>
<body>
    <jsp:include page="topbar.jsp" />

    <div class="main-content">
        <h1>🎉 Đăng Nhập Thành Công!</h1>
        <p class="subtitle">Dữ liệu tài khoản được quản lý và bảo mật qua JPA (Hibernate) & BCrypt Password Hash.</p>

        <c:if test="${sessionScope.account != null}">
            <div class="user-card">
                <h3>Thông Tin Tài Khoản (Từ Session)</h3>
                <div class="info-row">
                    <span class="info-label">Tài khoản (Username):</span>
                    <span class="info-val"><strong>${sessionScope.account.userName}</strong></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Họ và tên:</span>
                    <span class="info-val">${sessionScope.account.fullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-val">${sessionScope.account.email}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Số điện thoại:</span>
                    <span class="info-val">${sessionScope.account.phone != null ? sessionScope.account.phone : 'Chưa cập nhật'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Trạng thái kích hoạt:</span>
                    <span class="info-val"><span class="badge-active">✅ Đã kích hoạt qua OTP (Status: ${sessionScope.account.status})</span></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Cơ chế bảo mật:</span>
                    <span class="info-val"><span class="badge-sec">🔒 BCrypt Password Hashed</span></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Vai trò:</span>
                    <span class="info-val"><span class="badge">Role ID: ${sessionScope.account.roleid}</span></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Ngày tạo:</span>
                    <span class="info-val">${sessionScope.account.createdDate}</span>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng Xuất</a>
        </c:if>
    </div>
</body>
</html>
