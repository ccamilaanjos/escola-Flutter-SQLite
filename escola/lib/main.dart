import 'screens/home_screen.dart';
import 'screens/aluno_screen.dart';
import 'screens/professor_screen.dart';
import 'screens/disciplina_screen.dart';
import 'package:flutter/material.dart';
import 'screens/matriculados_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/alunos": (context) => Aluno(),
        "/professores": (context) => Professor(),
        "/disciplinas": (context) => Disciplina(),
        "/matriculados": (context) => Matriculados(),
      },
    );
  }
}
