using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using AppCadastroPessoasAPI.Models;
using System.Globalization;

namespace AppCadastroPessoasAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Pessoa> Pessoas { get; set; }
        public DbSet<ConfigurarCalendario> ConfigurarCalendarios { get; set; }
    }


    


}