-- Procedimientos almacenados para operaciones CRUD
USE BlazorCrudDb;
GO

-- Procedimiento para obtener todos los productos activos
CREATE OR ALTER PROCEDURE sp_GetAllProducts
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        Name,
        Description,
        Price,
        Category,
        CreatedAt,
        IsActive
    FROM Products 
    WHERE IsActive = 1
    ORDER BY CreatedAt DESC;
END
GO

-- Procedimiento para buscar productos
CREATE OR ALTER PROCEDURE sp_SearchProducts
    @SearchTerm NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        Name,
        Description,
        Price,
        Category,
        CreatedAt,
        IsActive
    FROM Products 
    WHERE IsActive = 1
        AND (
            Name LIKE '%' + @SearchTerm + '%' OR
            Description LIKE '%' + @SearchTerm + '%' OR
            Category LIKE '%' + @SearchTerm + '%'
        )
    ORDER BY CreatedAt DESC;
END
GO

-- Procedimiento para obtener un producto por ID
CREATE OR ALTER PROCEDURE sp_GetProductById
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        Id,
        Name,
        Description,
        Price,
        Category,
        CreatedAt,
        IsActive
    FROM Products 
    WHERE Id = @Id AND IsActive = 1;
END
GO

-- Procedimiento para crear un producto
CREATE OR ALTER PROCEDURE sp_CreateProduct
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(18,2),
    @Category NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Products (Name, Description, Price, Category, CreatedAt, IsActive)
    VALUES (@Name, @Description, @Price, @Category, GETDATE(), 1);
    
    SELECT SCOPE_IDENTITY() as NewProductId;
END
GO

-- Procedimiento para actualizar un producto
CREATE OR ALTER PROCEDURE sp_UpdateProduct
    @Id INT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(18,2),
    @Category NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Products 
    SET 
        Name = @Name,
        Description = @Description,
        Price = @Price,
        Category = @Category
    WHERE Id = @Id AND IsActive = 1;
    
    SELECT @@ROWCOUNT as RowsAffected;
END
GO

-- Procedimiento para eliminar un producto (soft delete)
CREATE OR ALTER PROCEDURE sp_DeleteProduct
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Products 
    SET IsActive = 0
    WHERE Id = @Id;
    
    SELECT @@ROWCOUNT as RowsAffected;
END
GO

-- Procedimiento para obtener estadísticas
CREATE OR ALTER PROCEDURE sp_GetProductStats
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) as TotalProductos,
        COUNT(CASE WHEN IsActive = 1 THEN 1 END) as ProductosActivos,
        COUNT(CASE WHEN IsActive = 0 THEN 1 END) as ProductosEliminados,
        AVG(CASE WHEN IsActive = 1 THEN Price END) as PrecioPromedio,
        MIN(CASE WHEN IsActive = 1 THEN Price END) as PrecioMinimo,
        MAX(CASE WHEN IsActive = 1 THEN Price END) as PrecioMaximo,
        COUNT(DISTINCT Category) as TotalCategorias
    FROM Products;
END
GO

PRINT 'Procedimientos almacenados creados exitosamente.';
