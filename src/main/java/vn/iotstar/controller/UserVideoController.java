package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/video", "/video/detail" })
public class UserVideoController extends HttpServlet {

    private final IVideoService videoService = new VideoServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("account") : null;

        // XỬ LÝ XEM CHI TIẾT VIDEO (/video/detail)
        if (uri.contains("/video/detail")) {
            String videoId = req.getParameter("id");
            if (videoId == null || videoId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/video");
                return;
            }

            // Tải thông tin video và tăng lượt xem (Views + 1) - Không cần đăng nhập
            Video video = videoService.findById(videoId.trim());
            if (video == null) {
                resp.sendRedirect(req.getContextPath() + "/video");
                return;
            }

            try {
                video.setViews(video.getViews() + 1);
                videoService.update(video);
            } catch (Exception ignored) {
            }

            List<Video> relatedVideos = videoService.findTop10Latest();

            req.setAttribute("video", video);
            req.setAttribute("relatedVideos", relatedVideos);
            req.getRequestDispatcher("/views/video-detail.jsp").include(req, resp);
            return;
        }

        // XỬ LÝ TRANG DANH SÁCH VIDEO (/video)
        // 1. Xác định User cần xem video (nếu có tham số ?userId= thì ưu tiên, nếu không thì lấy user đang đăng nhập)
        String userIdParam = req.getParameter("userId");
        Integer targetUserId = null;

        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                int parsedId = Integer.parseInt(userIdParam.trim());
                if (parsedId > 0) {
                    targetUserId = parsedId;
                }
            } catch (Exception ignored) {
            }
        } else if (loggedInUser != null) {
            // Mặc định hiển thị tất cả video của chính User đang đăng nhập
            targetUserId = loggedInUser.getId();
        }

        // 2. Phân trang 6 sản phẩm/trang
        int pageSize = 6;
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
                if (page < 1) {
                    page = 1;
                }
            } catch (Exception ignored) {
            }
        }

        List<Video> videoList;
        int totalVideos;
        User targetUser = null;

        if (targetUserId != null) {
            targetUser = userService.findById(targetUserId);
            videoList = videoService.findByUserId(targetUserId, page, pageSize);
            totalVideos = videoService.countByUserId(targetUserId);
        } else {
            // Khách chưa đăng nhập và không chọn user -> xem tất cả video hoạt động
            videoList = videoService.findAllActivePaginated(page, pageSize);
            totalVideos = videoService.countActive();
        }

        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        if (page > totalPages && totalVideos > 0) {
            page = totalPages;
            if (targetUserId != null) {
                videoList = videoService.findByUserId(targetUserId, page, pageSize);
            } else {
                videoList = videoService.findAllActivePaginated(page, pageSize);
            }
        }

        List<User> userList = userService.findAll();

        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("targetUserId", targetUserId);
        req.setAttribute("targetUser", targetUser);
        req.setAttribute("userList", userList);

        req.getRequestDispatcher("/views/user-video.jsp").include(req, resp);
    }
}

