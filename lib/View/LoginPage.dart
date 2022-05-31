//import 'package:doa_sangue/Service/ConnectionAPI.dart';
import 'package:doa_sangue/View/Login.ResetarPasswordPage.dart';
import 'package:doa_sangue/Connection/DAO/UsuarioDAO.dart';
import 'package:doa_sangue/Model/Usuario.dart';
import 'package:doa_sangue/Controller/Validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login.CadastrarPage.dart';
import 'PrincipalPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: corpo(context));
  }
}

TextEditingController _emailControler = TextEditingController();
TextEditingController _senhaControler = TextEditingController();

void _Mensagem(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Houve algum Erro'),
          content: SingleChildScrollView(
            child: ListBody(children: const <Widget>[
              Text('Usuário não encontrado!'),
            ]),
          )));
}

_entrarSistema(context) async {
  Usuario _usuario = Usuario();
  _usuario.email = _emailControler.text;
  _usuario.login = _emailControler.text;
  _usuario.senha = _senhaControler.text;
  if (await UsuarioDAO.isloginValid(_usuario)) {
    _usuario.email = _emailControler.text;
    _usuario.login = _emailControler.text;
    _usuario.senha = _senhaControler.text;
    await UsuarioDAO.login(_usuario);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrincipalPage(_usuario),
      ),
    );
  } else {
    _Mensagem(context);
  }
}

Widget corpo(context) {
  return Container(
    padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
    color: Colors.white,
    child: ListView(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              "Bem vindo",
              style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(0),
          child: Center(
            child: Text(
              "Preencha suas credenciais para logar no sistema",
              style: TextStyle(color: Colors.black38, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _emailControler,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(top: 15), // add padding to adjust icon
              child: Icon(
                Icons.email,
                color: Colors.red[400],
              ),
            ),
            labelText: "Login/E-mail",
            labelStyle: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            )),
          ),
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: Validators.compose([
            Validators.required('Senha não pode ficar em branco.'),
          ]),
          controller: _senhaControler,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(top: 15), // add padding to adjust icon
              child: Icon(
                Icons.lock,
                color: Colors.red[400],
              ),
            ),
            labelText: "Senha",
            labelStyle: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            )),
          ),
          style: const TextStyle(fontSize: 20),
        ),
        Container(
          height: 30,
          alignment: Alignment.centerRight,
          child: TextButton(
            child: const Text(
              "Recuperar Senha",
              textAlign: TextAlign.right,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetarPasswordPage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Color(0XFFEF5350),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: SizedBox.expand(
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Entrar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    child: Image.asset("assets/icons/login-icon.png"),
                    height: 28,
                    width: 28,
                  )
                ],
              ),
              onPressed: () {
                _entrarSistema(context);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 40,
          child: TextButton(
            child: const Text(
              "Cadastre-se",
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroUsuarioPage(0, false),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
