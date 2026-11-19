<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt Lại Mật Khẩu Mới</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; display: flex; flex-direction: column; min-height: 100vh; }
        .reset-container { max-width: 440px; margin: 40px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 12px; font-weight: 600; }
        .desc { text-align: center; font-size: 14px; color: #6c757d; margin-bottom: 20px; line-height: 1.5; }
        .desc strong { color: #007bff; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .demo-box { background: #e8f4fd; border: 1px dashed #0275d8; color: #025aa5; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 13px; text-align: center; }
        .demo-box strong { font-size: 16px; letter-spacing: 2px; color: #d9534f; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; color: #495057; font-size: 14px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #007bff; }
        .otp-input { text-align: center; letter-spacing: 6px; font-size: 20px; font-weight: bold; }
        .btn-warning { width: 100%; padding: 12px; background-color: #ffc107; border: none; border-radius: 6px; color: #212529; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; margin-top: 10px; }
        .btn-warning:hover { background-color: #e0a800; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; border-top: 1px solid #eee; padding-top: 15px; }
        .footer-links a { color: #007bff; text-decoration: none; font-weight: 500; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="topbar.jsp" />

    <div class="reset-container">
        <h2>🔒 Thiết Lập Mật Khẩu Mới</h2>
        <p class="desc">Mã xác nhận OTP đã được gửi đến email:<br><strong>${email}</strong></p>

        <c:if test="${not empty alert}">
            <div class="alert-danger">${alert}</div>
        </c:if>

        <c:if test="${not empty demoResetOtp}">
            <div class="demo-box">
                ℹ️ <em>Chế độ kiểm thử cục bộ:</em> Mã OTP khôi phục là: <strong>${demoResetOtp}</strong>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm" novalidate>
            <input type="hidden" name="email" value="${email}">

            <div class="form-group">
                <label for="otp">Mã Xác Nhận OTP (6 chữ số) <span style="color: red;">*</span></label>
                <input type="text" id="otp" name="otp" class="form-control otp-input" maxlength="6" pattern="[0-9]{6}" placeholder="------" required autofocus autocomplete="one-time-code">
                <div id="otp-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; text-align: center; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="newPassword">Mật khẩu mới <span style="color: red;">*</span></label>
                <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" required minlength="6">
                <div id="newPassword-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu mới <span style="color: red;">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required minlength="6">
                <div id="confirmPassword-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <button type="submit" class="btn-warning">Cập Nhật Mật Khẩu Mới</button>
        </form>

        <script>
            document.getElementById('resetForm').addEventListener('submit', function(e) {
                let valid = true;

                function showError(id, errId, msg) {
                    const el = document.getElementById(errId);
                    el.textContent = msg;
                    el.style.display = 'block';
                    if (valid) document.getElementById(id).focus();
                    valid = false;
                }

                document.querySelectorAll('[id$="-error"]').forEach(el => el.style.display = 'none');

                const otp = document.getElementById('otp').value.trim();
                const newPass = document.getElementById('newPassword').value;
                const confirmPass = document.getElementById('confirmPassword').value;

                if (!otp) {
                    showError('otp', 'otp-error', 'Vui lòng nhập mã OTP!');
                } else if (!/^[0-9]{6}$/.test(otp)) {
                    showError('otp', 'otp-error', 'Mã OTP phải gồm đúng 6 chữ số!');
                }

                if (!newPass) {
                    showError('newPassword', 'newPassword-error', 'Vui lòng nhập mật khẩu mới!');
                } else if (newPass.length < 6) {
                    showError('newPassword', 'newPassword-error', 'Mật khẩu mới phải có tối thiểu 6 ký tự!');
                }

                if (!confirmPass) {
                    showError('confirmPassword', 'confirmPassword-error', 'Vui lòng nhập xác nhận mật khẩu!');
                } else if (newPass !== confirmPass) {
                    showError('confirmPassword', 'confirmPassword-error', 'Mật khẩu xác nhận không khớp với mật khẩu mới!');
                }

                if (!valid) {
                    e.preventDefault();
                }
            });
        </script>

        <div class="footer-links">
            Quay lại trang <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
</body>
</html>
