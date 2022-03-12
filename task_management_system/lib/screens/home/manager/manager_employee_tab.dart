import 'package:flutter/material.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/widgets/build_employee_card.dart';

class ManagerEmployeeTab extends StatefulWidget {
  const ManagerEmployeeTab({Key? key}) : super(key: key);

  @override
  State<ManagerEmployeeTab> createState() => _ManagerEmployeeTabState();
}

class _ManagerEmployeeTabState extends State<ManagerEmployeeTab> {
  final _allEmployees = Employee.getEmployeesInDepartment(2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: GridView.builder(
        itemCount: _allEmployees.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return BuildEmployeeCard(
            context: context,
            employee: _allEmployees[index],
          );
        },
      ),
    );
  }
}
