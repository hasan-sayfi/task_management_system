import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/manager/manager_task_tab.dart';
import 'package:task_management_system/screens/home/manager/manager_employee_tab.dart';
import 'package:task_management_system/screens/home/manager/manager_home_tab.dart';

class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _botBarOptions = <Widget>[
    ManagerHomeTab(),
    ManagerEmployeeTab(),
    ManagerTaskTab(),
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
              },
            ),
            ListTile(
              title: const Text('Manager'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.MANAGER_HOME);
              },
            ),
          ],
        ),
      ),
    );
  }
}
