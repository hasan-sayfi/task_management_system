import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/screens/home/admin/admin_homepage.dart';
import 'package:task_management_system/screens/home/employee/employee_homepage.dart';
import 'package:task_management_system/screens/home/manager/manager_homepage.dart';

const users = const {
  't@t.com': '123',
  'hsayfi@gmail.com': '112233',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2000);
  DatabaseConnect conn = DatabaseConnect();
  late Employee employee;
  Future<List<Employee>> _getUser() async {
    final employees = await conn.getAllEmployeeList();
    employees.forEach((employee) {
      // print('Employee: ' + employee.empPassword.toString());
      print('Email: ${employee.empEmail}, Password: ${employee.empPassword}');
    });
    return employees;
  }

  Future<String?> _authUser(LoginData data) async {
    final employees = await _getUser();
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    Employee? emp;
    String? error;
    return Future.delayed(loginTime).then((_) async {
      employees.forEach((employee) {
        if (employee.empEmail.contains(data.name) &&
            employee.empPassword == data.password) {
          print(
              'Email: ${employee.empPassword}, Password: ${employee.empPassword}');
          emp = employee;
          return;
        }
      });
      if (emp == null) {
        // print(
        //     'employee.empEmail: ${employee.empEmail}, data.name: ${data.name}, Pass: ${employee.empPassword}');
        error = 'Email and/or password are incorrect!';
        return error;
      } else {
        this.employee = emp!;
        error = null;
        print('Employee was found: ' + emp.toString());
        return null;
      }
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getUser();
    return FlutterLogin(
      title: 'Task Management',
      logo: AssetImage('assets/logo/task_logo.png'),
      onLogin: _authUser,
      theme: LoginTheme(
        buttonTheme: LoginButtonTheme(
            backgroundColor: kDefaultColor, splashColor: kOrangeDark),
        pageColorLight: kDefaultColor,
        pageColorDark: kBlueDark,
        primaryColor: kDefaultColor,
        // primaryColorAsInputLabel: true,
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            switch (this.employee.roleID) {
              case 1:
                // return AdminHomePage(employee: this.employee);
                return AdminHomePage();
              case 2:
                return ManagerHomePage();
              case 3:
                return EmployeeHomePage();
              default:
                return EmployeeHomePage();
            }
          },
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
