import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_system/models/models_test/todo_model.dart';

// ignore: must_be_immutable
class TodoCard extends StatefulWidget {
  // Create variable that todo card will receive data for
  final int id;
  final String title;
  final DateTime creationDate;
  bool isChecked;
  final Function insertFunction;
  final Function deleteFunction;

  TodoCard({
    required this.id,
    required this.title,
    required this.creationDate,
    required this.isChecked,
    required this.insertFunction, // Handle changes in checkbox
    required this.deleteFunction, // Handle delete button
    Key? key,
  }) : super(key: key);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    // Create a local todo
    var anotherTodo = Todo(
      id: widget.id,
      title: widget.title,
      creationDate: widget.creationDate,
      isChecked: widget.isChecked,
    );

    return Card(
      child: Row(
        children: [
          // This will be the checkbox
          Container(
            child: Checkbox(
              value: widget.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.isChecked = value!;
                });
                // Change the value of anotherTodo's isCheck
                anotherTodo.isChecked = value!;
                // Insert it into DB
                widget.insertFunction(anotherTodo);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  DateFormat('dd MMM yyyy - hh:mm aaa')
                      .format(widget.creationDate),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          // This will be the delete button
          IconButton(
              onPressed: () {
                // Add delete function
                widget.deleteFunction(anotherTodo);
              },
              icon: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
