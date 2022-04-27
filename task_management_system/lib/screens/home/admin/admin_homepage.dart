import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/admin/admin_department_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_employee_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_home_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_role_tab.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _botBarOptions = <Widget>[
    AdminHomeTab(),
    AdminEmployeeTab(),
    AdminDepartmentTab(),
    AdminRoleTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        elevation: 0,
        backwardsCompatibility: false,
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
            onPressed: () {
              // TODO: Logout action
              setState(() {
                print("Refreshing!");
              });
            },
            icon: Icon(Icons.logout, size: 30),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBgColor,
        elevation: 3,
        unselectedItemColor: kFontBodyColor,
        unselectedLabelStyle: TextStyle(color: kFontBodyColor),
        // showSelectedLabels: true,
        showUnselectedLabels: true,
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.ADMIN_HOME);
                // setState(() {
                //   _selectedIndex = 1;
                // });
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Manager'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.MANAGER_HOME);
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}