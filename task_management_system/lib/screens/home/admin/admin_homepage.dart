import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/admin/admin_department_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_employee_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_home_tab.dart';
import 'package:task_management_system/screens/home/admin/admin_role_tab.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class AdminHomePage extends StatefulWidget {
  // Employee employee;
  // AdminHomePage({
  //   required this.employee,
  // });
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Employee employee;
  // _AdminHomePageState({
  //   required this.employee,
  // });
  int _selectedIndex = 0;
  static List<Widget> _botBarOptions = <Widget>[
    AdminHomeTab(),
    AdminEmployeeTab(),
    AdminDepartmentTab(),
    AdminRoleTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      print('globals.loggedEmployee: ' + globals.loggedEmployee.toString());
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('AdminHomePage: $employee');
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
