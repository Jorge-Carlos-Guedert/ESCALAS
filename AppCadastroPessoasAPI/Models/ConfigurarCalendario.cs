using Auth0.ManagementApi.Models.Forms;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AppCadastroPessoasAPI.Models
{
    public class ConfigurarCalendario
    {
        public int Id { get; set; } // Chave primária
        public int Ano { get; set; } // Ano do horário

        public int Mes { get; set; }// Mês do horário
        public int DiaMes { get; set; }// Dia do mês (ex: 1, 2, 3, ...)
        public string DiaSemana { get; set; } // Dia da semana (ex: "Segunda-feira")
        public string Horario { get; set; } // Horário (ex: "09:00")
        public int Quantidade { get; set; } // Quantidade (ex: 10)
    }

    
}
