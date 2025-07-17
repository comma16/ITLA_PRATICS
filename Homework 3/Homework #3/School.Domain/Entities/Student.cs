using School.Domain.Core;

namespace School.Domain.Entities
{
    public class Student : Person
    {
        public string Major { get; set; }
        public int EnrollmentYear { get; set; }
    }
}
