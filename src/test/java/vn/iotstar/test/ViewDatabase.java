package vn.iotstar.test;

import java.util.List;
import jakarta.persistence.EntityManager;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.model.User;

public class ViewDatabase {
    public static void main(String[] args) {
        System.out.println("==========================================================================================================================================");
        System.out.println("                                      DANH SÁCH TÀI KHOẢN VÀ MẬT KHẨU HASH TRONG DATABASE (BẢNG USERS)                                    ");
        System.out.println("==========================================================================================================================================");
        try {
            // Đảm bảo khởi tạo các tài khoản mẫu ban đầu nếu bảng còn trống
            new UserDaoImpl();

            EntityManager em = JPAConfig.getEntityManager();
            List<User> users = em.createQuery("SELECT u FROM User u ORDER BY u.id ASC", User.class).getResultList();
            
            System.out.printf("%-4s | %-12s | %-24s | %-62s | %-10s | %-8s\n", 
                    "ID", "USERNAME", "EMAIL", "MẬT KHẨU HASH (BCRYPT 60 KÝ TỰ)", "STATUS", "MÃ OTP");
            System.out.println("------------------------------------------------------------------------------------------------------------------------------------------");
            
            for (User u : users) {
                String pass = u.getPassWord() != null ? u.getPassWord() : "null";
                String code = u.getCode() != null ? u.getCode() : "-";
                String statusDesc = (u.getStatus() == 1) ? "1 (Active)" : "0 (Pending)";
                System.out.printf("%-4d | %-12s | %-24s | %-62s | %-10s | %-8s\n",
                        u.getId(), u.getUserName(), u.getEmail(), pass, statusDesc, code);
            }
            System.out.println("==========================================================================================================================================");
            em.close();
            JPAConfig.shutdown();
        } catch (Exception e) {
            System.err.println("Lỗi khi đọc CSDL: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
