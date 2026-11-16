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

import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String emailOrUsername = req.getParameter("emailOrUsername");
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập tên tài khoản hoặc email!");
            req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
            return;
        }

        String input = emailOrUsername.trim();
        User user = input.contains("@") ? userService.findByEmail(input) : userService.get(input);

        if (user == null) {
            req.setAttribute("alert", "Không tìm thấy tài khoản tương ứng với thông tin đã nhập!");
            req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
            return;
        }

        // Gửi mã OTP xác nhận đặt lại mật khẩu
        boolean success = userService.sendForgotPasswordOtp(user.getEmail());
        if (success) {
            HttpSession session = req.getSession(true);
            session.setAttribute("resetEmail", user.getEmail());
            session.setAttribute("demoResetOtp", EmailUtil.getLastOtp());

            String encodedEmail = URLEncoder.encode(user.getEmail(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + encodedEmail);
        } else {
            req.setAttribute("alert", "Có lỗi xảy ra khi tạo mã OTP. Vui lòng thử lại!");
            req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
        }
    }
}
