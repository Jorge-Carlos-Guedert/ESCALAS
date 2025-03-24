import 'package:app_cadastro_pessoas/screens/config_mes.dart';
import 'package:app_cadastro_pessoas/screens/config_semana.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/adm_pessoas_screen.dart';
import 'package:app_cadastro_pessoas/screens/login_screen.dart';
import 'package:app_cadastro_pessoas/screens/cadastro_screen.dart';


class AdmGeralScreen extends StatefulWidget {
  @override
  _AdmGeralScreenState createState() => _AdmGeralScreenState();
}

class _AdmGeralScreenState extends State<AdmGeralScreen> {
  bool _configuracaoSemanaSalva = false; // Estado para controlar se as configurações foram salvas

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reseta o estado ao retornar à tela
    _configuracaoSemanaSalva = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador Geral'),
      ),
      body: Column(
        children: [
          // Lista de administradores
          Expanded(
            child: FutureBuilder<List<String>>(
              future: ApiService.getAdmins(),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Administrador_Pessoas_Screen()),
                    );
                  },
                  child: Text('PESSOAS'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Navega para a tela de CONFIGURAÇÃO SEMANA e aguarda o resultado
                    final bool? salvo = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfiguracaoSemanaScreen(ano: null, mes: null,)),
                    );

                    // Atualiza o estado se as configurações foram salvas
                    if (salvo == true) {
                      setState(() {
                        _configuracaoSemanaSalva = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _configuracaoSemanaSalva ? Colors.green : null, // Altera a cor do botão
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('CONFIGURAÇÃO SEMANA'),
                      if (_configuracaoSemanaSalva) // Adiciona um ícone de checkmark
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, color: Colors.white),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ConfiguracaoMesScreen()),
                    );
                  },
                  child: Text('CONFIGURAÇÃO MÊS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroScreen()),
                    );
                  },
                  child: Text('CADASTRAR'),
                ),
                ElevatedButton(
                  onPressed: () {
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