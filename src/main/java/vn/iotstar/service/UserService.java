package vn.iotstar.service;

import vn.iotstar.model.User;

public interface UserService {
    User login(String username, String password);
    User get(String username);
    void insert(User user);
    void update(User user);
    boolean updatePassword(String username, String newPassword);
    User findByUsernameAndEmail(String username, String email);
    boolean changePassword(String username, String oldPassword, String newPassword);
    boolean resetPassword(String username, String email, String newPassword);
    boolean register(String username, String password, String email, String fullname, String phone);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
}
