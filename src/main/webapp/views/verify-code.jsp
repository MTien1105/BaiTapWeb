<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kích Hoạt Tài Khoản Bằng Mã OTP</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; flex-direction: column; min-height: 100vh; }
        .verify-container { max-width: 440px; margin: 50px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 12px; font-weight: 600; }
        .desc { text-align: center; font-size: 14px; color: #6c757d; margin-bottom: 20px; line-height: 1.5; }
        .desc strong { color: #007bff; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .demo-box { background: #e8f4fd; border: 1px dashed #0275d8; color: #025aa5; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 13px; text-align: center; }
        .demo-box strong { font-size: 16px; letter-spacing: 2px; color: #d9534f; }
        .form-group { margin-bottom: 20px; text-align: center; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #495057; font-size: 14px; }
        .otp-input { width: 100%; max-width: 260px; margin: 0 auto; padding: 12px; font-size: 24px; text-align: center; letter-spacing: 8px; border: 2px solid #ced4da; border-radius: 8px; font-weight: bold; }
        .otp-input:focus { outline: none; border-color: #28a745; box-shadow: 0 0 0 3px rgba(40,167,69,0.2); }
        .btn-success { width: 100%; padding: 12px; background-color: #28a745; border: none; border-radius: 6px; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; }
        .btn-success:hover { background-color: #218838; }
        .resend-box { text-align: center; margin-top: 18px; font-size: 14px; color: #6c757d; }
        .resend-box a { color: #007bff; text-decoration: none; font-weight: 500; }
        .resend-box a:hover { text-decoration: underline; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; border-top: 1px solid #eee; padding-top: 15px; }
        .footer-links a { color: #6c757d; text-decoration: none; }
        .footer-links a:hover { color: #007bff; text-decoration: underline; }
    </style>
</head>
<body>
    <div class="verify-container">
        <h2>📧 Kích Hoạt Tài Khoản</h2>
        <p class="desc">Mã xác thực OTP gồm 6 chữ số đã được gửi tới hòm thư:<br><strong>${email}</strong></p>

        <c:if test="${not empty alert}">
            <div class="alert-danger">${alert}</div>
        </c:if>

        <c:if test="${not empty successMsg}">
            <div class="alert-success">${successMsg}</div>
        </c:if>

        <c:if test="${not empty demoOtp}">
            <div class="demo-box">
                ℹ️ <em>Chế độ kiểm thử cục bộ:</em> Mã OTP của bạn là: <strong>${demoOtp}</strong>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/verify-code" method="post" id="verifyForm" novalidate>
            <input type="hidden" name="email" value="${email}">

            <div class="form-group">
                <label for="otp">Nhập Mã OTP (6 chữ số) <span style="color: red;">*</span></label>
                <input type="text" id="otp" name="otp" class="otp-input" maxlength="6" pattern="[0-9]{6}" placeholder="------" required autofocus autocomplete="one-time-code">
                <div id="otp-error" style="color: #dc3545; font-size: 13px; margin-top: 6px; text-align: center; display: none;"></div>
            </div>

            <button type="submit" class="btn-success">Xác Nhận Kích Hoạt</button>
        </form>

        <script>
            document.getElementById('verifyForm').addEventListener('submit', function(e) {
                const otp = document.getElementById('otp').value.trim();
                const err = document.getElementById('otp-error');
                err.style.display = 'none';

                if (!otp) {
                    err.textContent = 'Vui lòng nhập mã OTP!';
                    err.style.display = 'block';
                    document.getElementById('otp').focus();
                    e.preventDefault();
                } else if (!/^[0-9]{6}$/.test(otp)) {
                    err.textContent = 'Mã OTP phải gồm đúng 6 chữ số!';
                    err.style.display = 'block';
                    document.getElementById('otp').focus();
                    e.preventDefault();
                }
            });
        </script>

        <div class="resend-box">
            Chưa nhận được mã? <a href="${pageContext.request.contextPath}/resend-otp?email=${email}">Gửi lại mã OTP</a>
        </div>

        <div class="footer-links">
            Quay lại trang <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
</body>
</html>
