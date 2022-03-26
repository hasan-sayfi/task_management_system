import 'package:flutter/material.dart';
import 'package:task_management_system/models/models_test/db_model.dart';
import 'package:task_management_system/models/models_test/todo_model.dart';
import 'package:task_management_system/widgets/todo_widgets/todo_list.dart';
import 'package:task_management_system/widgets/todo_widgets/user_input.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We Create insert function here because the 2 widgets can communicate

  // Create a DB object to access the DB functions
  var db = DatabaseConnect();

  // Add function
  void addItem(Todo todo) async {
    await db.insertTodo(todo);
    setState(() {});
  }

  // Delete function
  void deleteItem(Todo todo) async {
    await db.deleteTodo(todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple TODO App"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        backwardsCompatibility: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TodoList(
            insertFunction: addItem,
            deleteFunction: deleteItem,
          ),
          UserInput(insertFunction: addItem),
        ],
      ),
    );
  }
}
