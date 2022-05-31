import 'package:flutter/material.dart';

class ConfiguracaoPage extends StatelessWidget {
  const ConfiguracaoPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: corpo(context),
      appBar: _barraSuperior(),
    );
  }
}

_barraSuperior() {
  return AppBar(
    title: Text("Tela de Configuração"),
    centerTitle: true,
    backgroundColor: Colors.red[400],
  );
}

Widget corpo(context) {
  return Container(
    color: Colors.white,
    child: Column(
      children: [],
    ),
  );
}
