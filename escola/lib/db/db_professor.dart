import 'package:escola/db/createTables.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperProfessor {
  static Future<int> createData(
      String nome, String data_nasc, String sexo, String cpf) async {
    final db = await CreateTables.db();

    final professor = {
      'nome': nome,
      'data_nasc': data_nasc,
      'sexo': sexo,
      'cpf': cpf
    };
    final id = await db.insert('professor', professor,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await CreateTables.db();
    return db.query('professor', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getAllDataABC() async {
    final db = await CreateTables.db();
    return db.query('professor', orderBy: 'nome');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await CreateTables.db();
    return db.query('professor', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String nome, String data_nasc, String sexo, String cpf) async {
    final db = await CreateTables.db();
    final professor = {
      'nome': nome,
      'data_nasc': data_nasc,
      'sexo': sexo,
      'cpf': cpf,
    };
    final result = await db
        .update('professor', professor, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await CreateTables.db();
    try {
      await db.delete('professor', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }
}
