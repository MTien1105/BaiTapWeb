package vn.iotstar.dao.impl;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.UserDao;
import vn.iotstar.model.User;
import vn.iotstar.util.PasswordUtil;

public class UserDaoImpl implements UserDao {

    private static boolean isDefaultUsersSeeded = false;

    public UserDaoImpl() {
        seedDefaultUsersIfEmpty();
    }

    private synchronized void seedDefaultUsersIfEmpty() {
        if (isDefaultUsersSeeded) {
            return;
        }
        try {
            EntityManager em = JPAConfig.getEntityManager();
            try {
                Long count = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
                if (count == 0) {
                    EntityTransaction trans = em.getTransaction();
                    try {
                        trans.begin();
                        String defaultPass = PasswordUtil.hashPassword("123456");
                        User admin = new User("admin@iotstar.vn", "admin", "Admin System", defaultPass, null, 1, "0901234567", new java.sql.Date(System.currentTimeMillis()), 1, null);
                        User manager = new User("manager@iotstar.vn", "manager", "Manager Staff", defaultPass, null, 2, "0902345678", new java.sql.Date(System.currentTimeMillis()), 1, null);
                        User user = new User("trungnh@hcmute.edu.vn", "trungnh", "Nguyen Huu Trung", defaultPass, null, 5, "0908617108", new java.sql.Date(System.currentTimeMillis()), 1, null);
                        em.persist(admin);
                        em.persist(manager);
                        em.persist(user);
                        trans.commit();
                    } catch (Exception ex) {
                        if (trans.isActive()) {
                            trans.rollback();
                        }
                    }
                }
                isDefaultUsersSeeded = true;
            } finally {
                em.close();
            }
        } catch (Exception ignored) {
        }
    }

    @Override
    public User get(String username) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.userName = :username";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public User findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<User> query = em.createNamedQuery("User.findAll", User.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void insert(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(user);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void update(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(user);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public User findByEmail(String email) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean updatePassword(String username, String newPassword) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            String jpql = "SELECT u FROM User u WHERE u.userName = :username";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);
            List<User> list = query.getResultList();
            if (!list.isEmpty()) {
                User user = list.get(0);
                String hashedPassword = PasswordUtil.isBCryptHashed(newPassword) ? newPassword : PasswordUtil.hashPassword(newPassword);
                user.setPassWord(hashedPassword);
                em.merge(user);
                trans.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public User findByUsernameAndEmail(String username, String email) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.userName = :username AND u.email = :email";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean checkExistEmail(String email) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.email = :email";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("email", email)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean checkExistUsername(String username) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.userName = :username";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("username", username)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean checkExistPhone(String phone) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.phone = :phone";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("phone", phone)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean checkExistEmailExceptUser(String email, int userId) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE LOWER(u.email) = :email AND u.id != :userId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("email", email.trim().toLowerCase())
                    .setParameter("userId", userId)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean checkExistPhoneExceptUser(String phone, int userId) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.phone = :phone AND u.id != :userId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("phone", phone.trim())
                    .setParameter("userId", userId)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }
}
