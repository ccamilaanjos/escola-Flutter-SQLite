import 'package:escola/db/db_professor.dart';
import 'package:flutter/material.dart';

class Professor extends StatefulWidget {
  @override
  State<Professor> createState() => _ProfessorState();
}

class _ProfessorState extends State<Professor> {
  List<Map<String, dynamic>> _allData = [];
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  // Ler todos os dados
  void _refreshData() async {
    final data = await SQLHelperProfessor.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Cadastrar
  Future<void> _addData() async {
    await SQLHelperProfessor.createData(_nomeController.text,
        _data_nascController.text, _sexoController.text, _cpfController.text);
    _refreshData();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text('Professor adicionado'),
    ));
  }

  // Atualizar
  Future<void> _updateData(int id) async {
    await SQLHelperProfessor.updateData(id, _nomeController.text,
        _data_nascController.text, _sexoController.text, _cpfController.text);
    _refreshData();
  }

  // Deletar
  void _deleteData(int id) async {
    await SQLHelperProfessor.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('Professor excluído'),
    ));
    _refreshData();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _data_nascController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  // Se o ID não for nulo, vai atualizar, senão vai adicionar um novo
  // Quando o botão de editar for pressionado o ID será passado para a função bottomsheed
  // e vai editar
  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _data_nascController.text = existingData['data_nasc'];
      _sexoController.text = existingData['sexo'];
      _cpfController.text = existingData['cpf'];
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome *",
                ),
                validator: (controlador) {
                  if (controlador == null || controlador.isEmpty) {
                    return "Por favor, insira o nome do professor";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _data_nascController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Data de Nascimento *",
                ),
                validator: (controlador) {
                  if (controlador == null || controlador.isEmpty) {
                    return "Por favor, insira a data de nascimento do professor";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _sexoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Sexo *",
                ),
                validator: (controlador) {
                  if (controlador == null || controlador.isEmpty) {
                    return "Por favor, insira o sexo do professor";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CPF *",
                ),
                validator: (controlador) {
                  if (controlador == null || controlador.isEmpty) {
                    return "Por favor, insira o CPF do professor";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && !isFormEmpty()) {
                      if (id == null) {
                        await _addData();
                      }
                      if (id != null) {
                        await _updateData(id);
                      }

                      // Hide Bottom Sheet
                      Navigator.of(context).pop();
                    }

                    _nomeController.text = "";
                    _data_nascController.text = "";
                    _sexoController.text = "";
                    _cpfController.text = "";
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      id == null ? "Adicionar" : "Atualizar",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Professores'),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      tileColor: Colors.white,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Matrícula: ${_allData[index]['id']}'),
                          Text('CPF: ${_allData[index]['cpf']}'),
                          Text('Sexo: ${_allData[index]['sexo']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showBottomSheet(_allData[index]['id']);
                              },
                              tooltip: 'Editar',
                              icon: Icon(Icons.edit, color: Colors.indigo)),
                          IconButton(
                              onPressed: () {
                                _deleteData(_allData[index]['id']);
                              },
                              tooltip: 'Excluir',
                              icon:
                                  Icon(Icons.delete, color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        tooltip: 'Adicionar',
        child: Icon(Icons.add),
      ),
    );
  }

  bool isFormEmpty() {
    if (_nomeController == "" ||
        _data_nascController == "" ||
        _sexoController == "" ||
        _cpfController == "") {
      return true;
    }

    return false;
  }
}
