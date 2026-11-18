package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
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

        if (uri.contains("/admin/video/add")) {
            List<User> userList = userService.findAll();
            req.setAttribute("userList", userList);
            req.getRequestDispatcher(Constant.Path.VIDEO_ADD).forward(req, resp);
        } else if (uri.contains("/admin/video/edit")) {
            String videoId = req.getParameter("id");
            Video video = videoService.findById(videoId);
            List<User> userList = userService.findAll();
            req.setAttribute("video", video);
            req.setAttribute("userList", userList);
            req.getRequestDispatcher(Constant.Path.VIDEO_EDIT).forward(req, resp);
        } else if (uri.contains("/admin/video/delete")) {
            String videoId = req.getParameter("id");
            try {
                videoService.delete(videoId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        } else {
            // Danh sách Video (/admin/videos hoặc /videos)
            String keyword = req.getParameter("keyword");
            List<Video> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = videoService.searchByTitle(keyword.trim());
                req.setAttribute("keyword", keyword.trim());
            } else {
                list = videoService.findAll();
            }
            req.setAttribute("videoList", list);
            req.getRequestDispatcher(Constant.Path.VIDEO_LIST).forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

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

            int userId = 0;
            try {
                userId = Integer.parseInt(req.getParameter("userId"));
            } catch (Exception ignored) {
            }

            // Xử lý upload ảnh poster hoặc dùng link URL
            String poster = handlePosterUpload(req, posterUrl);

            // Tìm đối tượng User chủ sở hữu video (mối quan hệ 1-N)
            User user = null;
            if (userId > 0) {
                user = userService.findById(userId);
            }
            if (user == null) {
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute("account") != null) {
                    user = (User) session.getAttribute("account");
                }
            }
            if (user == null) {
                List<User> allUsers = userService.findAll();
                if (!allUsers.isEmpty()) {
                    user = allUsers.get(0);
                }
            }

            Video video = new Video(videoId, title, description, poster, views, active, user);
            videoService.insert(video);

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

            int userId = 0;
            try {
                userId = Integer.parseInt(req.getParameter("userId"));
            } catch (Exception ignored) {
            }

            Video existing = videoService.findById(videoId);

            String poster = handlePosterUpload(req, posterUrl);
            if ((poster == null || poster.trim().isEmpty()) && existing != null) {
                poster = existing.getPoster();
            }

            User user = (userId > 0) ? userService.findById(userId) : (existing != null ? existing.getUser() : null);

            Video video = new Video(videoId, title, description, poster, views, active, user);
            videoService.update(video);

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

                    // Lưu vào thư mục /uploads của webapp để truy cập trực tiếp
                    String uploadPath = req.getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    part.write(uploadPath + File.separator + fileName);

                    // Đồng thời lưu vào D:/upload nếu có thể
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
