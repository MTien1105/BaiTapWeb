package vn.iotstar.dao.impl;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.configs.JPAConfig;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.model.User;
import vn.iotstar.model.Video;

public class VideoDaoImpl implements IVideoDao {

    private static boolean isDefaultVideosSeeded = false;

    public VideoDaoImpl() {
        seedDefaultVideosIfEmpty();
    }

    private synchronized void seedDefaultVideosIfEmpty() {
        if (isDefaultVideosSeeded) {
            return;
        }
        try {
            new UserDaoImpl(); // Đảm bảo bảng users đã có dữ liệu mẫu
            EntityManager em = JPAConfig.getEntityManager();
            try {
                Long count = em.createQuery("SELECT COUNT(v) FROM Video v", Long.class).getSingleResult();
                if (count == 0) {
                    List<User> users = em.createQuery("SELECT u FROM User u ORDER BY u.id ASC", User.class).getResultList();
                    if (!users.isEmpty()) {
                        User u1 = users.get(0);
                        User u2 = users.size() > 1 ? users.get(1) : u1;
                        User u3 = users.size() > 2 ? users.get(2) : u1;

                        String[][] demoVideos = {
                            {"VID01", "Giới thiệu Kiến trúc Spring Boot 3 & Jakarta EE 10", "Khóa học nhập môn lập trình Web hướng dịch vụ Servlet JSP kết hợp Hibernate", "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500", "1250"},
                            {"VID02", "Hướng dẫn cấu hình SiteMesh 3 Decorator chuẩn Bootstrap 5", "Xây dựng Master Layout cho Web MVC bao gồm Header, Navbar, Content và Footer", "https://images.unsplash.com/photo-1518770660439-4636190af475?w=500", "890"},
                            {"VID03", "Kỹ thuật phân trang Pagination trong JPA Hibernate", "Tối ưu hóa tải dữ liệu 6 sản phẩm/trang bằng JPQL setFirstResult và setMaxResults", "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=500", "2300"},
                            {"VID04", "Lập trình Hibernate JPA nâng cao với Entity Relationship", "Tối ưu hóa truy vấn JPQL, Lazy Loading và Cascade trong kiến trúc đa bảng", "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500", "1450"},
                            {"VID05", "Bảo mật Web với JWT & BCrypt Password Hashing", "Hướng dẫn triển khai xác thực tài khoản an toàn và băm mật khẩu 60 ký tự", "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=500", "2100"},
                            {"VID06", "Thiết kế CSDL quan hệ chuẩn hóa 3NF trong SQL Server", "Phân tích cấu trúc bảng, khóa chính, khóa ngoại và chỉ mục Index tối ưu", "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=500", "3200"},
                            {"VID07", "Xây dựng giao diện Responsive với Bootstrap 5 & CSS Grid", "Tối ưu hóa hiển thị giao diện đa thiết bị từ Mobile đến Desktop", "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=500", "1850"},
                            {"VID08", "Triển khai ứng dụng Java Web lên Apache Tomcat 11", "Cách đóng gói file WAR, cấu hình context và quản trị server web thực tế", "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=500", "2750"},
                            {"VID09", "Lập trình hướng đối tượng OOP nâng cao trong Java 21", "Khám phá Record, Sealed Classes, Pattern Matching và Virtual Threads", "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=500", "4100"},
                            {"VID10", "Xây dựng hệ thống gửi Email tự động và xác thực OTP 6 số", "Ứng dụng Jakarta Mail & Angus Mail bảo vệ tài khoản người dùng tuyệt đối", "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500", "1680"}
                        };

                        EntityTransaction trans = em.getTransaction();
                        try {
                            trans.begin();
                            for (int i = 0; i < demoVideos.length; i++) {
                                String[] item = demoVideos[i];
                                User author = (i % 3 == 0) ? u1 : ((i % 3 == 1) ? u2 : u3);
                                Video v = new Video(item[0], item[1], item[2], item[3], Integer.parseInt(item[4]), 1, author);
                                em.persist(v);
                            }
                            trans.commit();
                            System.out.println("[VideoDaoImpl] Đã khởi tạo thành công 10 video mẫu vào cơ sở dữ liệu!");
                        } catch (Exception ex) {
                            if (trans.isActive()) trans.rollback();
                        }
                    }
                }
                isDefaultVideosSeeded = true;
            } finally {
                em.close();
            }
        } catch (Exception ignored) {
        }
    }

    @Override
    public void insert(Video video) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(video);
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
    public void update(Video video) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(video);
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
    public void delete(String videoId) throws Exception {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Video video = em.find(Video.class, videoId);
            if (video != null) {
                em.remove(video);
            } else {
                throw new Exception("Không tìm thấy Video có mã: " + videoId);
            }
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
    public Video findById(String videoId) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Video.class, videoId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Video> query = em.createNamedQuery("Video.findAll", Video.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Video> query = em.createNamedQuery("Video.findAll", Video.class);
            query.setFirstResult(page * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findTop10Latest() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v LEFT JOIN FETCH v.user WHERE v.active = 1 ORDER BY v.videoId DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findByUserId(int userId) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v LEFT JOIN FETCH v.user WHERE v.user.id = :userId ORDER BY v.videoId DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> searchByTitleAndUserId(String keyword, int userId) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v LEFT JOIN FETCH v.user WHERE v.user.id = :userId AND LOWER(v.title) LIKE LOWER(:keyword) ORDER BY v.videoId DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pageSize) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v LEFT JOIN FETCH v.user WHERE v.user.id = :userId AND v.active = 1 ORDER BY v.videoId DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public int countByUserId(int userId) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT count(v) FROM Video v WHERE v.user.id = :userId AND v.active = 1";
            Query query = em.createQuery(jpql);
            query.setParameter("userId", userId);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAllActivePaginated(int page, int pageSize) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v LEFT JOIN FETCH v.user WHERE v.active = 1 ORDER BY v.videoId DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public int countActive() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT count(v) FROM Video v WHERE v.active = 1";
            Query query = em.createQuery(jpql);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.title LIKE :keyword";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Video findByTitle(String title) throws Exception {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.title = :title";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setParameter("title", title);
            List<Video> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public int count() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT count(v) FROM Video v";
            Query query = em.createQuery(jpql);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}
