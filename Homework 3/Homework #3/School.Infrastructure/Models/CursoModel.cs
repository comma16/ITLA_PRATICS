// This model might be used for DTOs or specific database representations
namespace School.Infrastructure.Models
{
    public class CursoModel
    {
        public int Id { get; set; }
        public string NombreCurso { get; set; }
        public string DescripcionCurso { get; set; }
        public int IdDepartamento { get; set; }
    }
}
