-- Script para probar la conexión y verificar la configuración
-- Ejecutar en SQL Server Management Studio conectado a DESKTOP-QUB7HBB\SQLEXPRESS

-- Verificar información del servidor
SELECT 
    @@SERVERNAME as NombreServidor,
    @@VERSION as VersionSQL,
    GETDATE() as FechaHoraActual;
GO

-- Verificar que la base de datos existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BlazorCrudDb')
BEGIN
    PRINT '✅ Base de datos BlazorCrudDb encontrada';
    
    USE BlazorCrudDb;
    
    -- Verificar la tabla Products
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
    BEGIN
        PRINT '✅ Tabla Products encontrada';
        
        -- Mostrar estadísticas de la tabla
        SELECT 
            COUNT(*) as TotalProductos,
            COUNT(CASE WHEN IsActive = 1 THEN 1 END) as ProductosActivos,
            MIN(Price) as PrecioMinimo,
            MAX(Price) as PrecioMaximo,
            AVG(Price) as PrecioPromedio
        FROM Products;
        
        -- Mostrar productos por categoría
        SELECT 
            Category,
            COUNT(*) as Cantidad
        FROM Products 
        WHERE IsActive = 1
        GROUP BY Category
        ORDER BY Cantidad DESC;
        
        -- Mostrar los primeros 5 productos
        SELECT TOP 5
            Id,
            Name,
            Price,
            Category
        FROM Products
        WHERE IsActive = 1
        ORDER BY CreatedAt DESC;
        
    END
    ELSE
    BEGIN
        PRINT '❌ Tabla Products NO encontrada';
    END
END
ELSE
BEGIN
    PRINT '❌ Base de datos BlazorCrudDb NO encontrada';
    PRINT 'Ejecuta primero el script create-database-sqlexpress.sql';
END
GO
