package vn.iotstar.service;

import vn.iotstar.model.User;

public interface UserService {
    User login(String username, String password);
    User get(String username);
    User findByEmail(String email);
    void insert(User user);
    void update(User user);
    boolean updatePassword(String username, String newPassword);
    User findByUsernameAndEmail(String username, String email);
    boolean changePassword(String username, String oldPassword, String newPassword);
    boolean resetPassword(String username, String email, String newPassword);
    
    // Đăng ký tài khoản (hỗ trợ lưu mã OTP kích hoạt và mật khẩu đã hash)
    boolean register(String username, String password, String email, String fullname, String phone, String otp);
    boolean register(String username, String password, String email, String fullname, String phone);

    // Kích hoạt tài khoản qua OTP
    boolean verifyOtp(String email, String otp);
    boolean resendOtp(String email);

    // Quên mật khẩu qua OTP
    boolean sendForgotPasswordOtp(String emailOrUsername);
    boolean resetPasswordWithOtp(String email, String otp, String newPassword);

    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
}
