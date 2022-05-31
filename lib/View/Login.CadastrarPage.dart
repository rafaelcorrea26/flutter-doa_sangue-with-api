import 'package:doa_sangue/Connection/DAO/UsuarioDAO.dart';
import 'package:doa_sangue/Controller/ImagemHelper.dart';
import 'package:doa_sangue/Controller/Validators.dart';
import 'package:doa_sangue/Model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PrincipalPage.dart';
import 'dart:io';

class CadastroUsuarioPage extends StatefulWidget {
  int idUsuario;
  bool edicaoUsuario;

  CadastroUsuarioPage(this.idUsuario, this.edicaoUsuario);

  @override
  _CadastroUsuarioPage createState() => _CadastroUsuarioPage();
}

class _CadastroUsuarioPage extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  Usuario _usuario = Usuario();
  var CaminhoImagem = "assets/pictures/profile-picture.jpg";
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  _CadastroUsuarioPage();

  @override
  void initState() {
    super.initState();
    _usuario.id = widget.idUsuario;
    _carregaCampos();
  }

  void _carregaCampos() async {
    arquivo = null;
    if (_usuario.id > 0) {
      await UsuarioDAO.searchId(_usuario);
      _nomeController.text = _usuario.nome;
      _loginController.text = _usuario.login;
      _emailController.text = _usuario.email;
      _senhaController.text = _usuario.senha;
      if ((_usuario.imagem != '') && (_usuario.imagem != 'assets/pictures/profile-picture.jpg')) {
        imageTemp = File(_usuario.imagem);
        setState(() => arquivo = imageTemp);
      }
    }
  }

  void _MensagemEmailExiste(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Houve algum Erro'),
            content: SingleChildScrollView(
              child: ListBody(children: const <Widget>[
                Text('Email já existe!'),
              ]),
            )));
  }

  void _MensagemLoginExiste(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Houve algum Erro'),
            content: SingleChildScrollView(
              child: ListBody(children: const <Widget>[
                Text('Login já existe!'),
              ]),
            )));
  }

  void CadastrarUsuario() async {
    bool camposCertos = true;
    if (_loginController.text != _usuario.login) {
      if (await UsuarioDAO.existLogin(_loginController.text)) {
        camposCertos = false;
        _MensagemLoginExiste(context);
      }
    }
    if (_emailController.text != _usuario.email) {
      if (await UsuarioDAO.existEmail(_emailController.text)) {
        camposCertos = false;
        _MensagemEmailExiste(context);
      }
    }

    if (camposCertos) {
      _usuario.nome = _nomeController.text;
      _usuario.login = _loginController.text;
      _usuario.email = _emailController.text;
      _usuario.senha = _senhaController.text;
      _usuario.imagem = verificarCaminhoImagem()!;

      if (widget.edicaoUsuario) {
        await UsuarioDAO.update(_usuario);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PrincipalPage(_usuario),
          ),
        );
      } else {
        await UsuarioDAO.insert(_usuario);
        Navigator.pop(context, false);
      }
    }
  }

  void ListarUsuarios() async {
    Container(
        child: FutureBuilder(
      future: UsuarioDAO.get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.lenght,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data[index].title),
                  );
                },
              )
            : Center(
                child: Text('Não há usuários...'),
              );
      },
    ));
  }

  barraSuperior() {
    return AppBar(
      title: Text("Tela Cadastro Usuário"),
      centerTitle: true,
      backgroundColor: Colors.red[400],
    );
  }

  Widget corpo(context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              width: 300,
              height: 298,
              alignment: Alignment(0.0, 1.15),
              child: Column(
                children: [
                  Container(
                    width: 240,
                    height: 240,
                    child: FittedBox(
                        fit: BoxFit.fill, // otherwise the logo will be tiny
                        child: arquivo != null ? Image.file(arquivo!) : Image.asset(CaminhoImagem)),
                  ),
                  Container(
                    height: 56,
                    width: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0XFFEF5350),
                      border: Border.all(
                        width: 1.0,
                        color: const Color(0xFFFFFFFF),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(56),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: TextButton(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await mostraDialogoEscolha(context);
                          setState(() => arquivo = imageTemp);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nomeController,
              validator: Validators.required('Nome não pode ficar em branco.'),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                  child: Icon(
                    Icons.person,
                    color: Colors.red[400],
                  ),
                ),
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _loginController,
              validator: Validators.required('Login não pode ficar em branco.'),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                  child: Icon(
                    Icons.person,
                    color: Colors.red[400],
                  ),
                ),
                labelText: "Login",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: Validators.compose([
                Validators.required('Email não pode ficar em branco.'),
              ]),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                  child: Icon(
                    Icons.email,
                    color: Colors.red[400],
                  ),
                ),
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _senhaController,
              validator: Validators.required('Senha não pode ficar em branco.'),
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                  child: Icon(
                    Icons.lock,
                    color: Colors.red[400],
                  ),
                ),
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Color(0XFFEF5350),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                    child: Text(
                      "Cadastrar/Salvar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CadastrarUsuario();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro! Existem campos em branco ou preenchidos incorretamente.')),
                        );
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                child: Text(
                  "Cancelar",
                  textAlign: TextAlign.center,
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: corpo(context), appBar: barraSuperior());
  }
}
