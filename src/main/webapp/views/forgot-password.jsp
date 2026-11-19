<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu - Nhận Mã OTP Qua Email</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; flex-direction: column; min-height: 100vh; }
        .forgot-container { max-width: 440px; margin: 50px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 12px; font-weight: 600; }
        .desc { text-align: center; font-size: 14px; color: #6c757d; margin-bottom: 24px; line-height: 1.5; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #495057; font-size: 14px; }
        .form-control { width: 100%; padding: 11px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #007bff; }
        .btn-primary { width: 100%; padding: 12px; background-color: #007bff; border: none; border-radius: 6px; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; }
        .btn-primary:hover { background-color: #0056b3; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; border-top: 1px solid #eee; padding-top: 15px; }
        .footer-links a { color: #007bff; text-decoration: none; font-weight: 500; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="topbar.jsp" />

    <div class="forgot-container">
        <h2>🔑 Quên Mật Khẩu</h2>
        <p class="desc">Nhập tên tài khoản hoặc email của bạn. Hệ thống sẽ gửi một mã xác nhận OTP về hòm thư để bạn thiết lập lại mật khẩu mới.</p>

        <c:if test="${not empty alert}">
            <div class="alert-danger">${alert}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="forgotForm" novalidate>
            <div class="form-group">
                <label for="emailOrUsername">Tài khoản hoặc Địa chỉ Email <span style="color: red;">*</span></label>
                <input type="text" id="emailOrUsername" name="emailOrUsername" class="form-control" placeholder="Ví dụ: admin hoặc user@example.com" value="${emailOrUsername}" required autofocus>
                <div id="input-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <button type="submit" class="btn-primary">Gửi Mã Xác Nhận OTP</button>
        </form>

        <script>
            document.getElementById('forgotForm').addEventListener('submit', function(e) {
                const input = document.getElementById('emailOrUsername').value.trim();
                const err = document.getElementById('input-error');
                err.style.display = 'none';

                if (!input) {
                    err.textContent = 'Vui lòng nhập tên tài khoản hoặc địa chỉ email!';
                    err.style.display = 'block';
                    document.getElementById('emailOrUsername').focus();
                    e.preventDefault();
                } else if (input.includes('@') && !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(input)) {
                    err.textContent = 'Địa chỉ email không đúng định dạng!';
                    err.style.display = 'block';
                    document.getElementById('emailOrUsername').focus();
                    e.preventDefault();
                }
            });
        </script>

        <div class="footer-links">
            Nhớ lại mật khẩu rồi? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
        </div>
    </div>
</body>
</html>
