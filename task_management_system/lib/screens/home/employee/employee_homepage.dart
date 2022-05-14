import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/dashboard_cards.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/role.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/employee/employee_task_tab.dart';
import 'package:task_management_system/screens/home/profile_tab.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;
import 'package:task_management_system/widgets/build_dashboard_card.dart';

class EmployeeHomePage extends StatefulWidget {
  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  static const double PROFILE_CONTAINER = 140;

  DatabaseConnect conn = DatabaseConnect();
  List<Employee> allEmployees = [];
  Employee? managerAccount;
  Employee? employeeAccount;
  List<Department> allDepartments = [];
  List<Role> allRoles = [];
  List<Task> allTasks = [];
  List<Task> finishedTasks = [];
  List<DashboardCards> _dahsboardCardsList = [];

  Future<void> getDahsboardCardsList() async {
    var allEmployees = await conn.getEmployeeList(null);
    var allDepartments = await conn.getDepartmentList();
    var allRoles = await conn.getRoleList();
    this.managerAccount = allEmployees.firstWhere((emp) =>
        emp.deptID == globals.loggedEmployee!.deptID && emp.roleID == 2);
    this.employeeAccount = allEmployees
        .firstWhere((emp) => emp.empID == globals.loggedEmployee!.empID);
    this.allEmployees = allEmployees
        .where((emp) =>
            emp.deptID == globals.loggedEmployee!.deptID && emp.roleID != 2)
        .toList();
    var allTasks = await conn.getTaskList(globals.loggedEmployee!.deptID);
    allTasks = allTasks
        .where((task) => task.empID == this.employeeAccount?.empID)
        .toList();
    var finishedTasks =
        allTasks.where((task) => task.taskStatus == true).toList();
    this.allDepartments = allDepartments;
    this.allRoles = allRoles;
    this.allTasks = allTasks;
    this.finishedTasks = finishedTasks;
    var _dahsboardCardsList = [
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: kBgColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu_sharp,
                size: 40,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => globals.goToLogin(context),
            icon: Icon(Icons.logout, size: 30),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBgColor,
        elevation: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kDefaultColor,
        onTap: _onItemTapped,
      ),
      backgroundColor: kBgColor,
      body: PageView(
        controller: pageController,
        children: [
          FutureBuilder(
            future: getDahsboardCardsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Text(ConnectionState.done.toString());
              } else {
                return _employeeHomeTab();
              }
            },
          ),
          EmployeeTaskTab(allTasks: allTasks, finishedTasks: finishedTasks),
          ProfileTab(),
        ],
        // child: _botBarOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: kDefaultColor,
                image: DecorationImage(
                    scale: 1.5,
                    image: AssetImage(
                        globals.loggedEmployee!.empAvatar.toString())),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                clipBehavior: Clip.hardEdge,
                // child:
                //     Image.asset(globals.loggedEmployee!.empAvatar.toString()),
                // AssetImage(
                //   globals.loggedEmployee!.empAvatar.toString(),
                // ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, AppRoutes.MANAGER_HOME);
              },
            ),
            SizedBox(
              height: 600,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                globals.goToLogin(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _employeeHomeTab() {
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
                            this.employeeAccount!.empName.split(' ').first +
                                '!',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${allRoles[employeeAccount!.roleID - 1].roleName}, ",
                            style: TextStyle(color: kFontBodyColor)),
                        Text(
                            _getDepartment(
                                allDepartments[employeeAccount!.deptID - 1]
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
                  backgroundImage: AssetImage(employeeAccount?.empAvatar == null
                      ? 'assets/avatars/img2.png'
                      : employeeAccount!.empAvatar!),
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
}
