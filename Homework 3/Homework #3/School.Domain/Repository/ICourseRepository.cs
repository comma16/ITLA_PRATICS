using School.Domain.Entities;

namespace School.Domain.Repository
{
    public interface ICourseRepository : IBaseRepository<Course>
    {
        Task<IEnumerable<Course>> GetCoursesByDepartmentAsync(int departmentId);
    }
}
