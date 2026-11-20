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
        resp.setContentType("text/html; charset=UTF-8");
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
            req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);

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
            req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);

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
            req.getRequestDispatcher(Constant.Path.VIDEO_LIST).include(req, resp);
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
            String viewsParam = req.getParameter("views");
            String activeParam = req.getParameter("active");
            String userIdParam = req.getParameter("userId");

            // Lưu dữ liệu để repopulate khi có lỗi validation
            req.setAttribute("videoId", videoId != null ? videoId.trim() : "");
            req.setAttribute("title", title != null ? title.trim() : "");
            req.setAttribute("description", description != null ? description.trim() : "");
            req.setAttribute("posterUrl", posterUrl != null ? posterUrl.trim() : "");
            req.setAttribute("views", viewsParam != null ? viewsParam.trim() : "0");
            req.setAttribute("active", activeParam != null ? activeParam.trim() : "1");
            req.setAttribute("chosenUserId", userIdParam != null ? userIdParam.trim() : "");
            req.setAttribute("isAdmin", isAdmin);

            // 1. VALIDATION MÃ VIDEO (Video ID)
            if (videoId == null || videoId.trim().isEmpty()) {
                req.setAttribute("error", "Mã video (Video ID) không được để trống!");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            videoId = videoId.trim();
            if (!videoId.matches("^[a-zA-Z0-9_-]{2,50}$")) {
                req.setAttribute("error", "Mã video phải từ 2 đến 50 ký tự, chỉ gồm chữ cái, chữ số, gạch nối (-), gạch dưới (_), không chứa dấu tiếng Việt và khoảng trắng!");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            // Kiểm tra trùng lặp khóa chính trong CSDL
            if (videoService.findById(videoId) != null) {
                req.setAttribute("error", "Mã video '" + videoId + "' đã tồn tại trong hệ thống! Vui lòng chọn mã khác.");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            // 2. VALIDATION TIÊU ĐỀ (Title)
            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Tiêu đề video không được để trống!");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            title = title.trim();
            if (title.length() < 3) {
                req.setAttribute("error", "Tiêu đề video phải có tối thiểu 3 ký tự!");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            if (title.length() > 500) {
                req.setAttribute("error", "Tiêu đề video không được vượt quá 500 ký tự!");
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                return;
            }

            // 3. VALIDATION LƯỢT XEM (Views)
            int views = 0;
            if (viewsParam != null && !viewsParam.trim().isEmpty()) {
                try {
                    views = Integer.parseInt(viewsParam.trim());
                    if (views < 0) {
                        req.setAttribute("error", "Số lượt xem (Views) phải là số nguyên không âm (>= 0)!");
                        if (isAdmin) req.setAttribute("userList", userService.findAll());
                        req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                        return;
                    }
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Số lượt xem (Views) không hợp lệ, phải là số nguyên!");
                    if (isAdmin) req.setAttribute("userList", userService.findAll());
                    req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                    return;
                }
            }

            // 4. VALIDATION TRẠNG THÁI (Active)
            int active = 1;
            if (activeParam != null && !activeParam.trim().isEmpty()) {
                try {
                    active = Integer.parseInt(activeParam.trim());
                    if (active != 0 && active != 1) {
                        active = 1;
                    }
                } catch (Exception ignored) {
                    active = 1;
                }
            }

            // 5. VALIDATION FILE UPLOAD (Định dạng ảnh)
            try {
                Part part = req.getPart("posterFile");
                if (part != null && part.getSize() > 0) {
                    String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString().toLowerCase();
                    if (!submittedFileName.matches(".*\\.(jpg|jpeg|png|gif|webp)$")) {
                        req.setAttribute("error", "File ảnh tải lên không đúng định dạng! Chỉ chấp nhận: .jpg, .jpeg, .png, .gif, .webp.");
                        if (isAdmin) req.setAttribute("userList", userService.findAll());
                        req.getRequestDispatcher(Constant.Path.VIDEO_ADD).include(req, resp);
                        return;
                    }
                }
            } catch (Exception ignored) {
            }

            // Xác định User sở hữu video:
            User owner = loggedInUser;
            if (isAdmin && userIdParam != null && !userIdParam.trim().isEmpty()) {
                try {
                    int chosenUserId = Integer.parseInt(userIdParam.trim());
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

            session.setAttribute("flashMessage", "Đã thêm video mới '" + title + "' thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (uri.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String posterUrl = req.getParameter("posterUrl");
            String viewsParam = req.getParameter("views");
            String activeParam = req.getParameter("active");
            String userIdParam = req.getParameter("userId");

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

            // 1. VALIDATION TIÊU ĐỀ
            if (title == null || title.trim().isEmpty()) {
                req.setAttribute("error", "Tiêu đề video không được để trống!");
                req.setAttribute("video", existing);
                req.setAttribute("isAdmin", isAdmin);
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                return;
            }

            title = title.trim();
            if (title.length() < 3) {
                req.setAttribute("error", "Tiêu đề video phải có tối thiểu 3 ký tự!");
                req.setAttribute("video", existing);
                req.setAttribute("isAdmin", isAdmin);
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                return;
            }

            if (title.length() > 500) {
                req.setAttribute("error", "Tiêu đề video không được vượt quá 500 ký tự!");
                req.setAttribute("video", existing);
                req.setAttribute("isAdmin", isAdmin);
                if (isAdmin) req.setAttribute("userList", userService.findAll());
                req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                return;
            }

            // 2. VALIDATION LƯỢT XEM
            int views = existing.getViews();
            if (viewsParam != null && !viewsParam.trim().isEmpty()) {
                try {
                    views = Integer.parseInt(viewsParam.trim());
                    if (views < 0) {
                        req.setAttribute("error", "Số lượt xem (Views) phải là số nguyên không âm (>= 0)!");
                        req.setAttribute("video", existing);
                        req.setAttribute("isAdmin", isAdmin);
                        if (isAdmin) req.setAttribute("userList", userService.findAll());
                        req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                        return;
                    }
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Số lượt xem (Views) không hợp lệ, phải là số nguyên!");
                    req.setAttribute("video", existing);
                    req.setAttribute("isAdmin", isAdmin);
                    if (isAdmin) req.setAttribute("userList", userService.findAll());
                    req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                    return;
                }
            }

            // 3. VALIDATION TRẠNG THÁI
            int active = 1;
            if (activeParam != null && !activeParam.trim().isEmpty()) {
                try {
                    active = Integer.parseInt(activeParam.trim());
                    if (active != 0 && active != 1) {
                        active = 1;
                    }
                } catch (Exception ignored) {
                    active = 1;
                }
            }

            // 4. VALIDATION FILE UPLOAD (Định dạng ảnh)
            try {
                Part part = req.getPart("posterFile");
                if (part != null && part.getSize() > 0) {
                    String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString().toLowerCase();
                    if (!submittedFileName.matches(".*\\.(jpg|jpeg|png|gif|webp)$")) {
                        req.setAttribute("error", "File ảnh tải lên không đúng định dạng! Chỉ chấp nhận: .jpg, .jpeg, .png, .gif, .webp.");
                        req.setAttribute("video", existing);
                        req.setAttribute("isAdmin", isAdmin);
                        if (isAdmin) req.setAttribute("userList", userService.findAll());
                        req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).include(req, resp);
                        return;
                    }
                }
            } catch (Exception ignored) {
            }

            String poster = handlePosterUpload(req, posterUrl);
            if ((poster == null || poster.trim().isEmpty()) && existing != null) {
                poster = existing.getPoster();
            }

            // Quyền sở hữu:
            User owner = existing.getUser();
            if (isAdmin && userIdParam != null && !userIdParam.trim().isEmpty()) {
                try {
                    int chosenUserId = Integer.parseInt(userIdParam.trim());
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

            session.setAttribute("flashMessage", "Đã cập nhật video '" + videoId + "' thành công!");
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
