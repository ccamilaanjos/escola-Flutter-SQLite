import 'package:escola/db/db_aluno.dart';
import 'package:escola/db/db_disciplina.dart';
import 'package:flutter/cupertino.dart';
import '../db/db_professor.dart';
import 'package:flutter/material.dart';
import 'package:escola/db/db_matriculados.dart';

class Disciplina extends StatefulWidget {
  @override
  State<Disciplina> createState() => _DisciplinaState();
}

class _DisciplinaState extends State<Disciplina> {
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _allProfs = [];
  List<Map<String, dynamic>> _allAlunos = [];

  String profAtual = 'Sem professor';
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  int? _profController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool status = false;
  late ValueChanged<bool> onChanged;

  // Ler todos os dados
  void _refreshData() async {
    final data = await SQLHelperDisciplina.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  // Pegar todos os professores
  void _getProfessores() async {
    final profs = await SQLHelperProfessor.getAllDataABC();
    setState(() {
      _allProfs = profs;
      _isLoading = false; //
    });
  }

  // Pegar todos os alunos
  void _getAlunos() async {
    final alunos = await SQLHelperAluno.getAllData();
    setState(() {
      _allAlunos = alunos;
      _isLoading = false; //
    });
  }

  @override
  void initState() {
    _refreshData();
    _getProfessores();
    _getAlunos();
  }

  // Cadastrar
  Future<void> _addData() async {
    await SQLHelperDisciplina.createData(
        _codigoController.text, _nomeController.text, _profController);
    _refreshData();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text('Disciplina adicionada'),
    ));
  }

  // Atualizar
  Future<void> _updateData(String codigo) async {
    await SQLHelperDisciplina.updateData(
        codigo, _nomeController.text, _profController);
    _refreshData();
  }

  // Deletar
  void _deleteData(String codigo) async {
    await SQLHelperDisciplina.deleteData(codigo);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Disciplina excluída'),
    ));
    _refreshData();
  }

  // Adiciona professor à tabela disciplina
  void sendIdProf(int? id) {
    if (id != null) {
      final existingProf =
          _allProfs.firstWhere((element) => element['id'] == id);
      _profController = id;
    }
  }

  // Envia dados para a tabela matrícula
  void sendIdAndCod(String discID, int aluID) async {
    await SQLHelperMatriculados.createData(discID, aluID);
  }

  String getProfName(int id) {
    final profe = _allProfs.indexWhere((element) => element['id'] == id);
    if (profe == -1) {
      return "Sem professor";
    }
    return _allProfs[profe]['nome'];
  }

  // Se o codigo não for nulo, vai atualizar, senão vai adicionar um novo
  // Quando o botão de editar for pressionado o codigo será passado para a função bottomsheed
  // e vai editar
  void addEditBottomSheet(String? codigo) async {
    profAtual = "Sem professor";
    if (codigo != null) {
      final existingData =
          _allData.firstWhere((element) => element['codigo'] == codigo);

      _codigoController.text = existingData['codigo'];
      _nomeController.text = existingData['nome'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Código da Disciplina *",
                    ),
                    validator: (controlador) {
                      if (controlador == null || controlador.isEmpty) {
                        return "Por favor, insira o código da disciplina";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nome *",
                      ),
                      validator: (controlador) {
                        if (controlador == null || controlador.isEmpty) {
                          return "Por favor, insira o nome da disciplina";
                        }
                        return null;
                      }),
                ],
              ),
            ),
            Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                    title: Text(profAtual),
                    enabled: true,
                    trailing: const Icon(Icons.arrow_drop_down),
                    shape: const OutlineInputBorder(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Column(
                            children: const [
                              Text("Escolha um professor"),
                              Divider(
                                height: 30.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          content: SizedBox(
                            width: double.minPositive,
                            child: CupertinoScrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _allProfs.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _allProfs[index]['nome'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      onTap: () {
                                        _profController =
                                            _allProfs[index]['id'];
                                        sendIdProf(_profController);
                                        setState(() {
                                          profAtual = _allProfs[index]['nome'];
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ),
                      );
                    })),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && !isFormEmpty()) {
                    if (codigo == null) {
                      await _addData();
                    }
                    if (codigo != null) {
                      await _updateData(codigo);
                    }

                    // Hide Bottom Sheet
                    Navigator.of(context).pop();
                  }

                  _codigoController.text = "";
                  _nomeController.text = "";
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    codigo == null ? "Adicionar" : "Atualizar",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Disciplinas'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _allData[index]['nome'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_allData[index]['codigo']),
                            Text(
                                'Professor: ${getProfName(_allData[index]['prof_id'])}'),
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
                                    Navigator.pushNamed(
                                        context, "/matriculados");
                                  },
                                  tooltip: 'Listar',
                                  icon: const Icon(Icons.list,
                                      color: Colors.indigo)),
                              IconButton(
                                  onPressed: () {
                                    matricularAlunoBottomSheet(
                                        _allData[index]['codigo']);
                                  },
                                  tooltip: 'Matricular',
                                  icon: const Icon(Icons.person_add,
                                      color: Colors.pink)),
                              IconButton(
                                  onPressed: () {
                                    addEditBottomSheet(
                                        _allData[index]['codigo']);
                                  },
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green)),
                              IconButton(
                                  onPressed: () {
                                    _deleteData(_allData[index]['codigo']);
                                  },
                                  tooltip: 'Excluir',
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addEditBottomSheet(null),
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }

  bool isFormEmpty() {
    if (_nomeController == "" || _codigoController == "") {
      return true;
    }

    return false;
  }

  void matricularAlunoBottomSheet(String disc_id) {
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            child: Column(
              children: const [
                Card(
                  elevation: 5,
                  color: Colors.green,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Matricular alunos",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _allAlunos.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sendIdAndCod(disc_id, _allAlunos[index]['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              _allAlunos[index]['nome'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Matrícula: ${_allAlunos[index]['id'].toString()}',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'CPF: ${_allAlunos[index]['cpf']}',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'Sexo: ${_allAlunos[index]['sexo']}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
