package vn.iotstar.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Mã hóa mật khẩu plain text bằng thuật toán BCrypt với salt ngẫu nhiên.
     * @param plainPassword mật khẩu người dùng nhập
     * @return chuỗi băm BCrypt an toàn (60 ký tự)
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiểm tra mật khẩu plain text có khớp với mật khẩu đã lưu trong database hay không.
     * Hỗ trợ tương thích ngược cho cả mật khẩu đã hash BCrypt và mật khẩu chưa hash (plain text).
     * @param plainPassword mật khẩu người dùng nhập khi đăng nhập
     * @param storedPassword mật khẩu lưu trong cơ sở dữ liệu
     * @return true nếu mật khẩu khớp, false nếu sai
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        try {
            if (isBCryptHashed(storedPassword)) {
                return BCrypt.checkpw(plainPassword, storedPassword);
            } else {
                return plainPassword.equals(storedPassword);
            }
        } catch (Exception e) {
            System.err.println("[PasswordUtil ERROR] Lỗi kiểm tra mật khẩu: " + e.getMessage());
            return false;
        }
    }

    /**
     * Kiểm tra chuỗi có phải định dạng mã băm BCrypt hợp lệ không.
     */
    public static boolean isBCryptHashed(String password) {
        if (password == null) {
            return false;
        }
        return password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$");
    }
}
