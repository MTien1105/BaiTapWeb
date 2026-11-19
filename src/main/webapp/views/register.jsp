<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký Tài khoản</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; flex-direction: column; min-height: 100vh; }
        .register-container { max-width: 440px; margin: 40px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 24px; font-weight: 600; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; color: #495057; font-size: 14px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #28a745; }
        .btn-success { width: 100%; padding: 12px; background-color: #28a745; border: none; border-radius: 6px; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; margin-top: 10px; }
        .btn-success:hover { background-color: #218838; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; }
        .footer-links a { color: #007bff; text-decoration: none; font-weight: 500; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Tạo Tài Khoản Mới</h2>

        <c:if test="${alert != null}">
            <div class="alert-danger">${alert}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" novalidate>
            <div class="form-group">
                <label for="username">Tài khoản <span style="color: red;">*</span></label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Tên tài khoản (3-30 ký tự, không dấu)" value="${username}" required autofocus>
                <div id="username-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="fullname">Họ tên <span style="color: red;">*</span></label>
                <input type="text" id="fullname" name="fullname" class="form-control" placeholder="Nhập họ và tên đầy đủ" value="${fullname}" required>
                <div id="fullname-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="email">Email <span style="color: red;">*</span></label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Nhập địa chỉ email hợp lệ" value="${email}" required>
                <div id="email-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone" class="form-control" placeholder="Nhập số điện thoại (10 chữ số)" value="${phone}">
                <div id="phone-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu <span style="color: red;">*</span></label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)" required minlength="6">
                <div id="password-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu <span style="color: red;">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu" required minlength="6">
                <div id="confirmPassword-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <button type="submit" class="btn-success">Tạo tài khoản</button>
        </form>

        <script>
            document.getElementById('registerForm').addEventListener('submit', function(e) {
                let valid = true;

                function showError(inputId, errorId, msg) {
                    const err = document.getElementById(errorId);
                    err.textContent = msg;
                    err.style.display = 'block';
                    if (valid) {
                        document.getElementById(inputId).focus();
                    }
                    valid = false;
                }

                function hideErrors() {
                    const errors = document.querySelectorAll('[id$="-error"]');
                    errors.forEach(el => el.style.display = 'none');
                }

                hideErrors();

                const username = document.getElementById('username').value.trim();
                const fullname = document.getElementById('fullname').value.trim();
                const email = document.getElementById('email').value.trim();
                const phone = document.getElementById('phone').value.trim();
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                // Validate Username
                if (!username) {
                    showError('username', 'username-error', 'Vui lòng nhập tên tài khoản!');
                } else if (!/^[a-zA-Z0-9_]{3,30}$/.test(username)) {
                    showError('username', 'username-error', 'Tên tài khoản chỉ gồm chữ cái, số, gạch dưới (3-30 ký tự, không dấu, không khoảng trắng)!');
                }

                // Validate Fullname
                if (!fullname) {
                    showError('fullname', 'fullname-error', 'Vui lòng nhập họ và tên!');
                } else if (fullname.length < 2) {
                    showError('fullname', 'fullname-error', 'Họ tên phải có ít nhất 2 ký tự!');
                }

                // Validate Email
                const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                if (!email) {
                    showError('email', 'email-error', 'Vui lòng nhập địa chỉ email!');
                } else if (!emailRegex.test(email)) {
                    showError('email', 'email-error', 'Địa chỉ email không đúng định dạng!');
                }

                // Validate Phone nếu có nhập
                if (phone) {
                    const phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
                    if (!phoneRegex.test(phone)) {
                        showError('phone', 'phone-error', 'Số điện thoại không hợp lệ (cần 10 chữ số, đầu số 03, 05, 07, 08, 09)!');
                    }
                }

                // Validate Password
                if (!password) {
                    showError('password', 'password-error', 'Vui lòng nhập mật khẩu!');
                } else if (password.length < 6) {
                    showError('password', 'password-error', 'Mật khẩu phải có tối thiểu 6 ký tự!');
                }

                // Validate Confirm Password
                if (!confirmPassword) {
                    showError('confirmPassword', 'confirmPassword-error', 'Vui lòng xác nhận mật khẩu!');
                } else if (password !== confirmPassword) {
                    showError('confirmPassword', 'confirmPassword-error', 'Mật khẩu xác nhận không khớp!');
                }

                if (!valid) {
                    e.preventDefault();
                }
            });
        </script>

        <div class="footer-links">
            Nếu bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
</body>
</html>
