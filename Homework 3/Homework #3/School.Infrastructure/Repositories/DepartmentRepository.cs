using School.Domain.Entities;
using School.Infrastructure.Context;
using School.Infrastructure.Core;
using School.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace School.Infrastructure.Repositories
{
    public class DepartmentRepository : BaseRepository<Department>, IDepartmentRepository
    {
        public DepartmentRepository(SchoolContext context) : base(context) { }

        public async Task<Department> GetDepartmentByNameAsync(string name)
        {
            return await _dbSet.FirstOrDefaultAsync(d => d.Name == name && d.IsActive);
        }
    }
}
