-- Script específico para SQL Server Express
-- Conectar a tu servidor: DESKTOP-QUB7HBB\SQLEXPRESS

USE master;
GO

-- Verificar que estamos conectados al servidor correcto
SELECT @@SERVERNAME as ServidorActual, @@VERSION as VersionSQL;
GO

-- Eliminar la base de datos si existe (opcional)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BlazorCrudDb')
BEGIN
    PRINT 'Eliminando base de datos existente...';
    ALTER DATABASE BlazorCrudDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BlazorCrudDb;
    PRINT 'Base de datos eliminada.';
END
GO

-- Crear la nueva base de datos
PRINT 'Creando base de datos BlazorCrudDb...';
CREATE DATABASE BlazorCrudDb
ON 
( NAME = 'BlazorCrudDb',
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\BlazorCrudDb.mdf',
  SIZE = 100MB,
  MAXSIZE = 1GB,
  FILEGROWTH = 10MB )
LOG ON 
( NAME = 'BlazorCrudDb_Log',
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\BlazorCrudDb_Log.ldf',
  SIZE = 10MB,
  MAXSIZE = 100MB,
  FILEGROWTH = 5MB );
GO

PRINT 'Base de datos creada exitosamente.';

-- Usar la base de datos recién creada
USE BlazorCrudDb;
GO

-- Crear la tabla Products
PRINT 'Creando tabla Products...';
CREATE TABLE Products (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Description nvarchar(500) NULL,
    Price decimal(18,2) NOT NULL CHECK (Price >= 0),
    Category nvarchar(50) NOT NULL,
    CreatedAt datetime2 NOT NULL DEFAULT GETDATE(),
    IsActive bit NOT NULL DEFAULT 1
);
GO

-- Crear índices para mejorar el rendimiento
PRINT 'Creando índices...';
CREATE INDEX IX_Products_Category ON Products(Category);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_Products_CreatedAt ON Products(CreatedAt DESC);
CREATE INDEX IX_Products_Name ON Products(Name);
GO

-- Insertar datos de prueba
PRINT 'Insertando datos de prueba...';
INSERT INTO Products (Name, Description, Price, Category, CreatedAt, IsActive)
VALUES 
    ('Laptop Dell Inspiron 15', 'Laptop Dell Inspiron 15 con procesador Intel Core i5, 8GB RAM, 256GB SSD', 899.99, 'Electrónicos', GETDATE(), 1),
    ('Mouse Logitech MX Master', 'Mouse inalámbrico Logitech MX Master 3 con sensor de alta precisión', 79.99, 'Accesorios', GETDATE(), 1),
    ('Teclado Mecánico RGB', 'Teclado mecánico con retroiluminación RGB y switches Cherry MX', 129.99, 'Accesorios', GETDATE(), 1),
    ('Monitor Samsung 24"', 'Monitor Samsung de 24 pulgadas Full HD con panel IPS', 199.99, 'Electrónicos', GETDATE(), 1),
    ('Auriculares Sony WH-1000XM4', 'Auriculares inalámbricos con cancelación de ruido activa', 299.99, 'Audio', GETDATE(), 1),
    ('Webcam Logitech C920', 'Webcam Full HD 1080p con micrófono integrado', 89.99, 'Accesorios', GETDATE(), 1),
    ('Disco Duro Externo 1TB', 'Disco duro externo portátil de 1TB USB 3.0', 59.99, 'Almacenamiento', GETDATE(), 1),
    ('Router WiFi 6', 'Router inalámbrico WiFi 6 de alta velocidad', 149.99, 'Redes', GETDATE(), 1),
    ('Tablet iPad Air', 'Tablet iPad Air de 10.9 pulgadas con chip M1', 599.99, 'Electrónicos', GETDATE(), 1),
    ('Impresora HP LaserJet', 'Impresora láser monocromática HP LaserJet Pro', 179.99, 'Oficina', GETDATE(), 1),
    ('Smartphone Samsung Galaxy', 'Smartphone Samsung Galaxy S23 con 128GB de almacenamiento', 749.99, 'Electrónicos', GETDATE(), 1),
    ('Cargador Inalámbrico', 'Cargador inalámbrico rápido compatible con Qi', 29.99, 'Accesorios', GETDATE(), 1),
    ('SSD Samsung 1TB', 'Disco sólido Samsung EVO 970 de 1TB NVMe', 119.99, 'Almacenamiento', GETDATE(), 1),
    ('Micrófono Blue Yeti', 'Micrófono de condensador USB para streaming y podcasting', 99.99, 'Audio', GETDATE(), 1),
    ('Switch de Red 8 Puertos', 'Switch Gigabit de 8 puertos para red doméstica', 39.99, 'Redes', GETDATE(), 1);
GO

-- Verificar que los datos se insertaron correctamente
DECLARE @ProductCount INT;
SELECT @ProductCount = COUNT(*) FROM Products;
PRINT 'Total de productos insertados: ' + CAST(@ProductCount AS VARCHAR(10));

-- Mostrar resumen por categorías
SELECT 
    Category as Categoria,
    COUNT(*) as Cantidad,
    AVG(Price) as PrecioPromedio
FROM Products 
GROUP BY Category
ORDER BY Cantidad DESC;
GO

PRINT '=== BASE DE DATOS CREADA EXITOSAMENTE ===';
PRINT 'Servidor: DESKTOP-QUB7HBB\SQLEXPRESS';
PRINT 'Base de datos: BlazorCrudDb';
PRINT 'Tabla: Products';
SELECT 'Productos creados: ' + CAST(COUNT(*) AS VARCHAR(10)) as Resumen FROM Products;
GO
