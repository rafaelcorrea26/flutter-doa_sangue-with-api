import 'package:doa_sangue/Model/Agendamento.dart';
import '../Connection.dart';
import 'dart:async';

class AgendamentoDAO {
  Future<Map> get() async {
    var _db = await Connection.get();
    Map result = Map();
    List<Map> items = await _db.query('agendamento');

    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<List<Agendamento>> consultar() async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.rawQuery("SELECT * FROM agendamento ");
    List<Agendamento> agendamento = [];
    for (Map jogador in retorno) {
      agendamento.add(Agendamento.fromMap(jogador));
    }
    return agendamento;
  }

  Future<List<Agendamento>> consultarTodos() async {
    var _db = await Connection.get();

    List<Map> retorno = await _db.query('agendamento', orderBy: 'id desc ');
    List<Agendamento> agendamento = [];
    // print(retorno);

    for (Map map in retorno) {
      agendamento.add(Agendamento.fromMap(map));
    }

    return agendamento;
  }

  Future<Agendamento> searchId(int id) async {
    var _db = await Connection.get();
    List<Map> items = await _db.query('agendamento', where: 'id =?', whereArgs: [id]);

    if (items.isNotEmpty) {
      return Agendamento.fromMap(items.first);
    } else {
      return null!;
    }
  }

  Future<int> insert(Agendamento agendamento) async {
    try {
      var _db = await Connection.get();
      final insertedId = await _db.insert('agendamento', agendamento.toMap());
      print('Agendamento inserido: $insertedId');
      return insertedId;
    } catch (ex) {
      print(ex);
      return 0;
    }
  }

  update(Agendamento agendamento) async {
    try {
      var _db = await Connection.get();
      await _db.update('agendamento', agendamento.toMap(), where: "id = ?", whereArgs: [agendamento.id]);
      print('Agendamento alterado: ' + agendamento.id.toString());
    } catch (ex) {
      print(ex);
      return;
    }
  }

  delete(int id) async {
    try {
      var _db = await Connection.get();
      await _db.delete('agendamento', where: "id = ?", whereArgs: [id]);
      print('Agendamento deletado: ' + id.toString());
    } on Exception catch (_) {
      print("Erro ao deletar id: "[id]);
      throw Exception("Erro ao deletar id: "[id]);
    }
  }

  Future<bool> existAgendamento(String id) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('agendamento', where: " id = ?", whereArgs: [id]);
    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
