import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/script/table_fields.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class BuildEmployeeCard extends StatefulWidget {
  final BuildContext context;
  final Employee employee;
  static const double SPACE_BETWEEN_CONTENT = 4;
  static const double FONT_SIZE = 15;

  BuildEmployeeCard({
    required this.context,
    required this.employee,
  });

  @override
  State<BuildEmployeeCard> createState() => _BuildEmployeeCardState();
}

class _BuildEmployeeCardState extends State<BuildEmployeeCard> {
  DatabaseConnect conn = DatabaseConnect();
  String _deptName = '';
  int remainingTasks = 0;
  int finishedTasks = 0;

  getDepartmentName() async {
    final int deptID = widget.employee.deptID;
    final data = await conn.getDepartmentNameMap(deptID);

    _deptName = data;
  }

  Future<void> getEmployeeInfo() async {
    var allTasks = await conn.getTaskList(globals.loggedEmployee!.deptID);
    remainingTasks = allTasks
        .where((task) =>
            task.taskStatus == false && task.empID == widget.employee.empID)
        .toList()
        .length;
    finishedTasks = allTasks
        .where((task) =>
            task.taskStatus == true && task.empID == widget.employee.empID)
        .toList()
        .length;

    int deptID = widget.employee.deptID;
    final data = await conn.getDepartmentNameMap(deptID);

    _deptName = data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEmployeeInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Text(ConnectionState.done.toString());
        } else {
          return Container(
            height: 100,
            width: 50,
            // padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          (widget.employee.empAvatar == null)
                              ? "assets/avatars/img2.png"
                              : widget.employee.empAvatar!,
                        ),
                      ),
                      SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.employee.empName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      color: Colors.grey[700]),
                                ),
                                Text(
                                  ' (${widget.employee.roleID == 1 ? "Adminitrator" : widget.employee.roleID == 2 ? "Manager" : "Employee"})',
                                  style: TextStyle(
                                      fontSize: BuildEmployeeCard.FONT_SIZE,
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: 1,
                                      color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              _deptName, // Department Name
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee.empEmail,
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  // fontWeight: FontWeight.bold,
                                  // letterSpacing: 1,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee.empMobile,
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  // fontWeight: FontWeight.bold,
                                  // letterSpacing: 1,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee.empAddress,
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  // fontWeight: FontWeight.bold,
                                  // letterSpacing: 1,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 25),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Card(
                          color: kYellow,
                          // elevation: 8,
                          child: Container(
                            // color: Colors.transparent,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Finished Tasks: $finishedTasks",
                              style: TextStyle(
                                  color: kYellowDark,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Card(
                          color: Colors.grey[200],
                          // elevation: 8,
                          child: Container(
                            // color: Colors.transparent,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Remaining Tasks: $remainingTasks",
                              style: TextStyle(
                                  color: kYellowDark,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
