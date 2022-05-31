import 'dart:convert';

class Horario {
  int id = 0;
  String data_marcada = "";
  String horario_marcado = "";
  int id_agendamento = 0;

  Horario();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      'id_agendamento': id_agendamento,
      'data_marcada': data_marcada,
      'horario_marcado': horario_marcado,
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  Horario.fromMap(Map map) {
    id = map['id'];
    id_agendamento = map['id_agendamento'];
    data_marcada = map['data_marcada'];
    horario_marcado = map['horario_marcado'];
  }

  @override
  String toString() {
    return 'Agendamento{id: $id, '
        'id_agendamento : $id_agendamento, '
        'data_marcada: $data_marcada, '
        'horario_marcado: $horario_marcado}';
  }

  String? geraJson() {
    String dados = json.encode(this);
    return dados;
  }
}
