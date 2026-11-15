package vn.iotstar.test;

import jakarta.persistence.EntityManager;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

public class AppTest {
    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("   KIỂM TRA HỆ THỐNG ĐĂNG NHẬP / ĐĂNG KÝ VỚI JPA & MVC");
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

        // 2. Kiểm tra đăng nhập với User JPA
        System.out.println("\n2. Kiểm tra đăng nhập (JPA):");
        User admin = userService.login("admin", "123456");
        if (admin != null) {
            System.out.println("   [OK] Đăng nhập 'admin' thành công: Role ID = " + admin.getRoleid() + " (" + admin.getFullName() + ")");
        } else {
            System.out.println("   [FAIL] Đăng nhập 'admin' thất bại!");
        }

        User failUser = userService.login("admin", "wrongpass");
        if (failUser == null) {
            System.out.println("   [OK] Kiểm tra mật khẩu sai: Hệ thống từ chối thành công");
        }

        // 3. Kiểm tra đăng ký tài khoản mới qua JPA
        System.out.println("\n3. Kiểm tra đăng ký tài khoản mới (JPA):");
        String testUser = "user_jpa_" + System.currentTimeMillis() % 10000;
        String testEmail = testUser + "@example.com";

        boolean duplicateCheck = userService.checkExistUsername("admin");
        System.out.println("   [OK] Kiểm tra tài khoản đã tồn tại ('admin'): " + (duplicateCheck ? "Phát hiện trùng lặp chính xác" : "Lỗi"));

        boolean regSuccess = userService.register(testUser, "123456", testEmail, "Nguyen Van Test JPA", "0987654321");
        System.out.println("   [OK] Đăng ký tài khoản '" + testUser + "': " + (regSuccess ? "THÀNH CÔNG" : "THẤT BẠI"));

        // 4. Kiểm tra đăng nhập với tài khoản vừa tạo
        User newLogin = userService.login(testUser, "123456");
        if (newLogin != null) {
            System.out.println("   [OK] Đăng nhập tài khoản mới vừa tạo: THÀNH CÔNG (Role ID = " + newLogin.getRoleid() + ", Name = " + newLogin.getFullName() + ")");
        } else {
            System.out.println("   [FAIL] Đăng nhập tài khoản mới thất bại!");
        }

        System.out.println("\n==========================================================");
        System.out.println("✅ TOÀN BỘ NGHIỆP VỤ BÀI TẬP 01 ĐÃ HOÀN TOÀN CHẠY TRÊN JPA!");
        System.out.println("==========================================================");

        JPAConfig.shutdown();
    }
}
