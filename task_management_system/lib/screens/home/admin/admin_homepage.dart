import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/admin/admin_department_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_employee_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_home_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_role_tab.dart';
import 'package:task_management_system/screens/home/profile_tab.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  var size,height,width;
  static List<Widget> _botBarOptions = <Widget>[
    AdminHomeTab(),
    AdminEmployeeTab(),
    AdminDepartmentTab(),
    AdminRoleTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      print('globals.loggedEmployee: ' + globals.loggedEmployee.toString());
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: kBgColor,
        elevation: 0,
        // backwardsCompatibility: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu_sharp,
                size: 40,
                color: Colors.black,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => globals.goToLogin(context),
            icon: Icon(Icons.logout, size: 30, color: Colors.black),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kBgColor,
        elevation: 3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility),
            label: 'Roles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kDefaultColor,
        onTap: _onItemTapped,
      ),
      backgroundColor: kBgColor,
      body: Center(
        child: _botBarOptions.elementAt(_selectedIndex),
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
                _onItemTapped(4);
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
              height: height/2,
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
}
