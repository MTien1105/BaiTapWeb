# BÀI TẬP: ĐĂNG NHẬP (SESSION & COOKIE) VÀ ĐĂNG KÝ VỚI JPA

Dự án Web Java Servlet - JSP áp dụng công nghệ **JPA (Hibernate)** để quản lý dữ liệu người dùng, triển khai mô hình **MVC** với các tính năng:
- **Đăng ký tài khoản (Register)**: Kiểm tra hợp lệ và trùng lặp qua truy vấn JPQL, mã hóa/lưu trữ dữ liệu bằng JPA `EntityManager`.
- **Đăng nhập với Session**: Lưu đối tượng `User` trong phiên làm việc `HttpSession`.
- **Đăng nhập với Cookie (Remember Me)**: Ghi nhớ phiên đăng nhập trong 30 phút qua HTTP Cookie, tự động phục hồi phiên khi truy cập lại.
- **Đăng xuất (Logout)**: Hủy Session và xóa sạch Cookie Remember Me.
- **Bảo mật**: `AuthFilter` kiểm tra phiên làm việc bảo vệ trang `/home`.

---

## 🛠 Công nghệ sử dụng
- **Ngôn ngữ**: Java 21
- **Công nghệ nền tảng**: Jakarta Servlet 6.0, Jakarta JSP 3.1, JSTL 3.0
- **ORM / JPA**: Hibernate 6.4.4.Final / Jakarta Persistence API 3.1
- **Cơ sở dữ liệu**: Microsoft SQL Server (kèm fallback H2 Database cho môi trường dev)
- **Web Server**: Apache Tomcat 10+ / 11

---

## 📁 Cấu trúc thư mục nguồn

```text
src/
├── main/
│   ├── java/vn/iotstar/
│   │   ├── configs/JPAConfig.java           # Quản lý EntityManagerFactory & EntityManager
│   │   ├── model/User.java                  # Entity JPA đại diện cho bảng 'users'
│   │   ├── dao/                             # Interface và JPA DAO Implementation
│   │   ├── service/                         # Tầng nghiệp vụ (Login, Register)
│   │   ├── controller/                      # Servlet Controllers (Login, Register, Logout, Home, Waiting)
│   │   ├── filter/                          # AuthFilter và EncodingFilter
│   │   └── util/Constant.java               # Hằng số cấu hình hệ thống
│   ├── resources/META-INF/persistence.xml   # Cấu hình Persistence Unit chuẩn của JPA
│   └── webapp/
│       ├── views/                           # Giao diện JSP (login.jsp, register.jsp, home.jsp, topbar.jsp)
│       ├── index.jsp
│       └── WEB-INF/web.xml
└── test/java/vn/iotstar/test/AppTest.java   # Unit test độc lập kiểm tra kết nối JPA & nghiệp vụ
```

---

## 🚀 Hướng dẫn khởi chạy

1. **Yêu cầu môi trường**:
   - JDK 21+
   - Apache Maven 3.9+
   - Apache Tomcat 10.1+ hoặc 11.0+

2. **Cách chạy**:
   - Cách 1: Chạy file `run.bat` ở thư mục gốc (tự động build và mở trình duyệt).
   - Cách 2: Đóng gói WAR bằng lệnh:
     ```bash
     mvn clean package -DskipTests
     ```
     Copy file `target/ShoppingServletServiceMVC.war` vào thư mục `webapps/` của Tomcat và khởi động Tomcat.

3. **Đường dẫn truy cập**:
   - Đăng nhập: `http://localhost:8080/ShoppingServletServiceMVC/login`
   - Đăng ký: `http://localhost:8080/ShoppingServletServiceMVC/register`
   - Tài khoản mặc định: `admin` / `123456`
