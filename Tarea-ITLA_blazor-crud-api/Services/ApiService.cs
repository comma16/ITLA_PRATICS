using BlazorCrudApi.Models;
using System.Text.Json;
using System.Text;

namespace BlazorCrudApi.Services
{
    public class ApiService : IApiService
    {
        private readonly HttpClient _httpClient;
        private readonly ILogger<ApiService> _logger;

        public ApiService(HttpClient httpClient, ILogger<ApiService> logger)
        {
            _httpClient = httpClient;
            _logger = logger;
        }

        public async Task<List<Product>> GetProductsAsync(string? searchTerm = null)
        {
            try
            {
                var url = string.IsNullOrWhiteSpace(searchTerm) 
                    ? "api/products" 
                    : $"api/products?search={Uri.EscapeDataString(searchTerm)}";
                
                _logger.LogInformation($"Llamando a: {url}");
                
                var response = await _httpClient.GetAsync(url);
                response.EnsureSuccessStatusCode();
                
                var json = await response.Content.ReadAsStringAsync();
                var products = JsonSerializer.Deserialize<List<Product>>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
                
                return products ?? new List<Product>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener productos");
                throw;
            }
        }

        public async Task<Product?> GetProductByIdAsync(int id)
        {
            try
            {
                var response = await _httpClient.GetAsync($"api/products/{id}");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<Product>(json, new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    });
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al obtener producto {id}");
                throw;
            }
        }

        public async Task<Product?> CreateProductAsync(Product product)
        {
            try
            {
                var json = JsonSerializer.Serialize(product);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                
                var response = await _httpClient.PostAsync("api/products", content);
                if (response.IsSuccessStatusCode)
                {
                    var responseJson = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<Product>(responseJson, new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    });
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al crear producto");
                throw;
            }
        }

        public async Task<Product?> UpdateProductAsync(int id, Product product)
        {
            try
            {
                var json = JsonSerializer.Serialize(product);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                
                var response = await _httpClient.PutAsync($"api/products/{id}", content);
                if (response.IsSuccessStatusCode)
                {
                    var responseJson = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<Product>(responseJson, new JsonSerializerOptions
                    {
                        PropertyNameCaseInsensitive = true
                    });
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al actualizar producto {id}");
                throw;
            }
        }

        public async Task<bool> DeleteProductAsync(int id)
        {
            try
            {
                var response = await _httpClient.DeleteAsync($"api/products/{id}");
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al eliminar producto {id}");
                throw;
            }
        }

        public async Task<object?> CheckDatabaseAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync("api/diagnostic/database");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<object>(json);
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al verificar base de datos");
                throw;
            }
        }

        public async Task<object?> CreateDatabaseAsync()
        {
            try
            {
                var response = await _httpClient.GetAsync("api/diagnostic/create-database");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<object>(json);
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al crear base de datos");
                throw;
            }
        }

        public async Task<object?> SeedDataAsync()
        {
            try
            {
                var response = await _httpClient.PostAsync("api/diagnostic/seed-data", null);
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    return JsonSerializer.Deserialize<object>(json);
                }
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al insertar datos de prueba");
                throw;
            }
        }
    }
}
