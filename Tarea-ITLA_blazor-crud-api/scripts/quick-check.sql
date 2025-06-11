-- Script rápido para verificar el estado actual
USE BlazorCrudDb;
GO

-- Verificación rápida
SELECT 
    'BlazorCrudDb' as BaseDatos,
    COUNT(*) as TotalProductos,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) as ProductosActivos
FROM Products;
GO

-- Mostrar algunos productos para verificar
SELECT TOP 5
    Id,
    Name,
    Price,
    Category,
    IsActive
FROM Products
ORDER BY Id;
GO
