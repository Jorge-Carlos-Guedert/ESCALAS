using AppCadastroPessoasAPI.Data;
using AppCadastroPessoasAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AppCadastroPessoasAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ConfigurarCalendariosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ConfigurarCalendariosController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("{ano}/{mes}")]
        public async Task<IActionResult> GetHorarios(int ano, int mes)
        {
            var horarios = await _context.ConfigurarCalendarios
                .Where(h => h.Ano == ano && h.Mes == mes)
                .ToListAsync();
            return Ok(horarios);
        }

        [HttpPost]
        public async Task<IActionResult> SalvarHorarios(List<ConfigurarCalendario> horarios)
        {
            _context.ConfigurarCalendarios.AddRange(horarios);
            await _context.SaveChangesAsync();
            return Ok();
        }
    }
}