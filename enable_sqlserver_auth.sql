-- ================================================================
-- Script kích hoạt Mixed Mode Authentication và sa login
-- Chạy trong SSMS với quyền Administrator (Windows Auth)
-- ================================================================

-- 1. Bật Mixed Mode Authentication (cần restart SQL Server sau đó)
USE master;
GO

EXEC xp_instance_regwrite 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode', 
    REG_DWORD, 
    2;  -- 2 = Mixed Mode (SQL + Windows), 1 = Windows only
GO

-- 2. Enable sa login và đặt password
ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = '123';
GO

-- 3. Kiểm tra
SELECT name, is_disabled, type_desc 
FROM sys.server_principals 
WHERE name = 'sa';
GO

PRINT '=================================================';
PRINT 'DONE! Now restart SQL Server (SQLEXPRESS) service';
PRINT 'Then update persistence.xml connection string:';
PRINT 'jdbc:sqlserver://localhost:1433;databaseName=ShoppingDB;user=sa;password=123;...';
PRINT '=================================================';
