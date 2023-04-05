import 'package:escola/db/createTables.dart';
import 'createTables.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperDisciplina {
  static Future<int> createData(
      String codigo, String nome, int? matProf) async {
    final db = await CreateTables.db();

    matProf ??= 0;

    final disciplina = {'codigo': codigo, 'nome': nome, 'prof_id': matProf};
    final id = await db.insert('disciplina', disciplina,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await CreateTables.db();
    return db.query('disciplina', orderBy: 'codigo');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(String codigo) async {
    final db = await CreateTables.db();
    return db.query('disciplina',
        where: "codigo = ?", whereArgs: [codigo], limit: 1);
  }

  static Future<int> updateData(
      String codigo, String nome, int? matProf) async {
    final db = await CreateTables.db();
    final disciplina = {'codigo': codigo, 'nome': nome, 'prof_id': matProf};

    final result = await db.update('disciplina', disciplina,
        where: "codigo = ?", whereArgs: [codigo]);
    return result;
  }

  static Future<void> deleteData(String codigo) async {
    final db = await CreateTables.db();
    try {
      await db.delete('disciplina', where: "codigo = ?", whereArgs: [codigo]);
    } catch (e) {}
  }
}
