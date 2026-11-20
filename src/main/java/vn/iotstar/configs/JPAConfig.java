package vn.iotstar.configs;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;
import java.util.HashMap;
import java.util.Map;

@PersistenceContext
public class JPAConfig {

    private static EntityManagerFactory factory;

    public static synchronized EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            try {
                // Thử kết nối SQL Server với loginTimeout ngắn (2 giây) để nếu SQL Server chưa bật thì không bị treo request
                Map<String, Object> props = new HashMap<>();
                props.put("jakarta.persistence.jdbc.url", 
                    "jdbc:sqlserver://localhost:1433;encrypt=true;trustServerCertificate=true;databaseName=ShoppingDB;loginTimeout=2;connectTimeout=2000");
                
                EntityManagerFactory sqlFactory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql", props);
                // Bắt buộc thực hiện 1 câu query thực tế để kiểm tra socket kết nối đến SQL Server
                EntityManager testEm = sqlFactory.createEntityManager();
                testEm.createNativeQuery("SELECT 1").getSingleResult();
                testEm.close();

                factory = sqlFactory;
                System.out.println("[JPA SUCCESS] Kết nối cơ sở dữ liệu Microsoft SQL Server (ShoppingDB) thành công!");
            } catch (Throwable e) {
                System.err.println("[JPA WARNING] SQL Server không phản hồi hoặc chưa chạy: " + e.getMessage());
                System.out.println("[JPA INFO] Tự động chuyển sang Database dự phòng H2 In-Memory ('jpa-hibernate-h2') để website hoạt động ngay...");
                try {
                    factory = Persistence.createEntityManagerFactory("jpa-hibernate-h2");
                } catch (Throwable ex) {
                    ex.printStackTrace();
                }
            }
        }
        return factory.createEntityManager();
    }

    public static synchronized void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
