-- Script para verificar la base de datos y tablas
USE BlazorCrudDb;
GO

-- Verificar información de la base de datos
SELECT 
    DB_NAME() as NombreBaseDatos,
    GETDATE() as FechaVerificacion;
GO

-- Verificar estructura de la tabla Products
SELECT 
    COLUMN_NAME as NombreColumna,
    DATA_TYPE as TipoDato,
    IS_NULLABLE as PermiteNulos,
    COLUMN_DEFAULT as ValorPorDefecto,
    CHARACTER_MAXIMUM_LENGTH as LongitudMaxima
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;
GO

-- Verificar datos en la tabla
SELECT 
    COUNT(*) as TotalProductos,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) as ProductosActivos,
    COUNT(CASE WHEN IsActive = 0 THEN 1 END) as ProductosInactivos,
    MIN(CreatedAt) as PrimerProducto,
    MAX(CreatedAt) as UltimoProducto
FROM Products;
GO

-- Mostrar productos por categoría
SELECT 
    Category as Categoria,
    COUNT(*) as CantidadProductos,
    AVG(Price) as PrecioPromedio,
    MIN(Price) as PrecioMinimo,
    MAX(Price) as PrecioMaximo
FROM Products 
WHERE IsActive = 1
GROUP BY Category
ORDER BY CantidadProductos DESC;
GO

-- Mostrar los primeros 5 productos
SELECT TOP 5
    Id,
    Name as Nombre,
    Price as Precio,
    Category as Categoria,
    CreatedAt as FechaCreacion
FROM Products 
WHERE IsActive = 1
ORDER BY CreatedAt DESC;
GO
