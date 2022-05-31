import 'package:doa_sangue/Connection/DAO/AgendamentoDAO.dart';
import 'package:doa_sangue/Connection/DAO/HorarioDAO.dart';
import 'package:doa_sangue/Controller/Validators.dart';
import 'package:doa_sangue/Model/Agendamento.dart';
import 'package:doa_sangue/Model/Horario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'HorarioPage.dart';

class AgendamentoPage extends StatefulWidget {
  String NomeUsuario;
  bool Requisitos;
  Agendamento agendamento;

  AgendamentoPage(this.NomeUsuario, this.Requisitos, this.agendamento);

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  Agendamento _agendamento = Agendamento();
  AgendamentoDAO helper = AgendamentoDAO();
  Horario _horario = Horario();
  HorarioDAO helperHorario = HorarioDAO();

  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;
  String _dropdownSitValue = 'Bem';
  String _dropdownStatusValue = 'Pendente';
  List<String> _sitSaude = ['Bem', 'Ruim'];
  List<String> _status = ['Pendente', 'Concluida'];
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _dataController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: Locale("pt"),
        context: context,
        initialDate: _date,
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                    onPrimary: Colors.white, // selected text color
                    onSurface: Colors.red, // default text color
                    primary: Colors.red // circle color
                    ),
                dialogBackgroundColor: Colors.white,
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Quicksand'),
                        primary: Colors.red, // color of button's letters
                        backgroundColor: Colors.white, // Background color
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    if (picked != null && picked != _date) {
      print(_dataController.text = DateFormat("dd/MM/yyyy").format(picked));

      setState(() {
        _dataController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  Future<Null> _selectHour(BuildContext context) async {
    final retorno = await Navigator.push(context, MaterialPageRoute(builder: (context) => HorarioPage(_dataController.text)));
    print(retorno);

    if (retorno != '') {
      _horaController.text = retorno;
    } else {
      _horaController.clear();
    }
  }

  Future _carregaCamposAgendamento() async {
    if (widget.agendamento.id > 0) {
      _agendamento.id = widget.agendamento.id;
      _idadeController.text = widget.agendamento.idade.toString();
      _dropdownSitValue = widget.agendamento.sit_saude;
      _dropdownStatusValue = widget.agendamento.status;

      _horario = await helperHorario.searchIdAgendamento(_agendamento.id);
      _dataController.text = _horario.data_marcada;
      _horaController.text = _horario.horario_marcado;
      print(widget.agendamento);
    } else {
      _agendamento.id = 0;
      _idadeController.text = "";
      _dropdownSitValue = "Bem";
      _dropdownStatusValue = "Pendente";
    }
  }

  Future _cadastrarAgendamento() async {
    if (_idadeController.text != "") {
      _agendamento.idade = int.parse(_idadeController.text);
    }
    _agendamento.status = _dropdownStatusValue;
    _agendamento.sit_saude = _dropdownSitValue;
    _agendamento.id_usuario = widget.agendamento.id_usuario;
    _agendamento.id_doador = widget.agendamento.id_doador;

    _horario.data_marcada = _dataController.text;
    _horario.horario_marcado = _horaController.text;

    if (_agendamento.id > 0) {
      _horario.id_agendamento = _agendamento.id;
      helperHorario.update(_horario);
      helper.update(_agendamento);
    } else {
      _horario.id_agendamento = await helper.insert(_agendamento);
      helperHorario.insert(_horario);
    }
    Navigator.pop(context, false);
  }

  barraSuperior() {
    return AppBar(
      title: Text("Tela Cadastro de Agendamento"),
      centerTitle: true,
      backgroundColor: Colors.red[400],
    );
  }

  @override
  void initState() {
    super.initState();
    _carregaCamposAgendamento().then;
    setState(() {});
  }

  Widget corpo(context) {
    _nomeController.text = widget.NomeUsuario;
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: _nomeController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nome Usuário/Doador",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            TextFormField(
              validator: Validators.required('Idade não pode ficar em branco.'),
              enabled: true,
              controller: _idadeController,
              inputFormatters: [LengthLimitingTextInputFormatter(50), FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Idade",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Situação saúde',
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              value: _dropdownSitValue,
              // icon: const Icon(Icons.),
              elevation: 16,
              style: const TextStyle(color: Colors.black38),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownSitValue = newValue!;
                });
              },
              items: _sitSaude.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Status',
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              value: _dropdownStatusValue,
              // icon: const Icon(Icons.),
              elevation: 16,
              style: const TextStyle(color: Colors.black38),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownStatusValue = newValue!;
                });
              },
              items: _status.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              validator: Validators.required('Data Agendamento não pode ficar em branco.'),
              controller: _dataController,
              decoration: InputDecoration(
                labelText: "Data Agendamento",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                contentPadding: EdgeInsets.only(top: 20),
                isDense: true,
                hintText: "Data Agendamento",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Icon(Icons.calendar_today),
                ),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
              },
            ),
            TextFormField(
              validator: Validators.required('Horário de Agendamento não pode ficar em branco.'),
              controller: _horaController,
              decoration: InputDecoration(
                labelText: "Horário Agendamento",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                contentPadding: EdgeInsets.only(top: 20),
                isDense: true,
                hintText: "Horário Agendamento",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Icon(Icons.alarm),
                ),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (_dataController.text != '') {
                  _selectHour(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data não pode estar vazia para escolher o horário.')),
                  );
                }
              },
            ),
            SizedBox(
              height: 30,
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
                    "Cadastrar/Alterar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _cadastrarAgendamento();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro! Existem campos em branco ou preenchidos incorretamente.')),
                      );
                    }
                  },
                ),
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

  barraSuperiorRequisitoDoar() {
    return AppBar(
      title: Text("Requisitos para Agendamento"),
      centerTitle: true,
      backgroundColor: Colors.red[400],
    );
  }

  Widget aceitaTermos(context) {
    return FormField<bool>(
      validator: (value) {
        if (!checkboxValue) {
          return 'Você precisa aceitar os termos';
        } else {
          return null;
        }
      },
      builder: (state) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        setState(() {
                          checkboxValue = value!;
                          state.didChange(value);
                        });
                      }),
                  Text(
                    'Confirmo que estou apto a fazer a doação.',
                    style: TextStyle(fontSize: 12, height: 0.6, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Text(
                state.errorText ?? '',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  botaoContinuarRequisitoDoar() {
    return TextButton(
      child: const Text(
        "Continuar",
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        if (checkboxValue) {
          setState(() {
            widget.Requisitos = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro!Doador deve ser criado antes de utilizar a tela de agendamentos.')),
          );
          setState(() {
            widget.Requisitos = true;
          });
        }
      },
    );
  }

  requisitoDoar(requisito) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Text(
            requisito,
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }

  headerRequisitoDoar(requisito) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            requisito,
            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }

  Widget corpoRequisitoDoar(context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            headerRequisitoDoar("Recomendações:"),
            requisitoDoar("Estar alimentado. Evite alimentos gordurosos nas 3 horas que antecedem a doação de sangue."),
            requisitoDoar("Caso seja após o almoço, aguardar 2 horas."),
            requisitoDoar("Ter dormido pelo menos 6 horas nas últimas 24 horas."),
            requisitoDoar("Pessoas com idade entre 60 e 69 anos só poderão doar sangue se já o tiverem feito antes dos 60 anos."),
            requisitoDoar(
                "A frequência máxima é de quatro doações de sangue anuais para o homem e de três doações de sangue anuais para as mulher."),
            requisitoDoar(
                "O intervalo mínimo entre uma doação de sangue e outra é de dois meses para os homens e de três meses para as mulheres."),
            headerRequisitoDoar("Impedimentos:"),
            requisitoDoar("Resfriado e febre: aguardar 7 dias após o desaparecimento dos sintomas;"),
            requisitoDoar("Período gestacional"),
            requisitoDoar("Período pós-gravidez: 90 dias para parto normal e 180 dias para cesariana"),
            requisitoDoar("Amamentação: até 12 meses após o parto"),
            requisitoDoar("Ingestão de bebida alcoólica nas 12 horas que antecedem a doação"),
            requisitoDoar(
                "Tatuagem e/ou piercing nos últimos 12 meses (piercing em cavidade oral ou região genital impedem a doação);"),
            requisitoDoar("Extração dentária: 72 horas"),
            requisitoDoar("Apendicite, hérnia, amigdalectomia, varizes: 3 meses"),
            requisitoDoar(
                "Colecistectomia, histerectomia, nefrectomia, redução de fraturas, politraumatismos sem seqüelas graves, tireoidectomia, colectomia: 6 meses"),
            requisitoDoar("Transfusão de sangue  a menos de  1 ano da data que deseja doar"),
            requisitoDoar("Exames/procedimentos com utilização de endoscópio nos últimos 6 meses"),
            requisitoDoar(
                "Ter sido exposto a situações de risco acrescido para infecções sexualmente transmissíveis (aguardar 12 meses após a exposição)"),
            headerRequisitoDoar("Quais são os impedimentos definitivos para doar sangue?"),
            requisitoDoar("Ter passado por um quadro de hepatite após os 11 anos de idade"),
            requisitoDoar(
                "Evidencia clinica ou laboratorial das seguintes doenças de sangue: Hepatites B e C, AIDS( virus HIV), doenças associadas aos virus HTLV I e II e doença de chagas"),
            requisitoDoar("Uso de drogas ilícitas injetáveis e malaria. "),
            aceitaTermos(context),
            botaoContinuarRequisitoDoar(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.Requisitos ? corpoRequisitoDoar(context) : corpo(context),
        appBar: widget.Requisitos ? barraSuperior() : barraSuperiorRequisitoDoar());
  }
}
