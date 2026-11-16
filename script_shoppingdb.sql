-- SCRIPT TẠO DATABASE VÀ DỮ LIỆU MẪU CHO MÔN HỌC LẬP TRÌNH WEB
-- MỞ FILE NÀY TRONG SQL SERVER MANAGEMENT STUDIO (SSMS) VÀ BẤM F5 ĐỂ CHẠY

CREATE DATABASE ShoppingDB;
GO

USE ShoppingDB;
GO

IF OBJECT_ID('dbo.users', 'U') IS NOT NULL 
    DROP TABLE dbo.users;
GO

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    fullname NVARCHAR(100) NOT NULL,
    password VARCHAR(200) NOT NULL,
    avatar VARCHAR(255) NULL,
    roleid INT NOT NULL DEFAULT 5,
    phone VARCHAR(20) NULL,
    createddate DATE NULL,
    status INT NOT NULL DEFAULT 1,     -- 1: Đã kích hoạt qua OTP, 0: Chưa kích hoạt
    code VARCHAR(50) NULL              -- Lưu mã OTP xác thực
);
GO

-- CHÈN DỮ LIỆU MẪU VỚI MẬT KHẨU ĐÃ ĐƯỢC BĂM MÃ HÓA BCRYPT (TƯƠNG ỨNG MẬT KHẨU GỐC "123456")
INSERT INTO users (username, email, fullname, password, avatar, roleid, phone, createddate, status, code)
VALUES 
('admin', 'admin@iotstar.vn', N'Admin System', '$2a$12$Wf19GwrcGiOWK/sWAFja8edvxgvckeBKeJjOf0/mQy6RxqNGtz2Vi', NULL, 1, '0901234567', GETDATE(), 1, NULL),
('manager', 'manager@iotstar.vn', N'Manager Staff', '$2a$12$Wf19GwrcGiOWK/sWAFja8edvxgvckeBKeJjOf0/mQy6RxqNGtz2Vi', NULL, 2, '0902345678', GETDATE(), 1, NULL),
('trungnh', 'trungnh@hcmute.edu.vn', N'Nguyen Huu Trung', '$2a$12$Wf19GwrcGiOWK/sWAFja8edvxgvckeBKeJjOf0/mQy6RxqNGtz2Vi', NULL, 5, '0908617108', GETDATE(), 1, NULL),
('testotp', 'testotp@gmail.com', N'Nguyen Van OTP', '$2a$12$Wf19GwrcGiOWK/sWAFja8edvxgvckeBKeJjOf0/mQy6RxqNGtz2Vi', NULL, 5, '0912345678', GETDATE(), 0, '829314');
GO

-- TRUY VẤN XEM KẾT QUẢ VÀ CHUỖI BĂM HASH MẬT KHẨU
SELECT id, username, email, password, status, code FROM users;
GO
