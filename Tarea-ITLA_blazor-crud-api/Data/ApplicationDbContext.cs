using Microsoft.EntityFrameworkCore;
using BlazorCrudApi.Models;

namespace BlazorCrudApi.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Product> Products { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configuración del modelo Product
            modelBuilder.Entity<Product>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Description).HasMaxLength(500);
                entity.Property(e => e.Price).HasColumnType("decimal(18,2)");
                entity.Property(e => e.Category).IsRequired().HasMaxLength(50);
                entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETDATE()");
            });

            // Datos de prueba
            modelBuilder.Entity<Product>().HasData(
                new Product { Id = 1, Name = "Laptop Dell", Description = "Laptop Dell Inspiron 15", Price = 899.99m, Category = "Electrónicos" },
                new Product { Id = 2, Name = "Mouse Logitech", Description = "Mouse inalámbrico Logitech MX Master", Price = 79.99m, Category = "Accesorios" },
                new Product { Id = 3, Name = "Teclado Mecánico", Description = "Teclado mecánico RGB", Price = 129.99m, Category = "Accesorios" }
            );
        }
    }
}
