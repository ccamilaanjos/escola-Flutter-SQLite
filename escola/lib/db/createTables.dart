import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class CreateTables {
  static Future<void> createAluno(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS aluno(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome VARCHAR(100),
        data_nasc CHAR(10) NOT NULL,
        sexo CHAR(1) NOT NULL,
        cpf CHAR(11) NOT NULL
      )""");
  }

  static Future<void> createProfessor(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS professor (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nome VARCHAR(100),
      data_nasc CHAR(10) NOT NULL,
      sexo CHAR(1) NOT NULL,
      cpf CHAR(11) NOT NULL
    )""");
  }

  static Future<void> createDisciplina(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS disciplina (
      codigo CHAR(6) PRIMARY KEY NOT NULL,
      nome VARCHAR(50),
      prof_id INTEGER,
      FOREIGN KEY (prof_id) REFERENCES professores(id)
    )""");
  }

  static Future<void> createMatriculados(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS matriculados (
      aluno_id INTEGER,
      disciplina_cod INTEGER,
      FOREIGN KEY (disciplina_cod) REFERENCES disciplinas(codigo),
      FOREIGN KEY (aluno_id) REFERENCES alunos (id),
      PRIMARY KEY (disciplina_cod, aluno_id)
    )""");
  }

  static Future<sql.Database> db() async {
    // sql.deleteDatabase("escola.db");
    return sql.openDatabase("escola.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await CreateTables.createAluno(database);
      await CreateTables.createProfessor(database);
      await CreateTables.createDisciplina(database);
      await CreateTables.createMatriculados(database);
    });
  }
}
