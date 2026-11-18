package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.model.User;

public interface UserDao {
    User get(String username);
    User findByEmail(String email);
    User findById(int id);
    List<User> findAll();
    void insert(User user);
    void update(User user);
    boolean updatePassword(String username, String newPassword);
    User findByUsernameAndEmail(String username, String email);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
}
