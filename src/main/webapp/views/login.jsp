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
        .login-container { max-width: 420px; margin: 50px auto; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); padding: 30px; }
        h2 { text-align: center; color: #333; margin-bottom: 24px; font-weight: 600; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; color: #495057; font-size: 14px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        .form-control:focus { outline: none; border-color: #007bff; }
        .form-check { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; font-size: 14px; }
        .form-check label { display: flex; align-items: center; gap: 6px; cursor: pointer; color: #495057; }
        .btn-primary { width: 100%; padding: 12px; background-color: #007bff; border: none; border-radius: 6px; color: white; font-weight: 600; font-size: 16px; cursor: pointer; transition: background-color 0.2s; }
        .btn-primary:hover { background-color: #0056b3; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6c757d; }
        .footer-links a { color: #007bff; text-decoration: none; font-weight: 500; }
        .footer-links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="topbar.jsp" />

    <div class="login-container">
        <h2>Đăng Nhập Vào Hệ Thống</h2>

        <c:if test="${alert != null}">
            <div class="alert-danger">${alert}</div>
        </c:if>
        <c:if test="${message != null}">
            <div style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center;">${message}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Tài khoản</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập tài khoản" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>

            <div class="form-check">
                <label for="remember" style="cursor: pointer;">
                    <input type="checkbox" name="remember" id="remember" value="on"> Nhớ tôi (Cookie)
                </label>
            </div>

            <button type="submit" class="btn-primary">Đăng nhập</button>
        </form>

        <div class="footer-links">
            Nếu bạn chưa có tài khoản trên hệ thống, hãy <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
        </div>
    </div>
</body>
</html>
