package vn.iotstar.configs;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;

@PersistenceContext
public class JPAConfig {

    private static EntityManagerFactory factory;

    public static synchronized EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
                // Thử tạo một EntityManager để test kết nối thực tế
                EntityManager testEm = factory.createEntityManager();
                testEm.close();
            } catch (Exception e) {
                System.err.println("[JPA WARNING] Khong the ket noi SQL Server 'jpa-hibernate-mysql': " + e.getMessage());
                System.out.println("[JPA INFO] Chuyen sang fallback H2 Database 'jpa-hibernate-h2' de tiep tuc chay ung dung...");
                try {
                    factory = Persistence.createEntityManagerFactory("jpa-hibernate-h2");
                } catch (Exception ex) {
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
