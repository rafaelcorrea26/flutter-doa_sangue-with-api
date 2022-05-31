import 'package:flutter/material.dart';

class ResetarPasswordPage extends StatelessWidget {
  const ResetarPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: corpo(context),
      appBar: barraSuperior(),
    );
  }
}
barraSuperior() {
  return AppBar(
    title: Text("Tela Resetar senha"),
    centerTitle: true,
    backgroundColor: Colors.red[400],
  );
}

Widget corpo(context) {
  return Container(
    padding: EdgeInsets.only(top: 60, left: 40, right: 40),
    color: Colors.white,
    child: ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset("assets/icons/reset-password-icon.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Esqueceu sua senha?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Por favor, informe o E-mail associado a sua conta que enviaremos um link para o mesmo com as instruções para restauração de sua senha.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),Container(
    width: double.infinity,
    child: Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 20,
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
            child: FlatButton(
              child: Text(
                "Enviar Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  )
  ],
  )
  ],
  ),
  );
}
