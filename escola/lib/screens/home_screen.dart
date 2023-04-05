import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ninjaLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Escola'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/alunos");
                },
                child: const Text(
                  'Alunos',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/professores");
                },
                child: const Text(
                  'Professores',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/disciplinas");
                },
                child: const Text(
                  'Disciplinas',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SizedBox
// weight: horizontal
// height: vertical

/*
Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 40.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/alunos");
            },
            child: Text('Alunos'),
          ),
        ]),
      ),*/