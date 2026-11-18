package vn.iotstar.service.impl;

import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.model.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements UserService {
    private final UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        User user = this.get(username);
        if (user != null && PasswordUtil.checkPassword(password, user.getPassWord())) {
            return user;
        }
        return null;
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public java.util.List<User> findAll() {
        return userDao.findAll();
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public boolean updatePassword(String username, String newPassword) {
        String hashedPassword = PasswordUtil.isBCryptHashed(newPassword) ? newPassword : PasswordUtil.hashPassword(newPassword);
        return userDao.updatePassword(username, hashedPassword);
    }

    @Override
    public User findByUsernameAndEmail(String username, String email) {
        return userDao.findByUsernameAndEmail(username, email);
    }

    @Override
    public boolean changePassword(String username, String oldPassword, String newPassword) {
        User user = this.login(username, oldPassword);
        if (user != null) {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            return userDao.updatePassword(username, hashedPassword);
        }
        return false;
    }

    @Override
    public boolean resetPassword(String username, String email, String newPassword) {
        User user = userDao.findByUsernameAndEmail(username, email);
        if (user != null) {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            return userDao.updatePassword(username, hashedPassword);
        }
        return false;
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone, String otp) {
        if (userDao.checkExistUsername(username) || userDao.checkExistEmail(email)) {
            return false;
        }
        long millis = System.currentTimeMillis();
        java.sql.Date date = new java.sql.Date(millis);
        // Mã hóa mật khẩu an toàn với BCrypt
        String hashedPassword = PasswordUtil.hashPassword(password);
        // Tài khoản đăng ký mới có status = 0 (chờ kích hoạt qua OTP) và code = otp
        User newUser = new User(email, username, fullname, hashedPassword, null, 5, phone, date, 0, otp);
        userDao.insert(newUser);
        return true;
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone) {
        String otp = EmailUtil.generateOtp();
        return register(username, password, email, fullname, phone, otp);
    }

    @Override
    public boolean verifyOtp(String email, String otp) {
        if (email == null || otp == null) {
            return false;
        }
        User user = userDao.findByEmail(email.trim());
        if (user != null && user.getCode() != null && otp.trim().equals(user.getCode().trim())) {
            user.setStatus(1); // Kích hoạt tài khoản thành công
            user.setCode(null); // Xóa mã OTP
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean resendOtp(String email) {
        if (email == null) {
            return false;
        }
        User user = userDao.findByEmail(email.trim());
        if (user != null) {
            String newOtp = EmailUtil.generateOtp();
            user.setCode(newOtp);
            userDao.update(user);
            String emailContent = EmailUtil.buildActivationEmail(user.getFullName(), newOtp);
            EmailUtil.sendEmail(user.getEmail(), "Mã kích hoạt tài khoản mới (Gửi lại)", emailContent);
            return true;
        }
        return false;
    }

    @Override
    public boolean sendForgotPasswordOtp(String emailOrUsername) {
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            return false;
        }
        String input = emailOrUsername.trim();
        User user = input.contains("@") ? userDao.findByEmail(input) : userDao.get(input);
        if (user != null) {
            String otp = EmailUtil.generateOtp();
            user.setCode(otp);
            userDao.update(user);
            String emailContent = EmailUtil.buildResetPasswordEmail(user.getFullName(), otp);
            EmailUtil.sendEmail(user.getEmail(), "Mã xác thực đặt lại mật khẩu", emailContent);
            return true;
        }
        return false;
    }

    @Override
    public boolean resetPasswordWithOtp(String email, String otp, String newPassword) {
        if (email == null || otp == null || newPassword == null) {
            return false;
        }
        User user = userDao.findByEmail(email.trim());
        if (user != null && user.getCode() != null && otp.trim().equals(user.getCode().trim())) {
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            user.setPassWord(hashedPassword);
            user.setCode(null);
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }
}
