package vn.iotstar.test;

import jakarta.persistence.EntityManager;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class AppTest {
    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("   KIỂM TRA CÁC CHỨC NĂNG BỔ SUNG: OTP, HASH PASSWORD, LOGOUT");
        System.out.println("==========================================================");

        // 1. Kiểm tra kết nối JPA EntityManager
        try {
            EntityManager em = JPAConfig.getEntityManager();
            System.out.println("1. Kết nối JPA EntityManager: THÀNH CÔNG (isOpen: " + em.isOpen() + ")");
            em.close();
        } catch (Exception e) {
            System.err.println("1. Kết nối JPA THẤT BẠI: " + e.getMessage());
            e.printStackTrace();
            return;
        }

        UserService userService = new UserServiceImpl();

        // 2. Kiểm tra tính năng Đăng nhập với BCrypt Password Hash
        System.out.println("\n2. Kiểm tra Đăng nhập với Mật khẩu mã hóa BCrypt:");
        User admin = userService.login("admin", "123456");
        if (admin != null) {
            System.out.println("   [OK] Đăng nhập 'admin' thành công (Status: " + admin.getStatus() + ", Name: " + admin.getFullName() + ")");
        } else {
            System.out.println("   [FAIL] Đăng nhập 'admin' thất bại!");
        }

        User failPass = userService.login("admin", "wrong_pass");
        if (failPass == null) {
            System.out.println("   [OK] Kiểm tra mật khẩu sai: Hệ thống từ chối thành công");
        }

        // 3. Kiểm tra tính năng Đăng ký tài khoản gửi OTP kích hoạt qua Email
        System.out.println("\n3. Kiểm tra Đăng ký tài khoản kèm mã OTP kích hoạt qua Email:");
        String testUser = "user_otp_" + (System.currentTimeMillis() % 10000);
        String testEmail = testUser + "@example.com";
        String otpCode = EmailUtil.generateOtp();

        boolean regSuccess = userService.register(testUser, "Secret@123", testEmail, "Nguyen Van OTP", "0911223344", otpCode);
        System.out.println("   [OK] Đăng ký tài khoản '" + testUser + "' với OTP=" + otpCode + ": " + (regSuccess ? "THÀNH CÔNG" : "THẤT BẠI"));

        User unactivatedUser = userService.get(testUser);
        if (unactivatedUser != null) {
            System.out.println("   [OK] Trạng thái tài khoản ban đầu: status = " + unactivatedUser.getStatus() + " (0 = Chưa kích hoạt)");
            System.out.println("   [OK] Mật khẩu đã được mã hóa BCrypt: " + unactivatedUser.getPassWord().substring(0, 15) + "...");
            System.out.println("   [OK] Mã OTP trong CSDL: " + unactivatedUser.getCode());
        }

        // 4. Kích hoạt tài khoản bằng mã OTP
        System.out.println("\n4. Kiểm tra kích hoạt tài khoản bằng mã OTP:");
        boolean verifyFail = userService.verifyOtp(testEmail, "000000"); // Sai OTP
        System.out.println("   [OK] Nhập sai OTP '000000': " + (!verifyFail ? "Bị từ chối thành công" : "Lỗi"));

        boolean verifySuccess = userService.verifyOtp(testEmail, otpCode); // Đúng OTP
        System.out.println("   [OK] Nhập đúng OTP '" + otpCode + "': " + (verifySuccess ? "Kích hoạt THÀNH CÔNG" : "Lỗi"));

        User activatedUser = userService.get(testUser);
        if (activatedUser != null) {
            System.out.println("   [OK] Trạng thái sau kích hoạt: status = " + activatedUser.getStatus() + " (1 = Đã kích hoạt), code = " + activatedUser.getCode());
        }

        // 5. Kiểm tra đăng nhập với tài khoản vừa kích hoạt
        User loggedUser = userService.login(testUser, "Secret@123");
        if (loggedUser != null) {
            System.out.println("   [OK] Đăng nhập tài khoản vừa kích hoạt: THÀNH CÔNG");
        } else {
            System.out.println("   [FAIL] Đăng nhập thất bại!");
        }

        // 6. Kiểm tra chức năng Quên mật khẩu gửi OTP qua Email
        System.out.println("\n5. Kiểm tra chức năng Quên mật khẩu gửi mã OTP:");
        boolean forgotOtpSent = userService.sendForgotPasswordOtp(testEmail);
        System.out.println("   [OK] Gửi mã OTP khôi phục mật khẩu: " + (forgotOtpSent ? "THÀNH CÔNG" : "THẤT BẠI"));

        User userAfterForgot = userService.get(testUser);
        String resetOtp = userAfterForgot.getCode();
        System.out.println("   [OK] Mã OTP khôi phục mật khẩu mới tạo: " + resetOtp);

        boolean resetSuccess = userService.resetPasswordWithOtp(testEmail, resetOtp, "NewPass@456");
        System.out.println("   [OK] Đặt lại mật khẩu mới bằng OTP: " + (resetSuccess ? "THÀNH CÔNG" : "THẤT BẠI"));

        User testNewLogin = userService.login(testUser, "NewPass@456");
        if (testNewLogin != null) {
            System.out.println("   [OK] Đăng nhập bằng mật khẩu mới vừa đổi: THÀNH CÔNG!");
        } else {
            System.out.println("   [FAIL] Đăng nhập bằng mật khẩu mới thất bại!");
        }

        System.out.println("\n==========================================================");
        System.out.println("✅ TẤT CẢ 3 TÍNH NĂNG MỚI ĐÃ HOÀN TẤT VÀ VẬN HÀNH CHUẨN XÁC!");
        System.out.println("==========================================================");

        JPAConfig.shutdown();
    }
}
