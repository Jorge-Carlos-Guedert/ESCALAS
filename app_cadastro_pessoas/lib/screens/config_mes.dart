import 'package:app_cadastro_pessoas/screens/config_semana.dart';
import 'package:flutter/material.dart';

class ConfiguracaoMesScreen extends StatefulWidget {
  @override
  _ConfiguracaoMesScreenState createState() => _ConfiguracaoMesScreenState();
}

class _ConfiguracaoMesScreenState extends State<ConfiguracaoMesScreen> {
  int? _selectedYear; // Ano selecionado
  int? _selectedMonth; // Mês selecionado
  List<int> _years = List.generate(11, (index) => 2025 + index); // Lista de anos (2020 a 2030)
  List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ]; // Lista de meses

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração do Mês'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Seletor de Ano
            DropdownButton<int>(
              value: _selectedYear,
              hint: Text('Selecione o ano'),
              items: _years.map((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Seletor de Mês
            DropdownButton<int>(
              value: _selectedMonth,
              hint: Text('Selecione o mês'),
              items: List.generate(12, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1, // Mês de 1 a 12
                  child: Text(_months[index]),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Botão para carregar a configuração da semana
            if (_selectedYear != null && _selectedMonth != null)
  ElevatedButton(
    onPressed: () {
      // Verifica se o ano e o mês são válidos
      if (_selectedYear != null && _selectedMonth != null && _selectedMonth! >= 1 && _selectedMonth! <= 12) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfiguracaoSemanaScreen(
              ano: _selectedYear!,
              mes: _selectedMonth!,
            ),
          ),
        );
      } else {
        // Exibe uma mensagem de erro se o mês for inválido
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selecione um ano e um mês válidos!')),
        );
      }
    },
    child: Text('Carregar Configuração da Semana'),
  ),
          ],
          
        ),
      ),
    );
  }
}