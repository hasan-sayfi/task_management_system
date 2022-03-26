import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/widgets/build_employee_card.dart';

class ManagerTaskTab extends StatefulWidget {
  const ManagerTaskTab({Key? key}) : super(key: key);

  @override
  State<ManagerTaskTab> createState() => _ManagerTaskTabState();
}

class _ManagerTaskTabState extends State<ManagerTaskTab> {
  // static List<Task> allTasks = [];
  List<Task> allTasks = Task.getTasksWithManager(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
      ),
      body: Container(
        child: allTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'No Tasks added yet!',
                      style: TextStyle(fontSize: 24, color: kOrange),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 200,
                        child: Image.asset(
                          'assets/background/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              )
            : GridView.builder(
                itemCount: allTasks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Text("TODO");
                },
              ),
      ),
    );
  }
}
