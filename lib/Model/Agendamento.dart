import 'dart:convert';

class Agendamento {
  int id = 0;
  String local_doacao = "";
  int idade = 0;
  String sit_saude = "";
  String status = "";
  int id_usuario = 0;
  int id_doador = 0;
  Agendamento();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      'local_doacao': local_doacao,
      'idade': idade,
      'sit_saude': sit_saude,
      'status': status,
      'id_usuario': id_usuario,
      'id_doador': id_doador,
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  Agendamento.fromMap(Map map) {
    id = map['id'];
    local_doacao = map['local_doacao'];
    idade = map['idade'];
    sit_saude = map['sit_saude'];
    status = map['status'];
    id_usuario = map['id_usuario'];
    id_doador = map['id_doador'];
  }

  @override
  String toString() {
    return 'Agendamento{id: $id, '
        'local_doacao: $local_doacao,'
        'idade: $idade,'
        'sit_saude: $sit_saude,'
        'status: $status,'
        'id_usuario: $id_usuario,'
        'id_doador: $id_doador}';
  }

  String? geraJson() {
    String dados = json.encode(this);
    return dados;
  }
}
