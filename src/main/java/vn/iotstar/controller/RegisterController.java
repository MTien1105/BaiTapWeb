package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Check cookie Remember Me
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(Constant.COOKIE_REMEMBER)) {
                    resp.sendRedirect(req.getContextPath() + "/waiting");
                    return;
                }
            }
        }
        req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        UserService service = new UserServiceImpl();
        String alertMsg = "";

        if (username == null || password == null || email == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty()) {
            alertMsg = "Vui lòng nhập đầy đủ các thông tin bắt buộc!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        if (service.checkExistEmail(email.trim())) {
            alertMsg = "Email này đã được sử dụng!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        if (service.checkExistUsername(username.trim())) {
            alertMsg = "Tên tài khoản này đã tồn tại!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && service.checkExistPhone(phone.trim())) {
            alertMsg = "Số điện thoại này đã được sử dụng!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        // 1. Sinh mã OTP kích hoạt tài khoản
        String otp = EmailUtil.generateOtp();

        // 2. Lưu tài khoản mới vào cơ sở dữ liệu với status = 0 (chưa kích hoạt) và mật khẩu đã hash
        boolean isSuccess = service.register(username.trim(), password, email.trim(), fullname.trim(), phone != null ? phone.trim() : null, otp);

        if (isSuccess) {
            // 3. Gửi email chứa mã OTP đến hòm thư người dùng
            String emailContent = EmailUtil.buildActivationEmail(fullname, otp);
            EmailUtil.sendEmail(email.trim(), "Mã xác thực kích hoạt tài khoản mới", emailContent);

            // 4. Lưu email vào Session và chuyển hướng đến trang nhập mã OTP
            HttpSession session = req.getSession(true);
            session.setAttribute("otpEmail", email.trim());
            session.setAttribute("demoOtp", otp);

            String encodedEmail = URLEncoder.encode(email.trim(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/verify-code?email=" + encodedEmail);
        } else {
            alertMsg = "Đăng ký không thành công do lỗi hệ thống! Vui lòng thử lại.";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
        }
    }
}
