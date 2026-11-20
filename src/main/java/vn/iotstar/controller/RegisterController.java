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
        req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        // Giữ lại dữ liệu đã nhập để trả về form nếu có lỗi
        req.setAttribute("username", username != null ? username.trim() : "");
        req.setAttribute("fullname", fullname != null ? fullname.trim() : "");
        req.setAttribute("email", email != null ? email.trim() : "");
        req.setAttribute("phone", phone != null ? phone.trim() : "");

        UserService service = new UserServiceImpl();
        String alertMsg = "";

        // 1. Kiểm tra rỗng các trường bắt buộc
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập tên tài khoản!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (fullname == null || fullname.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập họ và tên!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập địa chỉ email!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập mật khẩu!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        // 2. Validate định dạng tên tài khoản (3-30 ký tự, chữ cái, số hoặc gạch dưới)
        if (!username.trim().matches("^[a-zA-Z0-9_]{3,30}$")) {
            req.setAttribute("alert", "Tên tài khoản chỉ được chứa chữ cái, số và dấu gạch dưới (độ dài 3-30 ký tự, không dấu, không khoảng trắng)!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        // 3. Validate định dạng Email
        String emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
        if (!email.trim().matches(emailRegex)) {
            req.setAttribute("alert", "Địa chỉ email không đúng định dạng hợp lệ (Ví dụ: user@example.com)!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        // 4. Validate định dạng số điện thoại nếu người dùng có nhập
        if (phone != null && !phone.trim().isEmpty()) {
            String phoneRegex = "^(0|\\+84)[3|5|7|8|9][0-9]{8}$";
            if (!phone.trim().matches(phoneRegex)) {
                req.setAttribute("alert", "Số điện thoại không hợp lệ (Phải là số điện thoại Việt Nam gồm 10 chữ số, bắt đầu bằng 03, 05, 07, 08, 09)!");
                req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
                return;
            }
        }

        // 5. Validate độ dài mật khẩu và xác nhận mật khẩu
        if (password.length() < 6) {
            req.setAttribute("alert", "Mật khẩu phải có tối thiểu 6 ký tự!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (confirmPassword != null && !password.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp với mật khẩu đã nhập!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        // 6. Kiểm tra trùng lặp trong cơ sở dữ liệu
        if (service.checkExistUsername(username.trim())) {
            req.setAttribute("alert", "Tên tài khoản này đã được sử dụng bởi người khác!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (service.checkExistEmail(email.trim())) {
            req.setAttribute("alert", "Địa chỉ email này đã được đăng ký trong hệ thống!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && service.checkExistPhone(phone.trim())) {
            req.setAttribute("alert", "Số điện thoại này đã được sử dụng bởi tài khoản khác!");
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
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
            req.getRequestDispatcher(Constant.Path.REGISTER).include(req, resp);
        }
    }
}

