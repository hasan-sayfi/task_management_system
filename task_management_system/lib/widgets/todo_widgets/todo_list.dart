import 'package:flutter/material.dart';
import 'package:task_management_system/models/models_test/db_model.dart';
import 'package:task_management_system/widgets/todo_widgets/todo_card.dart';

// ignore: must_be_immutable
class TodoList extends StatelessWidget {
  // Passed down function from todo card
  final Function insertFunction;
  final Function deleteFunction;

  // Create an object of DB connect
  var db = DatabaseConnect();

  TodoList({
    Key? key,
    required this.insertFunction,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: db.getTodo(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var dataList = snapshot.data; // The list of todo is here
          var dataLength = dataList!.length;

          return dataLength == 0
              ? Center(
                  child: Text("There are no data found!"),
                )
              : ListView.builder(
                  itemCount: dataLength,
                  itemBuilder: (context, index) => TodoCard(
                    id: dataList[index].id,
                    title: dataList[index].title,
                    creationDate: dataList[index].creationDate,
                    isChecked: dataList[index].isChecked,
                    insertFunction: insertFunction,
                    deleteFunction: deleteFunction,
                  ),
                );
        },
      ),
    );
  }
}
