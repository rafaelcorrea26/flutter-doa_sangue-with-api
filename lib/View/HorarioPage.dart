import 'package:doa_sangue/Controller/SizesHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorarioPage extends StatefulWidget {
  String dataAgendamento;

  HorarioPage(this.dataAgendamento);

  @override
  State<HorarioPage> createState() => _HorarioPageState();
}

List<String> segunda = ['08:00', '09:00', '10:00', '11:00', '13:00', '14:00', '15:00'];
List<String> ter_sext = ['08:00', '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00'];
List<String> sab = ['08:00', '09:00', '10:00', '11:00'];
List<String> dom = [];

class _HorarioPageState extends State<HorarioPage> {
  List<String> retornaDiaSemana() {
    DateTime date = DateTime.now();
    if (DateFormat('EEEE').format(date) == 'Monday') {
      return segunda;
    } else if (DateFormat('EEEE').format(date) == 'Tuesday' ||
        DateFormat('EEEE').format(date) == 'Wednesday' ||
        DateFormat('EEEE').format(date) == 'Thursday' ||
        DateFormat('EEEE').format(date) == 'Friday') {
      return ter_sext;
    } else if (DateFormat('EEEE').format(date) == 'Saturday') {
      return sab;
    } else {
      return dom;
    }
  }

  List<Widget> lista_colunas(List listaSemana) {
    List<Widget> componentes = [];
    for (var i = 0; i < listaSemana.length; i++) {
      componentes.add(
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, listaSemana[i]);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red[400],
                  alignment: Alignment.center,
                  child: Text(listaSemana[i].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      );
    }
    return componentes;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.only(top: 15.0),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "Agendamento Horário para doação sangue",
                  style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(0),
              child: Center(
                child: Text(
                  "Escolha um horário disponivel",
                  style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(mainAxisSize: MainAxisSize.max, children: lista_colunas(retornaDiaSemana())),
          ],
        ),
      ),
    );
  }
}
