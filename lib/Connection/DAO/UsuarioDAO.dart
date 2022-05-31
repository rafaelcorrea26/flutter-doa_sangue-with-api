import 'dart:async';
import 'package:doa_sangue/Model/Usuario.dart';
import '../Connection.dart';

class UsuarioDAO {
  static Future<Map> get() async {
    var _db = await Connection.get();
    Map result = Map();
    List<Map> items = await _db.query('usuario');

    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  static Future<Usuario> searchId(id) async {
    var _db = await Connection.get();
    List<Map> items = await _db.query('usuario', where: 'id =?', whereArgs: [id]);

    if (items.isNotEmpty) {
      return Usuario.fromMap(items.first);
    } else {
      return null!;
    }
  }

  static Future insert(Usuario usuario) async {
    try {
      var _db = await Connection.get();
      await _db.insert('usuario', usuario.toMap());
      print('Usuário cadastrado!');
    } catch (ex) {
      print(ex);
      return;
    }
  }

  static update(Usuario usuario) async {
    try {
      var _db = await Connection.get();
      await _db.update('usuario', usuario.toMap(), where: "id = ?", whereArgs: [usuario.id]);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  static delete(int id) async {
    try {
      var _db = await Connection.get();
      await _db.delete('usuario', where: "id = ?", whereArgs: [id]);
    } on Exception catch (_) {
      print("Erro ao deletar id: "[id]);
      throw Exception("Erro ao deletar id: "[id]);
    }
  }

  static Future<bool> existLogin(String login) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('usuario', where: " login = ?", whereArgs: [login]);
    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> existEmail(String email) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('usuario', where: " email = ?", whereArgs: [email]);
    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isloginValid(Usuario usuario) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('usuario',
        where: "(email = ? or login = ?)"
            " AND senha = ? ",
        whereArgs: [usuario.email, usuario.login, usuario.senha]);
    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Usuario> login(Usuario usuario) async {
    var _db = await Connection.get();
    List<Map> retorno = await _db.query('usuario',
        where: "(email = ? or login = ?)"
            " AND senha = ? ",
        whereArgs: [usuario.email, usuario.login, usuario.senha]);
    if (retorno.isNotEmpty) {
      return Usuario.fromMap(retorno.first);
    } else {
      return null!;
    }
  }
}
