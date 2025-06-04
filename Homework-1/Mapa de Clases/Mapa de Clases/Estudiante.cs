using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Mapa_de_Clases
{
    public class Estudiante : MiembroDeLaComunidad
    {
        public string Carrera { get; set; }
        public int Semestre { get; set; }
    }
}
