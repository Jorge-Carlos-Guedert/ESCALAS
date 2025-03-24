class ConfigurarCalendarios {
  final int id; // Chave primária
  final int ano; // Ano do horário
  final int mes; // Mês do horário
  final int diaMes; // Dia do mês (ex: 1, 2, 3, ...)
  final String diaSemana; // Dia da semana (ex: "Segunda-feira")
  final String horario; // Horário (ex: "09:00")
  final int quantidade; // Quantidade (ex: 10)

  ConfigurarCalendarios({
    required this.id,
    required this.ano,
    required this.mes,
    required this.diaMes,
    required this.diaSemana,
    required this.horario,
    required this.quantidade,
  });

  // Converte JSON para um objeto ConfigurarCalendarios
  factory ConfigurarCalendarios.fromJson(Map<String, dynamic> json) {
    return ConfigurarCalendarios(
      id: json['id'],
      ano: json['ano'],
      mes: json['mes'],
      diaMes: json['diaMes'],
      diaSemana: json['diaSemana'],
      horario: json['horario'],
      quantidade: json['quantidade'],
    );
  }

  // Converte o objeto ConfigurarCalendarios para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ano': ano,
      'mes': mes,
      'diaMes': diaMes,
      'diaSemana': diaSemana,
      'horario': horario,
      'quantidade': quantidade,
    };
  }
}