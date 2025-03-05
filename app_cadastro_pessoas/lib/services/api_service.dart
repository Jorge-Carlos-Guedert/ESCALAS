import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://localhost:7255'; // Substitua pelo endereço da sua API

  static Future<void> verificarConexao() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl /Pessoas/health'), // Endpoint de health check
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Conexão bem-sucedida
        print('Conexão com a API verificada com sucesso!');
      } else {
        // Erro na conexão
        throw Exception('Erro ao verificar conexão: ${response.statusCode}');
      }
    } catch (e) {
      // Erro de conexão ou outros problemas
      throw Exception('Erro ao conectar à API: $e');
    }
  }

  static Future<void> cadastrarPessoa(Map<String, dynamic> pessoa) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/Pessoas/cadastrar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(pessoa), // O campo 'funcao' já é booleano
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Pessoa cadastrada com sucesso!');
    } else {
      throw Exception('Erro ao cadastrar pessoa: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro ao conectar à API: $e');
  }
}


// Método para buscar administradores
  static Future<List<String>> getAdmins() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Pessoas/getAdmins'), // Endpoint para buscar administradores
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Converte a resposta JSON para uma lista de strings
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.cast<String>(); // Converte para List<String>
      } else {
        // Erro na requisição
        throw Exception('Erro ao buscar administradores: ${response.statusCode}');
      }
    } catch (e) {
      // Erro de conexão ou outros problemas
      throw Exception('Erro ao conectar à API: $e');
    }
  }

static Future<List<Map<String, dynamic>>> getPessoas() async {
  final response = await http.get(Uri.parse('$baseUrl/pessoas'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((pessoa) => {
      'id': pessoa['id'],
      'nome': pessoa['nome'],
      'email': pessoa['email'],
      'senha': pessoa['senha'],
      'isAdmin': pessoa['isAdmin'],
    }).toList();
  } else {
    throw Exception('Erro ao carregar pessoas');
  }
}
 
 

static Future<Map<String, dynamic>?> getPessoaPorId(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/pessoas/$id'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Erro ao carregar dados da pessoa');
  }
}
static Future<void> excluirPessoa(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/pessoas/excluir/$id'), // Endpoint de exclusão
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao excluir pessoa: ${response.body}');
  }
}

static Future<void> atualizarPessoa(int id, Map<String, dynamic> dados) async {
  // Verifica o valor de id
  print('ID recebido: $id'); // Deve imprimir 8

  // Constrói a URI
  final uri = Uri.parse('$baseUrl/pessoas/atualizar/$id');
  print('URI: $uri'); // Deve imprimir algo como: https://sua-api.com/pessoas/atualizar?id=8

  final response = await http.put(
    uri, // Usa a URI construída
    headers: {'Content-Type': 'application/json'},
    body: json.encode(dados),
  );

  if (response.statusCode != 200) {
    throw Exception('Erro ao atualizar pessoa: ${response.body}');
  }
}

  static Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Pessoas/login'), // Endpoint de login
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        // Login bem-sucedido
        return true;
      } else if (response.statusCode == 401) {
        // Credenciais inválidas
        return false;
      } else {
        // Outros erros
        throw Exception('Erro ao fazer login: ${response.statusCode}');
      }
    } catch (e) {
      // Erro de conexão ou outros problemas
      throw Exception('Erro ao conectar à API: $e');
    }
  }

  static Future<bool> isAdmin(String email) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/Pessoas/isAdmin'), // Endpoint para verificar se é admin
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email, // Envia o email para o backend
      }),
    );

    if (response.statusCode == 200) {
      // Converte a resposta JSON para um Map
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Verifica se o usuário é administrador
      return responseData['isAdmin'] ?? false; // Retorna true se for admin, caso contrário, false
    } else {
      // Erro na requisição
      throw Exception('Erro ao verificar se o usuário é administrador: ${response.statusCode}');
    }
  } catch (e) {
    // Erro de conexão ou outros problemas
    throw Exception('Erro ao conectar à API: $e');
  }
}
}