import 'package:flutter/material.dart';
import 'package:quizy/screens/quiz.dart';
import 'package:quizy/screens/result.dart';
import 'package:quizy/screens/start.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(190, 56, 55, 1.0),
        colorScheme: const ColorScheme.light(
          background: Color.fromRGBO(37, 44, 74, 1.0),
        ),
      ),
      routes: {
        'start': (context) => Start(),
        'quiz': (context) => const Quiz(),
        'result': (context) => const Result(),
      },
      home: Start(),
    );
  }
}
