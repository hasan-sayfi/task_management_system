import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/widgets/manager_employee_list.dart';

class ManagerEmployeeTab extends StatefulWidget {
  const ManagerEmployeeTab({Key? key}) : super(key: key);

  static List<Employee> allEmployees = Employee.getEmployeesInDepartment(2);

  @override
  State<ManagerEmployeeTab> createState() => _ManagerEmployeeTabState();
}

class _ManagerEmployeeTabState extends State<ManagerEmployeeTab> {
  var _allEmployees = ManagerEmployeeTab.allEmployees;
  // final List<Employee> _allEmployees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startAddNewEmployee(context);
        },
        child: Icon(Icons.add),
      ),
      body: ManagerEmployeeList(_allEmployees),
    );
  }

  void _addNewEmployee(int empID, int roleID, int deptID, String empName,
      String empEmail, String empMobile, String empAddress, String empAvatar) {
    final newEmp = Employee(
      empID: _allEmployees.length + 1,
      roleID: 3,
      deptID: 2,
      empName: empName,
      empEmail: empEmail,
      empMobile: empMobile,
      empAddress: empAddress,
    );

    setState(() {
      _allEmployees.add(newEmp);
    });
  }

  void _startAddNewEmployee(BuildContext context) async {
    dynamic emp = await Navigator.pushNamed(context, AppRoutes.NEW_EMPLOYEE);
    setState(() {
      _allEmployees.add(emp);
    });
  }

// Refresh inficator
  Future<void> _refresh() async {
    setState(() {});
    return Future.delayed(
      Duration(seconds: 3),
    );
  }
}
