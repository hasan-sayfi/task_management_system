import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/dashboard_cards.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/role.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/widgets/build_dashboard_card.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class ManagerHomeTab extends StatefulWidget {
  const ManagerHomeTab({Key? key}) : super(key: key);

  @override
  State<ManagerHomeTab> createState() => _ManagerHomeTabState();
}

class _ManagerHomeTabState extends State<ManagerHomeTab> {
  DatabaseConnect conn = DatabaseConnect();
  List<Employee> allEmployees = [];
  List<Department> allDepartments = [];
  List<Role> allRoles = [];
  List<Task> allTasks = [];
  List<Task> finishedTasks = [];
  List<DashboardCards> _dahsboardCardsList = [];
  static const double PROFILE_CONTAINER = 140;

  Future<void> getDahsboardCardsList() async {
    var allEmployees = await conn.getEmployeeList(null);
    var allDepartments = await conn.getDepartmentList();
    var allRoles = await conn.getRoleList();
    var allTasks = await conn.getTaskList(globals.loggedEmployee!.deptID);
    var finishedTasks =
        allTasks.where((task) => task.taskStatus == true).toList();
    print('allTasks: $allTasks');
    print('----------------');
    print('finishedTasks: $finishedTasks');
    this.allEmployees = allEmployees
        .where((emp) =>
            emp.deptID == globals.loggedEmployee!.deptID && emp.roleID != 2)
        .toList();
    this.allDepartments = allDepartments;
    this.allRoles = allRoles;
    var _dahsboardCardsList = [
      DashboardCards(
        iconData: Icons.groups,
        title: 'Employees',
        total: this.allEmployees.length,
        bgColor: kYellowLight,
        btnColor: kYellow,
        iconColor: kYellowDark,
      ),
      DashboardCards(
        iconData: Icons.task,
        title: 'Tasks',
        total: allTasks.length,
        bgColor: kBlueLight,
        btnColor: kBlue,
        iconColor: kBlueDark,
      ),
      DashboardCards(
        iconData: Icons.add_task,
        title: 'Finished Tasks',
        total: finishedTasks.length,
        bgColor: kGreenLight,
        btnColor: kGreen,
        iconColor: kGreenDark,
      ),
      DashboardCards(
        iconData: Icons.watch_later,
        title: "Remaining Tasks",
        bgColor: kRedLight,
        btnColor: kRed,
        total: allTasks.length - finishedTasks.length,
        iconColor: kRedDark,
      ),
    ];
    this._dahsboardCardsList = _dahsboardCardsList;
  }

  String _getDepartment(String deptName) {
    var deptNameList = deptName.split(' '); //[Human, Resources] -> length = 2
    String shortenName = '';
    if (deptName.length > 10 && deptNameList.length > 0) {
      for (var name in deptNameList) {
        shortenName += name.substring(0, 1).toUpperCase();
      }
    } else {
      shortenName = deptName;
    }
    return shortenName + ' Department';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDahsboardCardsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Text(ConnectionState.done.toString());
          } else {
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: PROFILE_CONTAINER / 3),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    // fit: StackFit.passthrough,
                    children: [
                      Container(
                        height: PROFILE_CONTAINER,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(height: PROFILE_CONTAINER / 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Hello, ",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: kFontBodyColor,
                                    )),
                                Text(
                                    globals.loggedEmployee!.empName
                                            .split(' ')
                                            .first +
                                        '!',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "${allRoles[globals.loggedEmployee!.roleID - 1].roleName}, ",
                                    style: TextStyle(color: kFontBodyColor)),
                                Text(
                                    _getDepartment(allDepartments[
                                            globals.loggedEmployee!.deptID - 1]
                                        .deptName),
                                    style: TextStyle(color: kFontBodyColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        // left: 50,
                        top: -50,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(
                              globals.loggedEmployee?.empAvatar == null
                                  ? 'assets/avatars/img2.png'
                                  : globals.loggedEmployee!.empAvatar!),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: PROFILE_CONTAINER / 5),
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.only(bottom: 100, top: 100),
                      child: GridView.builder(
                        itemCount: _dahsboardCardsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return BuildDashboardCard(
                              context: context,
                              dashboardCard: _dahsboardCardsList[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
