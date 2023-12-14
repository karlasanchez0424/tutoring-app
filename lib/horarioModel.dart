class Asignatura {
  final String nombre;
  final String codigo;

  Asignatura({required this.nombre, required this.codigo});

  factory Asignatura.fromJson(Map<String, dynamic> json) {
    return Asignatura(
      nombre: json['subject']['name'],
      codigo: json['subject']['code'],
    );
  }
}

class Horario {
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String codigoAula;
  final String edificio;

  Horario({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.codigoAula,
    required this.edificio,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      dia: json['day'],
      horaInicio: json['h_start'],
      horaFin: json['h_end'],
      codigoAula: json['classroom']['code'],
      edificio: json['classroom']['building'],
    );
  }
}
