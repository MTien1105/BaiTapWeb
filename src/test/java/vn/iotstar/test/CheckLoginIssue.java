package vn.iotstar.test;

import java.util.List;
import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.PasswordUtil;

public class CheckLoginIssue {
    public static void main(String[] args) {
        System.out.println("=== KIỂM TRA TÀI KHOẢN VÀ ĐĂNG NHẬP ===");
        UserDao dao = new UserDaoImpl();
        UserService service = new UserServiceImpl();

        List<User> list = dao.findAll();
        System.out.println("Tổng số user trong CSDL: " + list.size());
        for (User u : list) {
            boolean matches = PasswordUtil.checkPassword("123456", u.getPassWord());
            System.out.println("ID=" + u.getId() + " | username=" + u.getUserName() 
                + " | status=" + u.getStatus() 
                + " | passLength=" + (u.getPassWord() != null ? u.getPassWord().length() : 0)
                + " | passVal=" + (u.getPassWord() != null && u.getPassWord().length() > 20 ? u.getPassWord().substring(0, 20) + "..." : u.getPassWord())
                + " | match 123456? " + matches);
        }

        System.out.println("\nThử gọi service.login('admin', '123456'):");
        User loginAdmin = service.login("admin", "123456");
        System.out.println("Kết quả login admin: " + (loginAdmin != null ? "THÀNH CÔNG (status=" + loginAdmin.getStatus() + ")" : "THẤT BẠI"));
        
        System.out.println("\nThử gọi service.login('tien', '123456'):");
        User loginTien = service.login("tien", "123456");
        System.out.println("Kết quả login tien: " + (loginTien != null ? "THÀNH CÔNG (status=" + loginTien.getStatus() + ")" : "THẤT BẠI"));
    }
}
