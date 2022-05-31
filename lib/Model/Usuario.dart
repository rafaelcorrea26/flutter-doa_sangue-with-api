class Usuario {
  int id = 0;
  String nome = "";
  String login = "";
  String email = "";
  String senha = "";
  String imagem = "";
  // Constructor
  Usuario();

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      'nome': nome,
      'login': login,
      'email': email,
      'senha': senha,
      'imagem': imagem,
    };
    if (id > 0) {
      map["id"] = id;
    }
    return map;
  }

  Usuario.fromMap(Map map) {
    id = map['id'];
    nome = map['nome'];
    login = map['login'];
    email = map['email'];
    senha = map['senha'];
    imagem = map['imagem'];
  }

  @override
  String toString() {
    return 'usuario{id: $id, nome: $nome, login: $login, email: $email, senha: $senha}';
  }
}
