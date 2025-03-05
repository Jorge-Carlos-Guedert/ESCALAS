using Microsoft.AspNetCore.Mvc;
using AppCadastroPessoasAPI.Data;
using AppCadastroPessoasAPI.Models;
using System.Linq;
using System;

namespace AppCadastroPessoasAPI.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class PessoasController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PessoasController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var pessoas = _context.Pessoas.ToList();
            return Ok(pessoas);
        }

        [HttpPost("cadastrar")]
        public IActionResult Post(Pessoa pessoa)
        {
            if (pessoa == null)
            {
                return BadRequest("Dados inválidos.");
            }

            // Verifica se já existe uma pessoa com o mesmo nome OU o mesmo email
            var pessoaExistente = _context.Pessoas.FirstOrDefault(p => p.Nome == pessoa.Nome || p.Email == pessoa.Email);
            if (pessoaExistente != null)
            {
                return Conflict("Usuário já cadastrado com o mesmo nome ou email.");
            }

            Console.WriteLine($"Função recebida: {pessoa.IsAdmin}");
            _context.Pessoas.Add(pessoa);
            _context.SaveChanges();
            return Ok(pessoa);
        }

        [HttpGet("health")]
        public IActionResult HealthCheck()
        {
            return Ok("API está funcionando!");
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            try
            {
                // Validação dos dados de entrada
                if (request == null || string.IsNullOrEmpty(request.Email) || string.IsNullOrEmpty(request.Senha))
                {
                    return BadRequest("Dados de login inválidos.");
                }

                // Busca o usuário no banco de dados
                var usuario = _context.Pessoas.FirstOrDefault(p => p.Email == request.Email && p.Senha == request.Senha);
                if (usuario == null)
                {
                    return Unauthorized("Credenciais inválidas.");
                }

                // Retorna sucesso
                return Ok(new { Message = "Login bem-sucedido!", Usuario = usuario });
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }

        [HttpGet("getUsers")]
        public IActionResult GetUsers()
        {
            try
            {
                // Busca os nomes e IDs das pessoas no banco de dados
                var usuarios = _context.Pessoas
                    .OrderBy(p => p.Nome) // Ordena por nome
                    .Select(p => new
                    {
                        Id = p.Id,       // Seleciona o ID
                        Nome = p.Nome    // Seleciona o nome
                    })
                    .ToList();

                // Retorna a lista de objetos com ID e nome
                return Ok(usuarios);
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }

        [HttpPost("isAdmin")]
        public IActionResult IsAdmin([FromBody] IsAdminRequest request)
        {
            try
            {
                // Validação dos dados de entrada
                if (request == null || string.IsNullOrEmpty(request.Email))
                {
                    return BadRequest("Email inválido.");
                }

                // Busca o usuário no banco de dados
                var usuario = _context.Pessoas.FirstOrDefault(p => p.Email == request.Email);
                if (usuario == null)
                {
                    return NotFound("Usuário não encontrado.");
                }

                // Retorna se o usuário é administrador
                return Ok(new { IsAdmin = usuario.IsAdmin });
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }

        [HttpGet("getAdmins")]
        public IActionResult GetAdmins()
        {
            try
            {
                // Busca os nomes das pessoas onde IsAdmin é true
                var admins = _context.Pessoas
                    .Where(p => p.IsAdmin) // Filtra apenas os administradores
                    .Select(p => p.Nome)   // Seleciona apenas o nome
                    .OrderBy(nome => nome) // Ordena os nomes
                    .ToList();

                // Retorna a lista de nomes dos administradores
                return Ok(admins);
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }
        [HttpDelete("excluir/{id}")]
        public IActionResult Excluir( int? id = null)
        {
            try
            {
                // Verifica se o nome ou o ID foi fornecido
                if (!id.HasValue)
                {
                    return BadRequest("Forneça um ID para excluir a pessoa.");
                }

                Pessoa pessoaParaExcluir = null;

                // Busca a pessoa pelo  ID
                if (id.HasValue)
                {
                    pessoaParaExcluir = _context.Pessoas.FirstOrDefault(p => p.Id == id.Value);
                }

                // Verifica se a pessoa foi encontrada
                if (pessoaParaExcluir == null)
                {
                    return NotFound("Pessoa não encontrada.");
                }

                // Remove a pessoa do banco de dados
                _context.Pessoas.Remove(pessoaParaExcluir);
                _context.SaveChanges();

                return Ok("Pessoa excluída com sucesso.");
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }

        [HttpPut("atualizar/{id}")]
        public IActionResult Atualizar( int id, [FromBody] Pessoa pessoaAtualizada)
        {
            try
            {
                // Verifica se os dados da pessoa atualizada são válidos
                if (pessoaAtualizada == null)
                {
                    return BadRequest("Dados inválidos.");
                }

                // Busca a pessoa pelo ID
                var pessoaExistente = _context.Pessoas.FirstOrDefault(p => p.Id == id);
                if (pessoaExistente == null)
                {
                    return NotFound("Pessoa não encontrada.");
                }

                // Atualiza os dados da pessoa
                pessoaExistente.Nome = pessoaAtualizada.Nome;
                pessoaExistente.Email = pessoaAtualizada.Email;
                pessoaExistente.Senha = pessoaAtualizada.Senha;
                pessoaExistente.IsAdmin = pessoaAtualizada.IsAdmin;

                // Salva as alterações no banco de dados
                _context.Pessoas.Update(pessoaExistente);
                _context.SaveChanges();

                return Ok("Pessoa atualizada com sucesso.");
            }
            catch (Exception ex)
            {
                // Retorna erro interno
                return StatusCode(500, $"Erro interno: {ex.Message}");
            }
        }
    }
}