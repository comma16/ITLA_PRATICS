using BlazorCrudApi.Models;

namespace BlazorCrudApi.Services
{
    public interface IApiService
    {
        Task<List<Product>> GetProductsAsync(string? searchTerm = null);
        Task<Product?> GetProductByIdAsync(int id);
        Task<Product?> CreateProductAsync(Product product);
        Task<Product?> UpdateProductAsync(int id, Product product);
        Task<bool> DeleteProductAsync(int id);
        Task<object?> CheckDatabaseAsync();
        Task<object?> CreateDatabaseAsync();
        Task<object?> SeedDataAsync();
    }
}
