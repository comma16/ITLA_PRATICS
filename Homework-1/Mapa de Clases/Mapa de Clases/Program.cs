using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System;

namespace Mapa_de_Clases
{
    class Program
    {
        static void Main(string[] args)
        {
            Estudiante estudiante = new Estudiante
            {
                Nombre = "Juan Sebastián Peña Estevez",
                Identificacion = "2024-1732",
                Carrera = "Desarrollo de Software",
                Semestre = 3
            };

            Console.WriteLine($"Estudiante: {estudiante.Nombre}, Carrera: {estudiante.Carrera}, Semestre: {estudiante.Semestre}");
        }
    }
}
