import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/models/configurar_calendarios.dart';

class ConfiguracaoSemanaScreen extends StatefulWidget {
  final int? ano;
  final int? mes;

  ConfiguracaoSemanaScreen({required this.ano, required this.mes});

  @override
  _ConfiguracaoSemanaScreenState createState() => _ConfiguracaoSemanaScreenState();
}

class _ConfiguracaoSemanaScreenState extends State<ConfiguracaoSemanaScreen> {
  final List<String> _diasDaSemana = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  final Map<String, List<Map<String, String>>> _horariosPorDia = {};

  @override
  void initState() {
    super.initState();
    // Inicializa o mapa com listas vazias para cada dia
    for (var dia in _diasDaSemana) {
      _horariosPorDia[dia] = [];
    }
    // Carrega os horários configurados para o mês selecionado
    _carregarHorariosConfigurados();
  }

  // Função para carregar os horários configurados
  void _carregarHorariosConfigurados() async {
  try {
    final horarios = await ApiService.fetchHorarios(widget.ano!, widget.mes!);
    for (var horario in horarios) {
      if (_horariosPorDia.containsKey(horario.diaSemana)) {
        _horariosPorDia[horario.diaSemana]!.add({
          'horario': horario.horario,
          'quantidade': horario.quantidade.toString(),
        });
      }
    }
  } catch (e) {
    print('Erro ao carregar horários: $e');
  }
  setState(() {
    _horariosPorDia['Segunda-feira'] = [
      {'horario': '09:00', 'quantidade': '10'},
      {'horario': '14:00', 'quantidade': '5'},
    ];
    _horariosPorDia['Quarta-feira'] = [
      {'horario': '10:00', 'quantidade': '8'},
    ];
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração da Semana - ${widget.mes}/${widget.ano}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: _diasDaSemana.map((dia) {
          return _buildDiaTile(dia);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarConfiguracoes,
        child: Icon(Icons.save),
        tooltip: 'Salvar Configurações',
      ),
    );
  }

  Widget _buildDiaTile(String dia) {
    return ExpansionTile(
      title: Text(dia),
      children: [
        ..._horariosPorDia[dia]!.map((horario) {
          return ListTile(
            title: Text('Horário: ${horario['horario']}'),
            subtitle: Text('Quantidade: ${horario['quantidade']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removerHorario(dia, horario);
              },
            ),
          );
        }).toList(),
        ListTile(
          title: Text('Adicionar Horário'),
          trailing: Icon(Icons.add),
          onTap: () {
            _adicionarHorario(dia);
          },
        ),
      ],
    );
  }

  void _adicionarHorario(String dia) {
    TextEditingController _horarioController = TextEditingController();
    TextEditingController _quantidadeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Horário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _horarioController,
                decoration: InputDecoration(labelText: 'Horário (ex: 09:00)'),
              ),
              TextField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (_horarioController.text.isNotEmpty && _quantidadeController.text.isNotEmpty) {
                  setState(() {
                    _horariosPorDia[dia]!.add({
                      'horario': _horarioController.text,
                      'quantidade': _quantidadeController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removerHorario(String dia, Map<String, String> horario) {
    setState(() {
      _horariosPorDia[dia]!.remove(horario);
    });
  }

  void _salvarConfiguracoes() async {
  try {
    // Converte os horários para o formato esperado pela API
    List<ConfigurarCalendarios> horarios = [];
    _horariosPorDia.forEach((dia, listaHorarios) {
      for (var horario in listaHorarios) {
        horarios.add(ConfigurarCalendarios(
          id: 0, // ID temporário (a API pode gerar um novo)
          ano: widget.ano!,
          mes: widget.mes!,
          diaMes: 1, // Dia fictício (ajuste conforme necessário)
          diaSemana: dia,
          horario: horario['horario']!,
          quantidade: int.parse(horario['quantidade']!),
        ));
      }
    });

    // Envia os horários para a API
    await ApiService.salvarHorarios(horarios);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configurações salvas com sucesso!')),
    );

    // Retorna para a tela anterior
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar configurações: $e')),
    );
  }
}
}