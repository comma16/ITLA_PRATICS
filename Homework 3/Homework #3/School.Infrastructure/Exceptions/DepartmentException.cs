namespace School.Infrastructure.Exceptions
{
    public class DepartmentException : Exception
    {
        public DepartmentException() { }
        public DepartmentException(string message) : base(message) { }
        public DepartmentException(string message, Exception innerException) : base(message, innerException) { }
    }
}
