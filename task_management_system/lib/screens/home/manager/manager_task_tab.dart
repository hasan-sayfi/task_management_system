import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/manager/manager_task_tab_complete.dart';
import 'package:task_management_system/screens/home/manager/manager_task_tab_list.dart';

class ManagerTaskTab extends StatefulWidget {
  const ManagerTaskTab({Key? key}) : super(key: key);

  @override
  State<ManagerTaskTab> createState() => _ManagerTaskTabState();
}

class _ManagerTaskTabState extends State<ManagerTaskTab> {
  // static List<Task> allTasks = [];
  List<Task> allTasks = Task.getTasksWithManager(2);
  List<Task> completedTasks = Task.getCompletedTasksWithManager(2);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: TabBar(
          indicatorColor: kDefaultColor,
          tabs: [
            Tab(
              child: Text('All Tasks', style: TextStyle(color: kDefaultColor)),
              icon: Icon(
                Icons.list,
                color: kFontBodyColor,
              ),
              iconMargin: EdgeInsets.all(5),
            ),
            Tab(
              child: Text('Completed Tasks',
                  style: TextStyle(color: kDefaultColor)),
              icon: Icon(
                Icons.playlist_add_check_rounded,
                color: kFontBodyColor,
              ),
              iconMargin: EdgeInsets.all(5),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ManagerTaskTabList(allTasks),
            ManagerTaskTabComplete(completedTasks),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _startAddNewTask(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _startAddNewTask(BuildContext context) async {
    dynamic task = await Navigator.pushNamed(context, AppRoutes.NEW_TASK);
    setState(() {
      allTasks.add(task);
    });
  }

// Refresh inficator
  Future<void> _refresh() async {
    return await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        allTasks = Task.getTasksWithManager(2);
      });
    });
  }
}
