package vn.iotstar.test;

import java.util.List;
import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

public class SeedVideos {
    public static void main(String[] args) {
        IVideoService videoService = new VideoServiceImpl();
        UserService userService = new UserServiceImpl();

        List<User> users = userService.findAll();
        if (users.isEmpty()) {
            return;
        }
        User owner = users.get(0);

        if (videoService.count() == 0) {
            videoService.insert(new Video(
                "VID01",
                "Hướng dẫn lập trình Web Java với Servlet & JPA",
                "Video chi tiết về kiến trúc MVC, kết nối Hibernate JPA và SQL Server",
                "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500",
                1500,
                1,
                owner
            ));

            videoService.insert(new Video(
                "VID02",
                "Xây dựng RESTful API chuẩn doanh nghiệp",
                "Tìm hiểu kiến trúc API bảo mật cao với Jakarta EE và Spring Framework",
                "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500",
                2800,
                1,
                owner
            ));

            videoService.insert(new Video(
                "VID03",
                "Bảo mật tài khoản với OTP và BCrypt 12 Rounds",
                "Giải pháp bảo vệ thông tin người dùng tối ưu trong các hệ thống hiện đại",
                "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500",
                980,
                1,
                owner
            ));

            System.out.println("SEED VIDEOS: Da tao thanh cong 3 video mau!");
        } else {
            System.out.println("SEED VIDEOS: Bang Videos da co " + videoService.count() + " video.");
        }
    }
}
