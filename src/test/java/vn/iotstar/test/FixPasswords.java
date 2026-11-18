package vn.iotstar.test;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.model.User;
import vn.iotstar.util.PasswordUtil;

public class FixPasswords {
    public static void main(String[] args) {
        System.out.println("=== FIX LẠI TOÀN BỘ MẬT KHẨU THÀNH 123456 (CHUẨN BCRYPT 60 KÝ TỰ) ===");
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            List<User> list = em.createQuery("SELECT u FROM User u", User.class).getResultList();
            for (User u : list) {
                // Sinh hash BCrypt mới chuẩn 60 ký tự
                String newHash = PasswordUtil.hashPassword("123456");
                u.setPassWord(newHash);
                u.setStatus(1); // Kích hoạt luôn tài khoản để đăng nhập được ngay
                u.setCode(null);
                em.merge(u);
                System.out.println("Đã cập nhật: " + u.getUserName() + " -> Pass Hash: " + newHash.substring(0, 20) + "... (Length: " + newHash.length() + ")");
            }
            trans.commit();
            System.out.println("THÀNH CÔNG: Đã cập nhật toàn bộ " + list.size() + " user với mật khẩu '123456'!");
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
