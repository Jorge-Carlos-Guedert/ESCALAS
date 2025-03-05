import 'package:flutter/material.dart';

class ConfiguracaoMesScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _mesController = TextEditingController();
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração do Mês'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mesController,
                decoration: InputDecoration(labelText: 'Mês'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o mês';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horarioController,
                decoration: InputDecoration(labelText: 'Horário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o horário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aqui você pode chamar o método para salvar a configuração
                    print('Mês: ${_mesController.text}');
                    print('Data: ${_dataController.text}');
                    print('Horário: ${_horarioController.text}');
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}