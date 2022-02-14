import 'package:flutter/material.dart';
import 'package:task_management_system/models/db_model.dart';
import 'package:task_management_system/models/todo_model.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseConnect();
  // Insert a sample todo
  await db.insertTodo(Todo(
    title: 'Sample todo task',
    creationDate: DateTime.now(),
    isChecked: false,
  ));
  await db.insertTodo(Todo(
    title: 'Sample todo task 2',
    creationDate: DateTime.now(),
    isChecked: false,
  ));
  await db.insertTodo(Todo(
    title: 'Sample todo task 3',
    creationDate: DateTime.now(),
    isChecked: true,
  ));
  print(await db.getTodo());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
