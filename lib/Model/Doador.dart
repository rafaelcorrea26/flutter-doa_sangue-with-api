import 'dart:convert';

class Doador {
  int id = 0;
  String nome_completo = "";
  String nome_mae = "";
  String nome_pai = "";
  String genero = "";
  String data_nasc = "";
  String cpf = "";
  String rg = "";
  String celular = "";
  String tipo_sangue = "";
  String tipo_usuario = "";
  String uf = "";
  String id_carteira_doador = "";
  String email_doador = "";
  String email_solicitante = "";
  String local_internacao = "";
  String motivo = "";
  int qtd_bolsas = 0;
  String imagem = "";
  int id_usuario = 0;

  Doador();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      'nome_completo': nome_completo,
      'nome_mae': nome_mae,
      'nome_pai': nome_pai,
      'genero': genero,
      'data_nasc': data_nasc,
      'cpf': cpf,
      'rg': rg,
      'celular': celular,
      'tipo_sangue': tipo_sangue,
      'tipo_usuario': tipo_usuario,
      'uf': uf,
      'id_carteira_doador': id_carteira_doador,
      'email_doador': email_doador,
      'email_solicitante': email_solicitante,
      'local_internacao': local_internacao,
      'motivo': motivo,
      'qtd_bolsas': qtd_bolsas,
      'imagem': imagem,
      'id_usuario': id_usuario,
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  Doador.fromMap(Map map) {
    id = map['id'];
    nome_completo = map['nome_completo'];
    nome_mae = map['nome_mae'];
    nome_pai = map['nome_pai'];
    genero = map['genero'];
    data_nasc = map['data_nasc'];
    cpf = map['cpf'];
    rg = map['rg'];
    celular = map['celular'];
    tipo_sangue = map['tipo_sangue'];
    tipo_usuario = map['tipo_usuario'];
    uf = map['uf'];
    id_carteira_doador = map['id_carteira_doador'];
    email_doador = map['email_doador'];
    email_solicitante = map['email_solicitante'];
    local_internacao = map['local_internacao'];
    motivo = map['motivo'];
    qtd_bolsas = map['qtd_bolsas'];
    imagem = map['imagem'];
    id_usuario = map['id_usuario'];
  }

  @override
  String toString() {
    return 'Doador{id: $id, '
        'nome_completo: $nome_completo,'
        'nome_mae: $nome_mae,'
        'nome_pai: $nome_pai,'
        'genero: $genero,'
        'data_nasc: $data_nasc,'
        'cpf: $cpf,'
        'rg: $rg,'
        'celular: $celular,'
        'tipo_sangue: $tipo_sangue,'
        'tipo_usuario: $tipo_usuario,'
        'uf: $uf,'
        'id_carteira_doador: $id_carteira_doador,'
        'email_doador: $email_doador,'
        'email_solicitante: $email_solicitante,'
        'local_internacao: $local_internacao,'
        'motivo: $motivo,'
        'qtd_bolsas: $qtd_bolsas,'
        'imagem: $imagem,'
        'id_usuario: $id_usuario }';
  }

  String? geraJson() {
    String dados = json.encode(this);
    return dados;
  }
}
