package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
@WebServlet(urlPatterns = {
    "/admin/videos",
    "/admin/video/add",
    "/admin/video/insert",
    "/admin/video/edit",
    "/admin/video/update",
    "/admin/video/delete",
    "/videos"
})
public class VideoController extends HttpServlet {

    private final IVideoService videoService = new VideoServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("account") : null;

        // BẮT BUỘC ĐĂNG NHẬP MỚI ĐƯỢC VÀO QUẢN LÝ VIDEO
        if (loggedInUser == null) {
            String alertMsg = URLEncoder.encode("Vui lòng đăng nhập để quản lý video!", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?alert=" + alertMsg);
            return;
        }

        boolean isAdmin = (loggedInUser.getRoleid() == 1);
        req.setAttribute("isAdmin", isAdmin);

        // Lấy và xóa flash message nếu có
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }
        if (session.getAttribute("flashMessage") != null) {
            req.setAttribute("flashMessage", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
        }

        if (uri.contains("/admin/video/add")) {
            if (isAdmin) {
                List<User> userList = userService.findAll();
                req.setAttribute("userList", userList);
            }
            req.getRequestDispatcher(Constant.Path.VIDEO_ADD).forward(req, resp);

        } else if (uri.contains("/admin/video/edit")) {
            String videoId = req.getParameter("id");
            Video video = videoService.findById(videoId);
            if (video == null) {
                session.setAttribute("flashError", "Không tìm thấy video cần sửa!");
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            // KIỂM TRA QUYỀN HẠN: Chỉ Admin hoặc chính chủ video mới được sửa!
            if (!isAdmin && (video.getUser() == null || video.getUser().getId() != loggedInUser.getId())) {
                session.setAttribute("flashError", "Bạn chỉ được phép chỉnh sửa video do chính bạn tạo!");
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            if (isAdmin) {
                List<User> userList = userService.findAll();
                req.setAttribute("userList", userList);
            }
            req.setAttribute("video", video);
            req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).forward(req, resp);

        } else if (uri.contains("/admin/video/delete")) {
            String videoId = req.getParameter("id");
            Video video = videoService.findById(videoId);
            if (video != null) {
                // KIỂM TRA QUYỀN HẠN: Chỉ Admin hoặc chính chủ video mới được xóa!
                if (!isAdmin && (video.getUser() == null || video.getUser().getId() != loggedInUser.getId())) {
                    session.setAttribute("flashError", "Bạn chỉ được phép xóa video do chính bạn tạo!");
                    resp.sendRedirect(req.getContextPath() + "/admin/videos");
                    return;
                }
                try {
                    videoService.delete(videoId);
                    session.setAttribute("flashMessage", "Đã xóa video " + videoId + " thành công!");
                } catch (Exception e) {
                    session.setAttribute("flashError", "Không thể xóa video: " + e.getMessage());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else {
            // DANH SÁCH VIDEO (/admin/videos hoặc /videos)
            String keyword = req.getParameter("keyword");
            List<Video> list;

            if (isAdmin) {
                // Admin xem được tất cả video của toàn hệ thống
                if (keyword != null && !keyword.trim().isEmpty()) {
                    list = videoService.searchByTitle(keyword.trim());
                    req.setAttribute("keyword", keyword.trim());
                } else {
                    list = videoService.findAll();
                }
            } else {
                // User thường (như user 'tin') CHỈ XEM VIDEO CỦA CHÍNH MÌNH
                if (keyword != null && !keyword.trim().isEmpty()) {
                    list = videoService.searchByTitleAndUserId(keyword.trim(), loggedInUser.getId());
                    req.setAttribute("keyword", keyword.trim());
                } else {
                    list = videoService.findByUserId(loggedInUser.getId());
                }
            }

            req.setAttribute("videoList", list);
            req.getRequestDispatcher(Constant.Path.VIDEO_LIST).forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("account") : null;

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean isAdmin = (loggedInUser.getRoleid() == 1);

        if (uri.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("posterUrl");
            int views = 0;
            try {
                views = Integer.parseInt(req.getParameter("views"));
            } catch (Exception ignored) {
            }

            int active = 1;
            try {
                active = Integer.parseInt(req.getParameter("active"));
            } catch (Exception ignored) {
            }

            // Xác định User sở hữu video:
            // Admin có thể chọn user khác; User thường luôn gán cho chính mình!
            User owner = loggedInUser;
            if (isAdmin) {
                try {
                    int chosenUserId = Integer.parseInt(req.getParameter("userId"));
                    if (chosenUserId > 0) {
                        User chosenUser = userService.findById(chosenUserId);
                        if (chosenUser != null) {
                            owner = chosenUser;
                        }
                    }
                } catch (Exception ignored) {
                }
            }

            String poster = handlePosterUpload(req, posterUrl);

            Video video = new Video(videoId, title, description, poster, views, active, owner);
            videoService.insert(video);

            session.setAttribute("flashMessage", "Đã thêm video mới thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (uri.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("posterUrl");
            int views = 0;
            try {
                views = Integer.parseInt(req.getParameter("views"));
            } catch (Exception ignored) {
            }

            int active = 1;
            try {
                active = Integer.parseInt(req.getParameter("active"));
            } catch (Exception ignored) {
            }

            Video existing = videoService.findById(videoId);
            if (existing == null) {
                session.setAttribute("flashError", "Không tìm thấy video để cập nhật!");
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            // KIỂM TRA QUYỀN HẠN: Chỉ Admin hoặc chính chủ video mới được sửa!
            if (!isAdmin && (existing.getUser() == null || existing.getUser().getId() != loggedInUser.getId())) {
                session.setAttribute("flashError", "Bạn chỉ được phép cập nhật video của chính bạn!");
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            String poster = handlePosterUpload(req, posterUrl);
            if ((poster == null || poster.trim().isEmpty()) && existing != null) {
                poster = existing.getPoster();
            }

            // Quyền sở hữu:
            User owner = existing.getUser();
            if (isAdmin) {
                try {
                    int chosenUserId = Integer.parseInt(req.getParameter("userId"));
                    if (chosenUserId > 0) {
                        User chosenUser = userService.findById(chosenUserId);
                        if (chosenUser != null) {
                            owner = chosenUser;
                        }
                    }
                } catch (Exception ignored) {
                }
            }

            Video video = new Video(videoId, title, description, poster, views, active, owner);
            videoService.update(video);

            session.setAttribute("flashMessage", "Đã cập nhật video " + videoId + " thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    private String handlePosterUpload(HttpServletRequest req, String fallbackUrl) {
        try {
            Part part = req.getPart("posterFile");
            if (part != null && part.getSize() > 0) {
                String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                    String ext = "";
                    int dotIdx = submittedFileName.lastIndexOf('.');
                    if (dotIdx > 0) {
                        ext = submittedFileName.substring(dotIdx);
                    }
                    String fileName = System.currentTimeMillis() + ext;

                    String uploadPath = req.getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    part.write(uploadPath + File.separator + fileName);

                    try {
                        File backupDir = new File(Constant.DIR);
                        if (!backupDir.exists()) {
                            backupDir.mkdirs();
                        }
                        part.write(Constant.DIR + File.separator + fileName);
                    } catch (Exception ignored) {
                    }

                    return fileName;
                }
            }
        } catch (Exception ignored) {
        }
        return fallbackUrl != null ? fallbackUrl.trim() : null;
    }
}