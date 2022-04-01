import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/widgets/build_task_card.dart';

class ManagerTaskTabList extends StatelessWidget {
  final List<Task> allTasks;

  ManagerTaskTabList(this.allTasks);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          : Container(
              height: 450,
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: allTasks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  // crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return BuildTaskCard(
                    context: context,
                    task: allTasks[index],
                  );
                },
              ),
            ),
    );
  }
}
