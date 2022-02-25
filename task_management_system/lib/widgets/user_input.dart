import 'package:flutter/material.dart';
import 'package:task_management_system/models/todo_model.dart';

// ignore: must_be_immutable
class UserInput extends StatelessWidget {
  var textController = TextEditingController();
  final Function insertFunction; // This will receive the addItem function

  UserInput({Key? key, required this.insertFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Add New TODO",
                  contentPadding: EdgeInsets.only(left: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Create a todo
              var myTodo = Todo(
                title: textController.text,
                creationDate: DateTime.now(),
                isChecked: false,
              );
              insertFunction(myTodo);
            },
            child: Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(15),
              color: Colors.orangeAccent,
              child: Text(
                "Add",
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
