import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/login_screen.dart';
import 'package:app_cadastro_pessoas/services/http_overrides.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  try {
    await ApiService.verificarConexao();
    print('Conexão com o banco de dados verificada com sucesso!');
  } catch (e) {
    print('Erro ao verificar conexão com o banco de dados: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cadastro de Pessoas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}