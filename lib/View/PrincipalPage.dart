import 'package:doa_sangue/Connection/DAO/DoadorDAO.dart';
import 'package:doa_sangue/Connection/DAO/UsuarioDAO.dart';
import 'package:doa_sangue/Model/Usuario.dart';
import 'package:doa_sangue/Service/ConnectionAPI.dart';
import 'package:doa_sangue/View/AgendamentoMapaPage.dart';
import 'package:doa_sangue/View/Login.CadastrarPage.dart';
import 'package:flutter/material.dart';
import 'ListaAgendamentosPage.dart';
import 'DoadorPage.dart';
import 'dart:io';

class PrincipalPage extends StatefulWidget {
  Usuario _usuario = Usuario();

  PrincipalPage(this._usuario);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  var CaminhoImagem = "assets/pictures/profile-picture-menu.jpg";
  int _doadorId = 0;
  File? _arquivo;

  @override
  void initState() {
    super.initState();
    if ((widget._usuario.imagem != '') && (widget._usuario.imagem != 'assets/pictures/profile-picture.jpg')) {
      final imageTemp = File(widget._usuario.imagem);
      setState(() => _arquivo = imageTemp);
    }
  }

  @override
  void onResume() {
    setState(() {
      UsuarioDAO.searchId(widget._usuario);
    });
    super.context;
  }

  verificaExistenciaDoador() async {
    _doadorId = await DoadorDAO.returnDoadorId(widget._usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: corpo(context),
    );
  }

  Widget corpo(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Principal"),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(widget._usuario.email),
              accountName: Text(widget._usuario.nome),
              decoration: BoxDecoration(
                color: const Color(0XFFEF5350),
              ),
              currentAccountPicture: _arquivo != null ? Image.file(_arquivo!) : Image.asset(CaminhoImagem),
              // currentAccountPicture: CircleAvatar(
              //   radius: 30,
              //   backgroundColor: Colors.white,
              //   child: ClipRRect(
              //       borderRadius: BorderRadius.circular(50),
              //       child: _arquivo != null ? Image.file(_arquivo!) : Image.asset(CaminhoImagem)),
              // ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Editar dados Usuário"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroUsuarioPage(widget._usuario.id, true),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Cadastro Doador/Solicitante"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroDoadorPage(widget._usuario.id),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Agendamento doação sangue"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaAgendamentoPage(widget._usuario.id, widget._usuario.nome, _doadorId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text("Visualizar Local para doação sangue"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendamentoMapaPage(),
                  ),
                ); //Navegar para outra página
              },
            ),
            ListTile(
              leading: Icon(Icons.app_settings_alt),
              title: Text("Teste Token API"),
              onTap: () async {
                ConnectionAPI api = ConnectionAPI();
                await api.getUsuario(context); // contexto só pra mostrar q funciona
              },
            ),
          ],
        ),
      ),
    );
  }
}
