// This interface is typically defined in the Domain layer.
// It's included here as per the provided image structure.
using School.Domain.Entities;
using School.Domain.Repository;

namespace School.Infrastructure.Interfaces
{
    public interface IDepartmentRepository : IBaseRepository<Department>
    {
        Task<Department> GetDepartmentByNameAsync(string name);
    }
}
