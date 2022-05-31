// Requisição GET

Future<String> getUsuario(context) async {
  var _token = await pegaToken();
  print(_token);
  var url = Uri.parse(Url + 'usuario');
  final _resposta = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  });
  print(_resposta.statusCode);

  if (_resposta.statusCode == 200 || _resposta.statusCode == 204) {
    print(_resposta.body);
    return "Usuário carregado!";
  } else {
    return "Usuário não carregado!";
  }
}

// post

// put

//delete
