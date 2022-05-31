import 'dart:async';
import 'package:doa_sangue/Model/Doador.dart';
import '../Connection.dart';

class DoadorDAO {
  static Future<Doador> search() async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('doador');
    if (retorno.isNotEmpty) {
      return Doador.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  static Future<Doador> searchId(id) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('doador', where: 'id = ?', whereArgs: [id]);
    if (retorno.isNotEmpty) {
      return Doador.fromMap(retorno.first);
    } else {
      return null!;
    }
  }

  static Future<bool> isValidDoador(int id) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('doador', where: 'id = ?', whereArgs: [id]);

    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<int> returnDoadorId(int id_usuario) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('doador', where: 'id_usuario = ?', whereArgs: [id_usuario]);

    if (retorno.isNotEmpty) {
      return retorno[0]["id"];
    } else {
      return 0;
    }
  }

  static Future insert(Doador doador) async {
    try {
      var _db = await Connection.get();
      await _db.insert('doador', doador.toMap());
      print('Doador cadastrado!');
    } catch (ex) {
      print(ex);
      return;
    }
  }

  static update(Doador doador) async {
    try {
      var _db = await Connection.get();
      await _db.update('doador', doador.toMap(), where: "id = ?", whereArgs: [doador.id]);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  static delete(int id) async {
    try {
      var _db = await Connection.get();
      await _db.delete('doador', where: "id = ?", whereArgs: [id]);
    } on Exception catch (_) {
      print("Erro ao deletar id: "[id]);
      throw Exception("Erro ao deletar id: "[id]);
    }
  }
}
