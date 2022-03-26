import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/screens/home/manager/ManagerTaskTab.dart';
import 'package:task_management_system/screens/home/manager/manager_employee_tab.dart';
import 'package:task_management_system/screens/home/manager/manager_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _botBarOptions = <Widget>[
    HomeManager(),
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
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        elevation: 0,
        backwardsCompatibility: false,
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.menu_sharp,
            size: 50,
          ),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: kBgColor,
      body: Center(
        child: _botBarOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
