import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:escola/db/db_matriculados.dart';

class Matriculados extends StatefulWidget {
  const Matriculados({super.key});

  @override
  State<Matriculados> createState() => _MatriculadosState();
}

class _MatriculadosState extends State<Matriculados> {
  List<Map<String, dynamic>> _allMatriculados = [];

  // Pegar todos os dados da tabela matriculados
  void _getMatriculados() async {
    final matriculados = await SQLHelperMatriculados.getAllData();
    setState(() {
      _allMatriculados = matriculados;
    });
  }

  @override
  void initState() {
    _getMatriculados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Alunos matriculados"),
      ),
      body: ListView.builder(
          itemCount: _allMatriculados.length,
          itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Matrícula: ${_allMatriculados[index]['aluno_id']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Matrícula: ${_allMatriculados[index]['aluno_id']}"),
                      ],
                    ),
                  ),
                  trailing: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              removeAluno(_allMatriculados[index]['aluno_id'],
                                  _allMatriculados[index]['disciplina_cod']);
                            },
                            icon: Icon(Icons.remove_circle_sharp),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  void removeAluno(int aluId, String discCOD) async {
    await SQLHelperMatriculados.deleteData(discCOD, aluId);
    _getMatriculados();
    print("Excluido");
  }
}
