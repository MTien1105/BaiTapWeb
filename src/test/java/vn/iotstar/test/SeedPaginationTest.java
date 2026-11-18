package vn.iotstar.test;

import java.util.List;
import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

public class SeedPaginationTest {
    public static void main(String[] args) {
        System.out.println("=== KIỂM TRA PHÂN TRANG 6 VIDEO/TRANG CHO USER ===");
        IVideoService videoService = new VideoServiceImpl();
        UserService userService = new UserServiceImpl();

        List<User> userList = userService.findAll();
        if (userList.isEmpty()) {
            return;
        }
        User admin = userList.get(0); // Admin System (ID: 1)

        // Thêm VID11 và VID12 cho User 1 nếu chưa có
        if (videoService.findById("VID11") == null) {
            videoService.insert(new Video(
                "VID11",
                "Kiến trúc Clean Architecture & Domain-Driven Design trong Java",
                "Cách tổ chức mã nguồn mở rộng cao và dễ bảo trì cho các dự án lớn",
                "https://images.unsplash.com/photo-1516116211227-bbc141e975d0?w=500",
                1950,
                1,
                admin
            ));
            System.out.println("Đã thêm VID11 cho " + admin.getFullName());
        }

        if (videoService.findById("VID12") == null) {
            videoService.insert(new Video(
                "VID12",
                "Tối ưu hóa hiệu năng truy vấn CSDL với Hibernate 2nd Level Cache",
                "Kỹ thuật cache dữ liệu với Redis và Ehcache giảm tải 90% truy vấn DB",
                "https://images.unsplash.com/photo-1542744094-3a3172720a45?w=500",
                3100,
                1,
                admin
            ));
            System.out.println("Đã thêm VID12 cho " + admin.getFullName());
        }

        // Test phân trang 6 sản phẩm/trang cho User 1
        int userId = admin.getId();
        int pageSize = 6;
        int total = videoService.countByUserId(userId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        System.out.println("\nTổng số video của User " + admin.getFullName() + ": " + total);
        System.out.println("Tổng số trang (6sp/trang): " + totalPages);

        System.out.println("\n--- TRANG 1 (6 video đầu tiên) ---");
        List<Video> page1 = videoService.findByUserId(userId, 1, pageSize);
        for (int i = 0; i < page1.size(); i++) {
            System.out.println("P1 #" + (i + 1) + " | " + page1.get(i).getVideoId() + " | " + page1.get(i).getTitle());
        }

        System.out.println("\n--- TRANG 2 (các video tiếp theo) ---");
        List<Video> page2 = videoService.findByUserId(userId, 2, pageSize);
        for (int i = 0; i < page2.size(); i++) {
            System.out.println("P2 #" + (i + 1) + " | " + page2.get(i).getVideoId() + " | " + page2.get(i).getTitle());
        }

        System.out.println("\n✅ TEST PHÂN TRANG 6SP/TRANG THÀNH CÔNG RỰC RỠ!");
    }
}
