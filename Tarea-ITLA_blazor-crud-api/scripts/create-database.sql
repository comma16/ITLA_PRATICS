-- Crear la base de datos
USE master;
GO

-- Eliminar la base de datos si existe (opcional)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BlazorCrudDb')
BEGIN
    ALTER DATABASE BlazorCrudDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BlazorCrudDb;
END
GO

-- Crear la nueva base de datos
CREATE DATABASE BlazorCrudDb;
GO

-- Usar la base de datos recién creada
USE BlazorCrudDb;
GO

-- Crear la tabla Products
CREATE TABLE Products (
    Id int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Description nvarchar(500) NULL,
    Price decimal(18,2) NOT NULL,
    Category nvarchar(50) NOT NULL,
    CreatedAt datetime2 NOT NULL DEFAULT GETDATE(),
    IsActive bit NOT NULL DEFAULT 1
);
GO

-- Crear índices para mejorar el rendimiento
CREATE INDEX IX_Products_Category ON Products(Category);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_Products_CreatedAt ON Products(CreatedAt DESC);
GO

-- Insertar datos de prueba
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
    ('Impresora HP LaserJet', 'Impresora láser monocromática HP LaserJet Pro', 179.99, 'Oficina', GETDATE(), 1);
GO

-- Verificar que los datos se insertaron correctamente
SELECT COUNT(*) as TotalProductos FROM Products;
SELECT * FROM Products ORDER BY CreatedAt DESC;
GO

PRINT 'Base de datos BlazorCrudDb creada exitosamente con ' + CAST((SELECT COUNT(*) FROM Products) AS VARCHAR(10)) + ' productos de prueba.';
