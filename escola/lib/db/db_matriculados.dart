import 'package:sqflite/sqflite.dart' as sql;
import 'createTables.dart';

class SQLHelperMatriculados {
  static Future<int> createData(String disc_cod, int aluno_id) async {
    final db = await CreateTables.db();

    final matricula = {
      'disciplina_cod': disc_cod,
      'aluno_id': aluno_id,
    };
    final id = await db.insert('matriculados', matricula,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await CreateTables.db();
    return db.query('matriculados');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(
      String disciplina_cod, int aluno_id) async {
    final db = await CreateTables.db();
    return db.query('matriculados',
        where: "disciplina_cod = ? AND aluno_id = ?",
        whereArgs: [disciplina_cod, aluno_id]);
  }

  static Future<void> deleteData(String? disciplina_cod, int aluno_id) async {
    final db = await CreateTables.db();

    if (disciplina_cod == null) {
      await db
          .delete('matriculados', where: "aluno_id = ?", whereArgs: [aluno_id]);
    }

    try {
      await db.delete('matriculados',
          where: "disciplina_cod = ? AND aluno_id = ?",
          whereArgs: [disciplina_cod, aluno_id]);
    } catch (e) {}
  }
}
