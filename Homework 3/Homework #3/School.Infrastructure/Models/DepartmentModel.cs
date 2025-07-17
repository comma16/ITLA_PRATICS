// This model might be used for DTOs or specific database representations
namespace School.Infrastructure.Models
{
    public class DepartmentModel
    {
        public int Id { get; set; }
        public string NombreDepartamento { get; set; }
        public string DescripcionDepartamento { get; set; }
    }
}
