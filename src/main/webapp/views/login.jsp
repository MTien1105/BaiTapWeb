<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập vào Hệ thống</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; flex-direction: column; min-height: 100vh; }
        .login-container { max-width: 440px; margin: 50px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 24px; font-weight: 600; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; line-height: 1.5; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; color: #495057; font-size: 14px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #007bff; }
        .form-check { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; font-size: 14px; }
        .form-check label { display: flex; align-items: center; gap: 6px; cursor: pointer; color: #495057; }
        .forgot-link { color: #007bff; text-decoration: none; font-size: 13px; font-weight: 500; }
        .forgot-link:hover { text-decoration: underline; }
        .btn-primary { width: 100%; padding: 12px; background-color: #007bff; border: none; border-radius: 6px; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; }
        .btn-primary:hover { background-color: #0056b3; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; }
        .footer-links a { color: #007bff; text-decoration: none; font-weight: 500; }
        .footer-links a:hover { text-decoration: underline; }
        .activate-box { margin-top: 10px; background: #fff3cd; border: 1px solid #ffeeba; color: #856404; padding: 10px; border-radius: 6px; text-align: center; font-size: 13px; }
        .activate-box a { color: #533f03; font-weight: bold; text-decoration: underline; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng Nhập Vào Hệ Thống</h2>

        <c:if test="${not empty alert}">
            <div class="alert-danger">
                ${alert}
                <c:if test="${not empty unactivatedEmail}">
                    <div class="activate-box">
                        👉 <a href="${pageContext.request.contextPath}/verify-code?email=${unactivatedEmail}">Bấm vào đây để nhập mã OTP kích hoạt tài khoản</a>
                    </div>
                </c:if>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert-success">${message}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" novalidate>
            <c:if test="${not empty redirect}">
                <input type="hidden" name="redirect" value="${redirect}">
            </c:if>
            <div class="form-group">
                <label for="username">Tài khoản <span style="color: red;">*</span></label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tài khoản (tối thiểu 3 ký tự)" value="${username}" required minlength="3" autofocus>
                <div id="username-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu <span style="color: red;">*</span></label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)" required minlength="6">
                <div id="password-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-check">
                <label for="remember">
                    <input type="checkbox" name="remember" id="remember" value="on"> Nhớ tôi (Cookie)
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn-primary">Đăng nhập</button>
        </form>

        <script>
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                let valid = true;
                const username = document.getElementById('username');
                const password = document.getElementById('password');
                const userErr = document.getElementById('username-error');
                const passErr = document.getElementById('password-error');

                userErr.style.display = 'none';
                passErr.style.display = 'none';

                if (!username.value.trim()) {
                    userErr.textContent = 'Vui lòng nhập tên tài khoản!';
                    userErr.style.display = 'block';
                    username.focus();
                    valid = false;
                } else if (username.value.trim().length < 3) {
                    userErr.textContent = 'Tên tài khoản phải có ít nhất 3 ký tự!';
                    userErr.style.display = 'block';
                    username.focus();
                    valid = false;
                }

                if (!password.value) {
                    passErr.textContent = 'Vui lòng nhập mật khẩu!';
                    passErr.style.display = 'block';
                    if (valid) password.focus();
                    valid = false;
                } else if (password.value.length < 6) {
                    passErr.textContent = 'Mật khẩu phải có ít nhất 6 ký tự!';
                    passErr.style.display = 'block';
                    if (valid) password.focus();
                    valid = false;
                }

                if (!valid) {
                    e.preventDefault();
                }
            });
        </script>

        <div class="footer-links">
            Nếu bạn chưa có tài khoản trên hệ thống, hãy <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
        </div>
    </div>
</body>
</html>
