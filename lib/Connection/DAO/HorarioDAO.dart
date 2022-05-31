import 'dart:async';
import 'package:doa_sangue/Model/Horario.dart';
import '../Connection.dart';

class HorarioDAO {
  Future<Horario> search(Horario horario) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('horario');
    if (retorno.isNotEmpty) {
      return Horario.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  Future<Horario> searchIdAgendamento(int idAgendamento) async {
    var _db = await Connection.get();

    List<Map> retorno = await _db.query('horario', where: 'id_agendamento = ?', whereArgs: [idAgendamento]);
    if (retorno.isNotEmpty) {
      return Horario.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  Future<bool> isValidHorario(int id) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('horario', where: 'id = ?', whereArgs: [id]);

    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> insert(Horario horario) async {
    try {
      var _db = await Connection.get();
      final insertedId = await _db.insert('horario', horario.toMap());
      print('Horario inserido: ' + horario.id.toString());
      return insertedId;
    } catch (ex) {
      print(ex);
      return 0;
    }
  }

  update(Horario horario) async {
    try {
      var _db = await Connection.get();
      await _db.update('horario', horario.toMap(), where: "id = ?", whereArgs: [horario.id]);
      print('Horario alterado: ' + horario.id.toString());
    } catch (ex) {
      print(ex);
      return;
    }
  }

  delete(int id) async {
    try {
      var _db = await Connection.get();
      await _db.delete('horario', where: "id = ?", whereArgs: [id]);
    } on Exception catch (_) {
      print("Erro ao deletar id: "[id]);
      throw Exception("Erro ao deletar id: "[id]);
    }
  }
}
