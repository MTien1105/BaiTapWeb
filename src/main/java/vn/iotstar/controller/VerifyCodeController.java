package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/verify-code", "/resend-otp" })
public class VerifyCodeController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Xử lý gửi lại mã OTP
        if ("/resend-otp".equals(path)) {
            String email = req.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    email = (String) session.getAttribute("otpEmail");
                }
            }
            if (email != null && !email.trim().isEmpty()) {
                boolean resent = userService.resendOtp(email.trim());
                if (resent) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("demoOtp", EmailUtil.getLastOtp());
                    String encodedEmail = URLEncoder.encode(email.trim(), StandardCharsets.UTF_8);
                    resp.sendRedirect(req.getContextPath() + "/verify-code?email=" + encodedEmail + "&message=resent");
                    return;
                }
            }
            resp.sendRedirect(req.getContextPath() + "/verify-code");
            return;
        }

        // GET /verify-code: Hiển thị form nhập OTP
        String email = req.getParameter("email");
        HttpSession session = req.getSession(false);
        if ((email == null || email.trim().isEmpty()) && session != null) {
            email = (String) session.getAttribute("otpEmail");
        }

        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String message = req.getParameter("message");
        if ("resent".equals(message)) {
            req.setAttribute("successMsg", "Mã OTP mới đã được gửi lại vào email của bạn!");
        }

        req.setAttribute("email", email);
        if (session != null && session.getAttribute("demoOtp") != null) {
            req.setAttribute("demoOtp", session.getAttribute("demoOtp"));
        } else if (EmailUtil.getLastOtp() != null && !EmailUtil.getLastOtp().isEmpty()) {
            req.setAttribute("demoOtp", EmailUtil.getLastOtp());
        }

        req.getRequestDispatcher(Constant.Path.VERIFY_CODE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");

        if (email == null || email.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            req.setAttribute("email", email);
            req.setAttribute("alert", "Vui lòng nhập đầy đủ mã xác nhận OTP!");
            req.getRequestDispatcher(Constant.Path.VERIFY_CODE).forward(req, resp);
            return;
        }

        // Validate định dạng OTP 6 chữ số
        if (!otp.trim().matches("^[0-9]{6}$")) {
            req.setAttribute("email", email.trim());
            req.setAttribute("alert", "Mã xác thực OTP phải gồm đúng 6 chữ số!");
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("demoOtp") != null) {
                req.setAttribute("demoOtp", session.getAttribute("demoOtp"));
            }
            req.getRequestDispatcher(Constant.Path.VERIFY_CODE).forward(req, resp);
            return;
        }

        boolean verified = userService.verifyOtp(email.trim(), otp.trim());
        if (verified) {
            // Xóa thông tin tạm trong session
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("otpEmail");
                session.removeAttribute("demoOtp");
                session.setAttribute("flashMessage", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("email", email.trim());
            req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn! Vui lòng kiểm tra lại.");
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("demoOtp") != null) {
                req.setAttribute("demoOtp", session.getAttribute("demoOtp"));
            }
            req.getRequestDispatcher(Constant.Path.VERIFY_CODE).forward(req, resp);
        }
    }
}
