using School.Domain.Core;

namespace School.Domain.Entities
{
    public class Instructor : Person
    {
        public string Specialization { get; set; }
        public decimal Rating { get; set; }
    }
}
