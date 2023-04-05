import 'package:sqflite/sqflite.dart' as sql;
import 'createTables.dart';

class SQLHelperAluno {
  static Future<int> createData(
      String nome, String data_nasc, String sexo, String cpf) async {
    final db = await CreateTables.db();

    final aluno = {
      'nome': nome,
      'data_nasc': data_nasc,
      'sexo': sexo,
      'cpf': cpf
    };
    final id = await db.insert('aluno', aluno,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await CreateTables.db();
    return db.query('aluno', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await CreateTables.db();
    return db.query('aluno', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String nome, String data_nasc, String sexo, String cpf) async {
    final db = await CreateTables.db();
    final aluno = {
      'nome': nome,
      'data_nasc': data_nasc,
      'sexo': sexo,
      'cpf': cpf,
    };
    final result =
        await db.update('aluno', aluno, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await CreateTables.db();
    try {
      await db.delete('aluno', where: "id = ?", whereArgs: [id]);
    } catch (e) {}
  }
}
