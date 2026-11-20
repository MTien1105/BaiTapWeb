package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.PasswordUtil;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {

    private final UserService service = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Kiểm tra cookie Remember Me
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(Constant.COOKIE_REMEMBER)) {
                    session = req.getSession(true);
                    session.setAttribute("username", cookie.getValue());
                    User user = service.get(cookie.getValue());
                    if (user != null && user.getStatus() == 1) {
                        session.setAttribute("account", user);
                        resp.sendRedirect(req.getContextPath() + "/waiting");
                        return;
                    }
                }
            }
        }

        // Nhận tham số điều hướng sau đăng nhập nếu có
        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            req.setAttribute("redirect", redirect.trim());
        }

        String alertParam = req.getParameter("alert");
        if (alertParam != null && !alertParam.trim().isEmpty()) {
            req.setAttribute("alert", alertParam.trim());
        }

        // Lấy thông báo flashMessage từ session nếu có (ví dụ: sau khi kích hoạt hoặc đổi mật khẩu)
        if (session != null && session.getAttribute("flashMessage") != null) {
            req.setAttribute("message", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
        }

        req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");
        String redirect = req.getParameter("redirect");
        boolean isRememberMe = (remember != null);

        if (redirect != null && !redirect.trim().isEmpty()) {
            req.setAttribute("redirect", redirect.trim());
        }

        // Giữ lại username đã nhập để người dùng không phải gõ lại
        req.setAttribute("username", username != null ? username.trim() : "");

        // SERVER-SIDE VALIDATION
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập tên tài khoản!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập mật khẩu!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        if (username.trim().length() < 3) {
            req.setAttribute("alert", "Tên tài khoản phải có ít nhất 3 ký tự!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("alert", "Mật khẩu phải có ít nhất 6 ký tự!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        User user = service.get(username.trim());

        // 1. Kiểm tra tài khoản tồn tại và kiểm tra mật khẩu đã hash bằng BCrypt
        if (user == null || !PasswordUtil.checkPassword(password, user.getPassWord())) {
            req.setAttribute("alert", "Tên tài khoản hoặc mật khẩu không chính xác!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        // 2. Kiểm tra tài khoản đã kích hoạt qua OTP hay chưa (status == 1)
        if (user.getStatus() == 0) {
            req.setAttribute("unactivatedEmail", user.getEmail());
            req.setAttribute("alert", "Tài khoản chưa được kích hoạt qua mã OTP!");
            req.getRequestDispatcher(Constant.Path.LOGIN).include(req, resp);
            return;
        }

        // 3. Đăng nhập thành công -> Lưu session
        HttpSession session = req.getSession(true);
        session.setAttribute("account", user);
        session.setAttribute("username", user.getUserName());

        // 4. Nếu người dùng chọn "Nhớ tôi" -> Tạo cookie
        if (isRememberMe) {
            saveRememberMe(resp, username.trim());
        }

        if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login") && !redirect.contains("logout")) {
            resp.sendRedirect(redirect.trim());
        } else {
            resp.sendRedirect(req.getContextPath() + "/waiting");
        }
    }

    private void saveRememberMe(HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, username);
        cookie.setMaxAge(30 * 60); // 30 phút
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}

