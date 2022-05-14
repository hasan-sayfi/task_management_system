import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/manager/manager_task_tab.dart';
import 'package:task_management_system/screens/home/manager/manager_employee_tab.dart';
import 'package:task_management_system/screens/home/manager/manager_home_tab.dart';
import 'package:task_management_system/screens/home/profile_tab.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _botBarOptions = <Widget>[
    ManagerHomeTab(),
    ManagerEmployeeTab(),
    ManagerTaskTab(),
    ProfileTab(),
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
            icon: Icon(Icons.checklist),
            label: 'Tasks',
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
                _onItemTapped(3);
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
}
