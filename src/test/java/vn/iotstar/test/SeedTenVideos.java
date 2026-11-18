package vn.iotstar.test;

import java.util.List;
import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

public class SeedTenVideos {
    public static void main(String[] args) {
        System.out.println("=== SEED THÊM VIDEO ĐỂ ĐẠT ĐỦ 10 VIDEO MỚI NHẤT ===");
        IVideoService videoService = new VideoServiceImpl();
        UserService userService = new UserServiceImpl();

        List<User> userList = userService.findAll();
        if (userList.isEmpty()) {
            System.err.println("Không có user nào trong CSDL!");
            return;
        }

        User u1 = userList.get(0);
        User u2 = userList.size() > 1 ? userList.get(1) : u1;
        User u3 = userList.size() > 2 ? userList.get(2) : u1;

        String[][] demoVideos = {
            {"VID04", "Lập trình Hibernate JPA nâng cao với Entity Relationship", "Tối ưu hóa truy vấn JPQL, Lazy Loading và Cascade trong kiến trúc đa bảng", "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500", "1450"},
            {"VID05", "Bảo mật Web với JWT & Spring Security 6", "Hướng dẫn triển khai xác thực Token Stateless cho ứng dụng Web SPA", "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=500", "2100"},
            {"VID06", "Thiết kế CSDL quan hệ chuẩn hóa 3NF trong SQL Server", "Phân tích cấu trúc bảng, khóa chính, khóa ngoại và chỉ mục Index tối ưu", "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=500", "3200"},
            {"VID07", "Xây dựng giao diện Responsive với Bootstrap 5 & CSS Grid", "Tối ưu hóa hiển thị giao diện đa thiết bị từ Mobile đến Desktop", "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=500", "1850"},
            {"VID08", "Triển khai ứng dụng Java Web lên Apache Tomcat 11", "Cách đóng gói file WAR, cấu hình context và quản trị server web thực tế", "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=500", "2750"},
            {"VID09", "Lập trình hướng đối tượng OOP nâng cao trong Java 21", "Khám phá Record, Sealed Classes, Pattern Matching và Virtual Threads", "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=500", "4100"},
            {"VID10", "Xây dựng hệ thống gửi Email tự động và xác thực OTP 6 số", "Ứng dụng Jakarta Mail & Angus Mail bảo vệ tài khoản người dùng tuyệt đối", "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500", "1680"}
        };

        for (int i = 0; i < demoVideos.length; i++) {
            String[] vData = demoVideos[i];
            String vId = vData[0];
            if (videoService.findById(vId) == null) {
                User author = (i % 3 == 0) ? u1 : ((i % 3 == 1) ? u2 : u3);
                Video v = new Video(vId, vData[1], vData[2], vData[3], Integer.parseInt(vData[4]), 1, author);
                videoService.insert(v);
                System.out.println("Đã thêm video: " + vId + " - " + vData[1] + " (Tác giả: " + author.getFullName() + ")");
            }
        }

        List<Video> top10 = videoService.findTop10Latest();
        System.out.println("\nTổng số video mới nhất lấy được: " + top10.size());
        for (int i = 0; i < top10.size(); i++) {
            Video v = top10.get(i);
            System.out.println("#" + (i + 1) + " | " + v.getVideoId() + " | " + v.getTitle() + " | Tác giả: " + (v.getUser() != null ? v.getUser().getFullName() : "N/A"));
        }
    }
}
