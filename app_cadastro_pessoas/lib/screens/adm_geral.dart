import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart'; // Importe o serviço de API
import 'package:app_cadastro_pessoas/screens/adm_pessoas_screen.dart'; // Importe a tela de PESSOAS
import 'package:app_cadastro_pessoas/screens/adm_configuracao_mes_screen.dart';
import 'package:app_cadastro_pessoas/screens/login_screen.dart'; // Importe a tela de CONFIGURAÇÃO MÊS  
import 'package:app_cadastro_pessoas/screens/cadastro_screen.dart'; // Importe a tela de CADASTRO

class AdmGeralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administradores Cadastrados'),
      ),
      body: Column(
        children: [
          // Lista de administradores
          Expanded(
            child: FutureBuilder<List<String>>(
              future: ApiService.getAdmins(), // Método para buscar administradores
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar administradores'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum administrador cadastrado'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Botões
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navega para a tela de PESSOAS
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Administrador_Pessoas_Screen()),
                    );
                  },
                  child: Text('PESSOAS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navega para a tela de CONFIGURAÇÃO MÊS
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ConfiguracaoMesScreen()),
                    );
                  },
                  child: Text('CONFIGURAÇÃO MÊS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navega para a tela de CADASTRO
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroScreen()),
                    );
                  },
                  child: Text('CADASTRAR-SE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Volta para a tela de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('SAIR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}