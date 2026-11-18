-- ================================================================
-- Script tạo bảng Videos với mối quan hệ 1-N tới bảng users
-- Cơ sở dữ liệu: ShoppingDB
-- ================================================================

USE ShoppingDB;
GO

-- 1. Tạo bảng Videos nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Videos')
BEGIN
    CREATE TABLE Videos (
        VideoId VARCHAR(50) NOT NULL PRIMARY KEY,
        Title NVARCHAR(500) NULL,
        Description NVARCHAR(500) NULL,
        Poster NVARCHAR(500) NULL,
        Views INT NOT NULL DEFAULT 0,
        Active INT NOT NULL DEFAULT 1,
        UserId INT NOT NULL,
        CONSTRAINT FK_Videos_Users FOREIGN KEY (UserId) REFERENCES users(id) ON DELETE CASCADE
    );
    PRINT 'Da tao thanh cong bang Videos voi khoa ngoai UserId (1-N users -> videos)!';
END
ELSE
BEGIN
    PRINT 'Bang Videos da ton tai san trong ShoppingDB.';
END
GO

-- 2. Chèn dữ liệu mẫu nếu bảng Videos đang trống
IF NOT EXISTS (SELECT 1 FROM Videos)
BEGIN
    DECLARE @FirstUserId INT;
    SELECT TOP 1 @FirstUserId = id FROM users ORDER BY id ASC;

    IF @FirstUserId IS NOT NULL
    BEGIN
        INSERT INTO Videos (VideoId, Title, Description, Poster, Views, Active, UserId)
        VALUES 
        ('V01', N'Lập trình Web Java với Jakarta EE 10 & JPA 3.0', N'Khóa học thực chiến xây dựng ứng dụng MVC với Servlet, JSP và Hibernate 6', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500', 1250, 1, @FirstUserId),
        ('V02', N'Xây dựng RESTful API và Microservices với Spring Boot 3', N'Hướng dẫn chi tiết từ bước kết nối Database đến bảo mật JWT', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500', 3800, 1, @FirstUserId),
        ('V03', N'Kỹ thuật mã hóa mật khẩu an toàn với BCrypt 12 Rounds', N'Phân tích cơ chế salt ngẫu nhiên và phòng chống tấn công brute-force', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500', 920, 1, @FirstUserId);

        PRINT 'Da chen 3 ban ghi video mau vao bang Videos!';
    END
END
GO

-- 3. Kiểm tra dữ liệu
SELECT v.VideoId, v.Title, v.Views, v.Active, u.username AS NguoiDang, u.fullname AS HoTen
FROM Videos v
INNER JOIN users u ON v.UserId = u.id;
GO
