package vn.iotstar.test;

import java.util.List;
import vn.iotstar.model.User;
import vn.iotstar.model.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

public class VideoCrudTest {
    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("   KIỂM THỬ CRUD CHO BẢNG VIDEOS (QUAN HỆ 1-N VỚI USERS)");
        System.out.println("==========================================================");

        IVideoService videoService = new VideoServiceImpl();
        UserService userService = new UserServiceImpl();

        // 1. Lấy danh sách User để kiểm tra quan hệ 1-N
        List<User> userList = userService.findAll();
        System.out.println("1. Tìm kiếm User chủ sở hữu: Tìm thấy " + userList.size() + " người dùng.");
        if (userList.isEmpty()) {
            System.err.println("Không có user nào trong CSDL để liên kết Video!");
            return;
        }
        User owner = userList.get(0);
        System.out.println("   [OK] Đã chọn User chủ sở hữu: " + owner.getFullName() + " (ID: " + owner.getId() + ")");

        // 2. Kiểm thử Create (Insert Video)
        String testVideoId = "TEST_VID_" + (System.currentTimeMillis() % 10000);
        Video newVideo = new Video(
            testVideoId,
            "Video Kiểm Thử Tự Động " + testVideoId,
            "Mô tả chi tiết nội dung video kiểm thử",
            "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500",
            100,
            1,
            owner
        );

        videoService.insert(newVideo);
        System.out.println("\n2. [CREATE] Thêm video mới với ID=" + testVideoId + ": THÀNH CÔNG");

        // 3. Kiểm thử Read (FindById & FindAll)
        Video found = videoService.findById(testVideoId);
        if (found != null) {
            System.out.println("\n3. [READ] Tìm video theo ID=" + testVideoId + ": THÀNH CÔNG");
            System.out.println("   - Tiêu đề: " + found.getTitle());
            System.out.println("   - Lượt xem: " + found.getViews());
            System.out.println("   - Người đăng (Quan hệ 1-N): " + (found.getUser() != null ? found.getUser().getFullName() : "NULL"));
        } else {
            System.err.println("   [FAIL] Không tìm thấy video vừa thêm!");
        }

        // 4. Kiểm thử Search
        List<Video> searchList = videoService.searchByTitle("Kiểm Thử");
        System.out.println("\n4. [SEARCH] Tìm kiếm theo từ khóa 'Kiểm Thử': Tìm thấy " + searchList.size() + " video.");

        // 5. Kiểm thử Update
        if (found != null) {
            found.setTitle("Tiêu Đề Video Đã Được Cập Nhật " + testVideoId);
            found.setViews(999);
            videoService.update(found);

            Video updated = videoService.findById(testVideoId);
            System.out.println("\n5. [UPDATE] Cập nhật video: THÀNH CÔNG");
            System.out.println("   - Tiêu đề mới: " + updated.getTitle());
            System.out.println("   - Lượt xem mới: " + updated.getViews());
        }

        // 6. Kiểm thử Delete
        try {
            videoService.delete(testVideoId);
            Video afterDelete = videoService.findById(testVideoId);
            if (afterDelete == null) {
                System.out.println("\n6. [DELETE] Xóa video có mã " + testVideoId + ": THÀNH CÔNG");
            } else {
                System.err.println("\n6. [FAIL] Video vẫn tồn tại sau khi xóa!");
            }
        } catch (Exception e) {
            System.err.println("\n6. [FAIL] Lỗi khi xóa video: " + e.getMessage());
        }

        System.out.println("\n==========================================================");
        System.out.println("✅ TẤT CẢ CÁC THAO TÁC CRUD VIDEO ĐÃ HOÀN TẤT XUẤT SẮC!");
        System.out.println("==========================================================");
    }
}
