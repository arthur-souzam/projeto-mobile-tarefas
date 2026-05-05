import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DBUtil {
  static Future<sqlite.Database> _getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, 'tarefas.db');
    return sqlite.openDatabase(
      arqBD,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Etiqueta(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            cor INTEGER NOT NULL
          )
        ''');
        db.execute('''
          CREATE TABLE Tarefa(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descricao TEXT NOT NULL,
            data_prevista TEXT NOT NULL,
            importante INTEGER NOT NULL DEFAULT 0,
            realizada INTEGER NOT NULL DEFAULT 0,
            etiqueta_id INTEGER,
            FOREIGN KEY (etiqueta_id) REFERENCES Etiqueta(id) ON DELETE SET NULL
          )
        ''');
      },
    );
  }

  static Future<int> insert(String table, Map<String, dynamic> map) async {
    final db = await _getDB();
    return await db.insert(table, map);
  }

  static Future<List<Map<String, dynamic>>> list(String table, {String orderBy = 'id ASC'}) async {
    final db = await _getDB();
    return db.query(table, orderBy: orderBy);
  }

  static Future<int> update(String table, Map<String, dynamic> map) async {
    final db = await _getDB();
    return await db.update(
      table,
      map,
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }

  static Future<int> delete(String table, int id) async {
    final db = await _getDB();
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
