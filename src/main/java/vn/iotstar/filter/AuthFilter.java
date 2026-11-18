package vn.iotstar.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@WebFilter(urlPatterns = { "/home", "/admin/*" })
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        // Nếu chưa có Session nhưng có Cookie Nhớ tôi -> Tự động khôi phục đăng nhập
        if (user == null) {
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (Constant.COOKIE_REMEMBER.equals(cookie.getName())) {
                        String username = cookie.getValue();
                        UserService service = new UserServiceImpl();
                        user = service.get(username);
                        if (user != null) {
                            session = req.getSession(true);
                            session.setAttribute("account", user);
                            session.setAttribute("username", user.getUserName());
                            break;
                        }
                    }
                }
            }
        }

        // Vẫn không có user (cả session lẫn cookie đều không có) -> chuyển hướng về /login
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
