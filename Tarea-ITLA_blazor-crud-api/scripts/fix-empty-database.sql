-- Script para verificar y corregir la base de datos vacía
USE BlazorCrudDb;
GO

-- Verificar si la tabla Products existe y tiene datos
PRINT '=== DIAGNÓSTICO DE LA BASE DE DATOS ===';
PRINT 'Servidor: ' + @@SERVERNAME;
PRINT 'Base de datos: ' + DB_NAME();
PRINT 'Fecha: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '';

-- Verificar estructura de la tabla
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    PRINT '✅ Tabla Products existe';
    
    -- Contar productos
    DECLARE @ProductCount INT;
    SELECT @ProductCount = COUNT(*) FROM Products;
    PRINT 'Total de productos en la tabla: ' + CAST(@ProductCount AS VARCHAR(10));
    
    -- Si no hay productos, insertarlos
    IF @ProductCount = 0
    BEGIN
        PRINT '';
        PRINT '⚠️  La tabla está vacía. Insertando datos de prueba...';
        
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
        
        -- Verificar inserción
        SELECT @ProductCount = COUNT(*) FROM Products;
        PRINT '✅ Productos insertados: ' + CAST(@ProductCount AS VARCHAR(10));
    END
    ELSE
    BEGIN
        PRINT '✅ La tabla ya tiene datos';
        
        -- Mostrar productos existentes
        PRINT '';
        PRINT '=== PRODUCTOS EXISTENTES ===';
        SELECT 
            Id,
            Name,
            Price,
            Category,
            IsActive,
            CreatedAt
        FROM Products
        ORDER BY Id;
    END
    
    -- Mostrar estadísticas finales
    PRINT '';
    PRINT '=== ESTADÍSTICAS FINALES ===';
    SELECT 
        COUNT(*) as TotalProductos,
        COUNT(CASE WHEN IsActive = 1 THEN 1 END) as ProductosActivos,
        COUNT(CASE WHEN IsActive = 0 THEN 1 END) as ProductosInactivos
    FROM Products;
    
    -- Productos por categoría
    PRINT '';
    PRINT '=== PRODUCTOS POR CATEGORÍA ===';
    SELECT 
        Category,
        COUNT(*) as Cantidad,
        AVG(Price) as PrecioPromedio
    FROM Products 
    WHERE IsActive = 1
    GROUP BY Category
    ORDER BY Cantidad DESC;
    
END
ELSE
BEGIN
    PRINT '❌ La tabla Products NO existe';
    PRINT 'Creando tabla Products...';
    
    -- Crear la tabla si no existe
    CREATE TABLE Products (
        Id int IDENTITY(1,1) PRIMARY KEY,
        Name nvarchar(100) NOT NULL,
        Description nvarchar(500) NULL,
        Price decimal(18,2) NOT NULL CHECK (Price >= 0),
        Category nvarchar(50) NOT NULL,
        CreatedAt datetime2 NOT NULL DEFAULT GETDATE(),
        IsActive bit NOT NULL DEFAULT 1
    );
    
    -- Crear índices
    CREATE INDEX IX_Products_Category ON Products(Category);
    CREATE INDEX IX_Products_IsActive ON Products(IsActive);
    CREATE INDEX IX_Products_CreatedAt ON Products(CreatedAt DESC);
    CREATE INDEX IX_Products_Name ON Products(Name);
    
    PRINT '✅ Tabla Products creada';
    
    -- Insertar datos
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
    
    PRINT '✅ Datos insertados correctamente';
END
GO

PRINT '';
PRINT '=== PROCESO COMPLETADO ===';
PRINT 'La base de datos está lista para usar con la aplicación Blazor.';
