namespace School.Infrastructure.Exceptions
{
    public class CourseException : Exception
    {
        public CourseException() { }
        public CourseException(string message) : base(message) { }
        public CourseException(string message, Exception innerException) : base(message, innerException) { }
    }
}
