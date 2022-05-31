import 'package:doa_sangue/Connection/DAO/AgendamentoDAO.dart';
import 'package:doa_sangue/Model/Agendamento.dart';
import 'package:doa_sangue/View/AgendamentoPage.dart';
import 'package:flutter/material.dart';

class ListaAgendamentoPage extends StatefulWidget {
  int idUsuario;
  String NomeUsuario;
  int idDoador;

  ListaAgendamentoPage(this.idUsuario, this.NomeUsuario, this.idDoador);

  @override
  _ListaAgendamentoPageState createState() => _ListaAgendamentoPageState();
}

class _ListaAgendamentoPageState extends State<ListaAgendamentoPage> {
  List<Agendamento> agendamentos = [];
  AgendamentoDAO helper = AgendamentoDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _barraSuperior(),
      body: _listagemFutura(),
      floatingActionButton: _botaoInserir(),
    );
  }

  _barraSuperior() {
    return AppBar(
      title: Text("Tela Cadastro de Agendamento"),
      centerTitle: true,
      backgroundColor: Colors.red[400],
    );
  }

  //Botao flutuante para adicionar contatos
  _botaoInserir() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {
        _navCriarAlterar(Agendamento());

        helper.consultarTodos().then((lista) {
          setState(() {
            agendamentos = lista;
          });
        });
      },
      child: const Icon(Icons.add),
    );
  }

  //Constroi a lista apenas apos a leitura dos dados
  _listagemFutura() {
    return FutureBuilder(
        future: _listarTodosAgendamentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _listaDosAgendamentos();
          }
        });
  }

  //Consulta ao banco de dados
  Future _listarTodosAgendamentos() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List<Agendamento> lista = await helper.consultarTodos();

    agendamentos = lista;
  }

  //Componente com a listagem dos contatos
  _listaDosAgendamentos() {
    return ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: agendamentos.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.redAccent,
                child: Align(
                  alignment: AlignmentDirectional(0.9, 0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              onDismissed: (DismissDirection direction) {
                Agendamento agendamentoDesfazer;
                agendamentoDesfazer = agendamentos[index];
                helper.delete(agendamentos[index].id);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tarefa ${agendamentoDesfazer.id} foi removido com sucesso!',
                      style: const TextStyle(color: Color(0xff060708)),
                    ),
                    backgroundColor: Colors.white,
                    action: SnackBarAction(
                      label: 'Desfazer',
                      textColor: const Color(0xff00d7f3),
                      onPressed: () {
                        setState(() {
                          helper.insert(agendamentoDesfazer);
                        });
                      },
                    ),
                    duration: const Duration(seconds: 5),
                  ),
                );
                setState(() {});
              },
              child: _ItemAgendamento(context, index));
        });
  }

  //Componente para criacao do card com as informações do contato
  _ItemAgendamento(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _mostrarOpcoes(context, index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Código Agendamento: " + agendamentos[index].id.toString() + "  -  Status: " + agendamentos[index].status,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Navegacao para pagina de atualizacao ou insercao
  _navCriarAlterar(Agendamento agendamento) async {
    final retorno;
    if (agendamento.id > 0) {
      retorno = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AgendamentoPage(widget.NomeUsuario, false, agendamento)));
    } else {
      retorno = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => AgendamentoPage(widget.NomeUsuario, true, agendamento)));
    }
    if (retorno != null) {
      setState(() {
        _listaDosAgendamentos();
      });
    }
  }

  //Componente que exibe as opcoes a serem executadas com o contato
  _mostrarOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: Text("Editar agendamento id:" + agendamentos[index].id.toString()),
                      onPressed: () {
                        Navigator.pop(context);
                        _navCriarAlterar(agendamentos[index]);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: const Text(
                        "Remover",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        helper.delete(agendamentos[index].id);
                        _listarTodosAgendamentos();
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
