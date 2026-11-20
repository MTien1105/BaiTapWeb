package vn.iotstar.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;

@SuppressWarnings("serial")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
@WebServlet(urlPatterns = {
    "/profile",
    "/profile/verify-email",
    "/profile/resend-otp",
    "/profile/cancel-email-change"
})
public class ProfileController extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("account") : null;

        // Bắt buộc người dùng phải đăng nhập trước khi vào xem hoặc chỉnh sửa Profile
        if (loggedInUser == null) {
            String alertMsg = URLEncoder.encode("Vui lòng đăng nhập để xem thông tin hồ sơ cá nhân!", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?alert=" + alertMsg);
            return;
        }

        // Xử lý hủy yêu cầu đổi email
        if (uri.contains("/profile/cancel-email-change")) {
            session.removeAttribute("pendingNewEmail");
            session.removeAttribute("pendingEmailOtp");
            session.removeAttribute("pendingOtpExpiry");
            session.setAttribute("flashMessage", "Đã hủy yêu cầu thay đổi địa chỉ email.");
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        // Xử lý gửi lại mã OTP xác thực email mới
        if (uri.contains("/profile/resend-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingNewEmail");
            if (pendingEmail != null && !pendingEmail.trim().isEmpty()) {
                String newOtp = EmailUtil.generateOtp();
                session.setAttribute("pendingEmailOtp", newOtp);
                session.setAttribute("pendingOtpExpiry", System.currentTimeMillis() + 10 * 60 * 1000); // 10 phút

                String emailContent = EmailUtil.buildUpdateEmailOtp(loggedInUser.getFullName(), newOtp, pendingEmail);
                EmailUtil.sendEmail(pendingEmail, "Mã xác thực thay đổi Email (Gửi lại)", emailContent);

                session.setAttribute("flashMessage", "Mã OTP mới đã được gửi lại đến email: " + pendingEmail);
            } else {
                session.setAttribute("flashError", "Không tìm thấy yêu cầu thay đổi email đang chờ.");
            }
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        // Lấy lại User mới nhất từ Database để đảm bảo dữ liệu chuẩn
        User freshUser = userService.findById(loggedInUser.getId());
        if (freshUser != null) {
            session.setAttribute("account", freshUser);
            req.setAttribute("user", freshUser);
        } else {
            req.setAttribute("user", loggedInUser);
        }

        // Chuyển Flash Messages từ session sang request attributes
        transferFlashMessages(session, req);

        // Hiển thị view profile (SiteMesh tự động trang trí layout Bootstrap)
        req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("account") : null;

        if (loggedInUser == null) {
            String alertMsg = URLEncoder.encode("Phiên làm việc đã hết hạn, vui lòng đăng nhập lại!", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/login?alert=" + alertMsg);
            return;
        }

        // 1. XỬ LÝ XÁC NHẬN MÃ OTP CẬP NHẬT EMAIL MỚI
        if (uri.contains("/profile/verify-email")) {
            handleVerifyEmailOtp(req, resp, session, loggedInUser);
            return;
        }

        // 2. XỬ LÝ CẬP NHẬT THÔNG TIN HỒ SƠ CHÍNH
        handleUpdateProfile(req, resp, session, loggedInUser);
    }

    /**
     * Xử lý cập nhật thông tin hồ sơ: fullname, phone, avatar (Cloudinary), và kích hoạt gửi OTP nếu email thay đổi
     */
    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User loggedInUser)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        // Lấy lại dữ liệu User mới nhất từ CSDL
        User currentUser = userService.findById(loggedInUser.getId());
        if (currentUser == null) {
            currentUser = loggedInUser;
        }

        // Chuẩn bị User tạm thời để giữ lại giá trị người dùng vừa nhập khi có lỗi validation
        User formUser = new User();
        formUser.setId(currentUser.getId());
        formUser.setUserName(currentUser.getUserName());
        formUser.setFullName(fullName != null ? fullName.trim() : "");
        formUser.setPhone(phone != null ? phone.trim() : "");
        formUser.setEmail(email != null ? email.trim() : "");
        formUser.setAvatar(currentUser.getAvatar());
        formUser.setRoleid(currentUser.getRoleid());
        formUser.setStatus(currentUser.getStatus());
        formUser.setCreatedDate(currentUser.getCreatedDate());

        // ================= VALIDATION FORMS =================
        // 1. Validation Full Name
        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Họ và tên không được để trống!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }
        fullName = fullName.trim();
        if (fullName.length() < 2 || fullName.length() > 100) {
            req.setAttribute("error", "Họ và tên phải có độ dài từ 2 đến 100 ký tự!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        // 2. Validation Phone
        if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Số điện thoại không được để trống!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }
        phone = phone.trim();
        if (!phone.matches("^(0|\\+84)[0-9]{9,10}$")) {
            req.setAttribute("error", "Số điện thoại không đúng định dạng Việt Nam (bắt đầu bằng 0 hoặc +84, gồm 10-11 chữ số)!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }
        if (userService.checkExistPhoneExceptUser(phone, currentUser.getId())) {
            req.setAttribute("error", "Số điện thoại này đã được sử dụng bởi một tài khoản khác trong hệ thống!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        // 3. Validation Email
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Địa chỉ email không được để trống!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }
        email = email.trim();
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")) {
            req.setAttribute("error", "Địa chỉ email không đúng định dạng (vd: user@example.com)!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }
        if (userService.checkExistEmailExceptUser(email, currentUser.getId())) {
            req.setAttribute("error", "Địa chỉ email này đã được sử dụng bởi một tài khoản khác trong hệ thống!");
            req.setAttribute("user", formUser);
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        // 4. Validation & Upload Avatar lên Cloudinary bằng Multipart
        Part avatarPart = null;
        try {
            avatarPart = req.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submittedName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString().toLowerCase();
                if (!submittedName.matches(".*\\.(jpg|jpeg|png|gif|webp)$")) {
                    req.setAttribute("error", "File ảnh tải lên không đúng định dạng! Chỉ chấp nhận file: .jpg, .jpeg, .png, .gif, .webp.");
                    req.setAttribute("user", formUser);
                    transferFlashMessages(session, req);
                    req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
                    return;
                }
                if (avatarPart.getSize() > 5 * 1024 * 1024) {
                    req.setAttribute("error", "Kích thước ảnh đại diện không được vượt quá 5MB!");
                    req.setAttribute("user", formUser);
                    transferFlashMessages(session, req);
                    req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("[ProfileController] Lỗi khi đọc file multipart: " + e.getMessage());
        }

        // ================= CẬP NHẬT DỮ LIỆU VÀ XỬ LÝ UPLOAD CLOUDINARY =================
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);

        // Upload avatar lên Cloudinary nếu có file mới
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String uploadedUrl = CloudinaryUtil.uploadImage(avatarPart, "user_avatars");
            if (uploadedUrl != null && !uploadedUrl.isEmpty()) {
                currentUser.setAvatar(uploadedUrl);
            }
        }

        // Kiểm tra xem người dùng có muốn thay đổi Email hay không
        boolean isEmailChanged = !email.equalsIgnoreCase(currentUser.getEmail());

        if (!isEmailChanged) {
            // Không thay đổi email -> Cập nhật trực tiếp và hoàn tất
            userService.update(currentUser);
            session.setAttribute("account", currentUser);
            session.setAttribute("flashMessage", "Cập nhật thông tin hồ sơ cá nhân thành công!");
            resp.sendRedirect(req.getContextPath() + "/profile");
        } else {
            // Có thay đổi email -> Lưu fullname, phone, avatar trước; khởi tạo gửi OTP xác thực đến email mới
            userService.update(currentUser);
            session.setAttribute("account", currentUser);

            String otp = EmailUtil.generateOtp();
            session.setAttribute("pendingNewEmail", email);
            session.setAttribute("pendingEmailOtp", otp);
            session.setAttribute("pendingOtpExpiry", System.currentTimeMillis() + 10 * 60 * 1000); // 10 phút

            // Gửi email chứa mã OTP đến địa chỉ email mới
            String emailContent = EmailUtil.buildUpdateEmailOtp(currentUser.getFullName(), otp, email);
            EmailUtil.sendEmail(email, "Mã xác thực cập nhật Email mới", emailContent);

            session.setAttribute("flashNotice", "Thông tin họ tên, số điện thoại và ảnh đại diện đã được lưu thành công. "
                    + "Hệ thống đã gửi mã OTP xác nhận đến email mới: " + email + ". Vui lòng nhập mã OTP để hoàn tất thay đổi email!");
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    /**
     * Xử lý xác nhận OTP để cập nhật địa chỉ Email mới vào CSDL
     */
    private void handleVerifyEmailOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User loggedInUser)
            throws ServletException, IOException {

        String otpInput = req.getParameter("otp");
        String pendingEmail = (String) session.getAttribute("pendingNewEmail");
        String expectedOtp = (String) session.getAttribute("pendingEmailOtp");
        Long expiry = (Long) session.getAttribute("pendingOtpExpiry");

        if (pendingEmail == null || expectedOtp == null) {
            session.setAttribute("flashError", "Không có yêu cầu thay đổi email nào đang chờ xác nhận!");
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        // Validation OTP input
        if (otpInput == null || otpInput.trim().isEmpty()) {
            req.setAttribute("otpError", "Vui lòng nhập mã OTP gồm 6 chữ số!");
            req.setAttribute("user", userService.findById(loggedInUser.getId()));
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        otpInput = otpInput.trim();

        // Kiểm tra thời hạn OTP
        if (expiry != null && System.currentTimeMillis() > expiry) {
            req.setAttribute("otpError", "Mã OTP đã hết hiệu lực (quá 10 phút). Vui lòng nhấn 'Gửi Lại Mã OTP' để nhận mã mới!");
            req.setAttribute("user", userService.findById(loggedInUser.getId()));
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        // So khớp mã OTP
        if (!otpInput.equals(expectedOtp.trim())) {
            req.setAttribute("otpError", "Mã OTP không chính xác. Vui lòng kiểm tra lại hộp thư email!");
            req.setAttribute("user", userService.findById(loggedInUser.getId()));
            transferFlashMessages(session, req);
            req.getRequestDispatcher(Constant.Path.PROFILE).include(req, resp);
            return;
        }

        // Mã OTP chính xác -> Cập nhật email mới vào User trong CSDL
        User currentUser = userService.findById(loggedInUser.getId());
        if (currentUser != null) {
            currentUser.setEmail(pendingEmail);
            userService.update(currentUser);
            session.setAttribute("account", currentUser);

            // Xóa session tạm
            session.removeAttribute("pendingNewEmail");
            session.removeAttribute("pendingEmailOtp");
            session.removeAttribute("pendingOtpExpiry");

            session.setAttribute("flashMessage", "Chúc mừng! Bạn đã cập nhật địa chỉ email mới (" + pendingEmail + ") thành công!");
        } else {
            session.setAttribute("flashError", "Lỗi: Không tìm thấy tài khoản để cập nhật!");
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }

    private void transferFlashMessages(HttpSession session, HttpServletRequest req) {
        if (session.getAttribute("flashMessage") != null) {
            req.setAttribute("flashMessage", session.getAttribute("flashMessage"));
            session.removeAttribute("flashMessage");
        }
        if (session.getAttribute("flashError") != null) {
            req.setAttribute("flashError", session.getAttribute("flashError"));
            session.removeAttribute("flashError");
        }
        if (session.getAttribute("flashNotice") != null) {
            req.setAttribute("flashNotice", session.getAttribute("flashNotice"));
            session.removeAttribute("flashNotice");
        }
    }
}
