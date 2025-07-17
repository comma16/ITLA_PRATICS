using School.Domain.Entities;

namespace School.Domain.Repository
{
    public interface IDepartmentRepository : IBaseRepository<Department>
    {
        Task<Department> GetDepartmentByNameAsync(string name);
    }
}
