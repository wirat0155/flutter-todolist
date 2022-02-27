import 'package:flutter/material.dart';
import 'pages/todolist.dart';
import 'pages/add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "To Do List",
      home: Todolist(),
    );
  }
}
