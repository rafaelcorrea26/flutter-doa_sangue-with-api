import 'dart:async';
import 'Scripts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static Database? database;
  static const String dbName = 'doa_sangue.db';

  static Future<Database> get() async {
    if (database == null) {
      var path = join(await getDatabasesPath(), dbName);
      // deleteDatabase(path);
      database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, v) {
          db.execute(createTableUsuario);
          db.execute(createTableDoador);
          db.execute(createTableAgendamento);
          db.execute(createTableHorario);
        },
      );
    }
    return database ??= await openDatabase(dbName);
  }

  Future close() async {
    database?.close();
  }
}
