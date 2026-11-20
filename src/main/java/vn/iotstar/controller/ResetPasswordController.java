package vn.iotstar.controller;

import java.io.IOException;

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
@WebServlet(urlPatterns = "/reset-password")
public class ResetPasswordController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        HttpSession session = req.getSession(false);
        if ((email == null || email.trim().isEmpty()) && session != null) {
            email = (String) session.getAttribute("resetEmail");
        }

        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        req.setAttribute("email", email);
        if (session != null && session.getAttribute("demoResetOtp") != null) {
            req.setAttribute("demoResetOtp", session.getAttribute("demoResetOtp"));
        } else if (EmailUtil.getLastOtp() != null && !EmailUtil.getLastOtp().isEmpty()) {
            req.setAttribute("demoResetOtp", EmailUtil.getLastOtp());
        }

        req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        req.setAttribute("email", email);
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("demoResetOtp") != null) {
            req.setAttribute("demoResetOtp", session.getAttribute("demoResetOtp"));
        }

        if (email == null || otp == null || newPassword == null || confirmPassword == null ||
                email.trim().isEmpty() || otp.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ tất cả các trường thông tin!");
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
            return;
        }

        // Validate OTP định dạng 6 chữ số
        if (!otp.trim().matches("^[0-9]{6}$")) {
            req.setAttribute("alert", "Mã OTP xác thực phải gồm đúng 6 chữ số!");
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("alert", "Mật khẩu mới phải có tối thiểu 6 ký tự!");
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu mới và mật khẩu xác nhận không khớp nhau!");
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
            return;
        }

        boolean success = userService.resetPasswordWithOtp(email.trim(), otp.trim(), newPassword);
        if (success) {
            if (session != null) {
                session.removeAttribute("resetEmail");
                session.removeAttribute("demoResetOtp");
                session.setAttribute("flashMessage", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn!");
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).include(req, resp);
        }
    }
}

