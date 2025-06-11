using Microsoft.AspNetCore.Mvc;
using BlazorCrudApi.Data;
using Microsoft.EntityFrameworkCore;
using System.Text;
using BlazorCrudApi.Models;

namespace BlazorCrudApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DiagnosticController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public DiagnosticController(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpGet("database")]
        public async Task<IActionResult> CheckDatabase()
        {
            try
            {
                // Verificar si podemos conectar a la base de datos
                bool canConnect = await _context.Database.CanConnectAsync();
                
                // Obtener información sobre la base de datos
                var connectionString = _configuration.GetConnectionString("DefaultConnection");
                var sanitizedConnectionString = SanitizeConnectionString(connectionString);
                
                // Verificar si la base de datos existe
                bool dbExists = await _context.Database.EnsureCreatedAsync();
                
                // Contar productos en la base de datos
                int productCount = await _context.Products.CountAsync();

                return Ok(new
                {
                    Status = "Éxito",
                    CanConnect = canConnect,
                    DatabaseExists = dbExists,
                    ConnectionString = sanitizedConnectionString,
                    ProductCount = productCount,
                    ServerVersion = await _context.Database.ExecuteSqlRawAsync("SELECT @@VERSION") > 0 ? "SQL Server detectado" : "Desconocido",
                    Message = "La conexión a la base de datos está funcionando correctamente."
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Status = "Error",
                    Message = "No se pudo conectar a la base de datos",
                    Error = ex.Message,
                    InnerError = ex.InnerException?.Message,
                    ConnectionString = SanitizeConnectionString(_configuration.GetConnectionString("DefaultConnection"))
                });
            }
        }

        [HttpGet("create-database")]
        public async Task<IActionResult> CreateDatabase()
        {
            try
            {
                // Intentar crear la base de datos si no existe
                bool created = await _context.Database.EnsureCreatedAsync();
                
                // Verificar si hay productos, si no hay, crear datos de prueba
                if (!await _context.Products.AnyAsync())
                {
                    // Agregar datos de prueba
                    _context.Products.AddRange(
                        new Models.Product { Name = "Laptop Dell", Description = "Laptop Dell Inspiron 15", Price = 899.99m, Category = "Electrónicos" },
                        new Models.Product { Name = "Mouse Logitech", Description = "Mouse inalámbrico Logitech MX Master", Price = 79.99m, Category = "Accesorios" },
                        new Models.Product { Name = "Teclado Mecánico", Description = "Teclado mecánico RGB", Price = 129.99m, Category = "Accesorios" }
                    );
                    await _context.SaveChangesAsync();
                }

                return Ok(new
                {
                    Status = "Éxito",
                    DatabaseCreated = created,
                    Message = created ? "Base de datos creada correctamente" : "La base de datos ya existía",
                    ProductCount = await _context.Products.CountAsync()
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Status = "Error",
                    Message = "Error al crear la base de datos",
                    Error = ex.Message,
                    InnerError = ex.InnerException?.Message
                });
            }
        }

        [HttpPost("seed-data")]
        public async Task<IActionResult> SeedData()
        {
            try
            {
                // Verificar si ya hay productos
                int existingCount = await _context.Products.CountAsync();
                
                if (existingCount > 0)
                {
                    return Ok(new
                    {
                        Status = "Info",
                        Message = $"Ya existen {existingCount} productos en la base de datos",
                        ProductCount = existingCount
                    });
                }

                // Insertar datos de prueba
                var products = new List<Product>
                {
                    new Product { Name = "Laptop Dell Inspiron 15", Description = "Laptop Dell Inspiron 15 con procesador Intel Core i5, 8GB RAM, 256GB SSD", Price = 899.99m, Category = "Electrónicos" },
                    new Product { Name = "Mouse Logitech MX Master", Description = "Mouse inalámbrico Logitech MX Master 3 con sensor de alta precisión", Price = 79.99m, Category = "Accesorios" },
                    new Product { Name = "Teclado Mecánico RGB", Description = "Teclado mecánico con retroiluminación RGB y switches Cherry MX", Price = 129.99m, Category = "Accesorios" },
                    new Product { Name = "Monitor Samsung 24\"", Description = "Monitor Samsung de 24 pulgadas Full HD con panel IPS", Price = 199.99m, Category = "Electrónicos" },
                    new Product { Name = "Auriculares Sony WH-1000XM4", Description = "Auriculares inalámbricos con cancelación de ruido activa", Price = 299.99m, Category = "Audio" },
                    new Product { Name = "Webcam Logitech C920", Description = "Webcam Full HD 1080p con micrófono integrado", Price = 89.99m, Category = "Accesorios" },
                    new Product { Name = "Disco Duro Externo 1TB", Description = "Disco duro externo portátil de 1TB USB 3.0", Price = 59.99m, Category = "Almacenamiento" },
                    new Product { Name = "Router WiFi 6", Description = "Router inalámbrico WiFi 6 de alta velocidad", Price = 149.99m, Category = "Redes" },
                    new Product { Name = "Tablet iPad Air", Description = "Tablet iPad Air de 10.9 pulgadas con chip M1", Price = 599.99m, Category = "Electrónicos" },
                    new Product { Name = "Impresora HP LaserJet", Description = "Impresora láser monocromática HP LaserJet Pro", Price = 179.99m, Category = "Oficina" }
                };

                _context.Products.AddRange(products);
                await _context.SaveChangesAsync();

                return Ok(new
                {
                    Status = "Éxito",
                    Message = "Datos de prueba insertados correctamente",
                    ProductCount = products.Count
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Status = "Error",
                    Message = "Error al insertar datos de prueba",
                    Error = ex.Message
                });
            }
        }

        // Método para ocultar información sensible de la cadena de conexión
        private string SanitizeConnectionString(string connectionString)
        {
            if (string.IsNullOrEmpty(connectionString))
                return "No se encontró cadena de conexión";

            StringBuilder sanitized = new StringBuilder(connectionString);
            
            // Ocultar contraseña
            if (connectionString.Contains("Password=") || connectionString.Contains("pwd="))
            {
                int pwdStart = connectionString.IndexOf("Password=", StringComparison.OrdinalIgnoreCase);
                if (pwdStart == -1) pwdStart = connectionString.IndexOf("pwd=", StringComparison.OrdinalIgnoreCase);
                
                if (pwdStart != -1)
                {
                    int pwdEnd = connectionString.IndexOf(';', pwdStart);
                    if (pwdEnd == -1) pwdEnd = connectionString.Length;
                    
                    int valueStart = connectionString.IndexOf('=', pwdStart) + 1;
                    sanitized.Remove(valueStart, pwdEnd - valueStart);
                    sanitized.Insert(valueStart, "********");
                }
            }
            
            return sanitized.ToString();
        }
    }
}
