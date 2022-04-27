import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/widgets/build_employee_card.dart';

class ManagerEmployeeList extends StatelessWidget {
  final List<Employee> employees;

  ManagerEmployeeList(this.employees);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 520,
      child: employees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'No Employees added yet!',
                    style: TextStyle(fontSize: 24, color: kOrange),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 200,
                      child: Image.asset(
                        'assets/background/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              ),
            )
          : GridView.builder(
              itemCount: employees.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Center();
                // return BuildEmployeeCard(
                //   context: context,
                //   employee: employees[index],
                // );
              },
            ),
    );
  }
}
