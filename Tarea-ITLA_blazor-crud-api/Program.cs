using Microsoft.EntityFrameworkCore;
using BlazorCrudApi.Data;
using BlazorCrudApi.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

// Add Entity Framework
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add API Controllers
builder.Services.AddControllers();

// Add Services
builder.Services.AddScoped<IProductService, ProductService>();

// Configure HTTP Client for Blazor Server
builder.Services.AddHttpClient<IApiService, ApiService>((serviceProvider, client) =>
{
    var httpContextAccessor = serviceProvider.GetService<IHttpContextAccessor>();
    var httpContext = httpContextAccessor?.HttpContext;
    
    if (httpContext != null)
    {
        var request = httpContext.Request;
        var baseUrl = $"{request.Scheme}://{request.Host}";
        client.BaseAddress = new Uri(baseUrl);
    }
    else
    {
        // Fallback para desarrollo
        client.BaseAddress = new Uri("https://localhost:7000/"); // Ajusta según tu puerto
    }
});

// Add HttpContextAccessor
builder.Services.AddHttpContextAccessor();

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseCors("AllowAll");

app.MapRazorPages();
app.MapBlazorHub();
app.MapFallbackToPage("/_Host");
app.MapControllers();

// Create database and seed data if it doesn't exist
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<ApplicationDbContext>();
        var logger = services.GetRequiredService<ILogger<Program>>();
        
        logger.LogInformation("Intentando crear/actualizar la base de datos...");
        bool created = context.Database.EnsureCreated();
        logger.LogInformation(created 
            ? "Base de datos creada correctamente." 
            : "La base de datos ya existía.");
        
        // Verificar si hay datos, si no hay, sembrar datos iniciales
        if (!context.Products.Any())
        {
            logger.LogInformation("Sembrando datos iniciales...");
            context.Products.AddRange(
                new BlazorCrudApi.Models.Product { Name = "Laptop Dell", Description = "Laptop Dell Inspiron 15", Price = 899.99m, Category = "Electrónicos" },
                new BlazorCrudApi.Models.Product { Name = "Mouse Logitech", Description = "Mouse inalámbrico Logitech MX Master", Price = 79.99m, Category = "Accesorios" },
                new BlazorCrudApi.Models.Product { Name = "Teclado Mecánico", Description = "Teclado mecánico RGB", Price = 129.99m, Category = "Accesorios" }
            );
            context.SaveChanges();
            logger.LogInformation("Datos iniciales sembrados correctamente.");
        }
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Error al crear/inicializar la base de datos.");
    }
}

app.Run();
