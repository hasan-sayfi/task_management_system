import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/admin/admin_homepage.dart';
import 'package:task_management_system/screens/home/manager/manager_homepage.dart';
import 'package:task_management_system/screens/login/login_page.dart';
import 'package:task_management_system/screens/new_employee.dart';
import 'package:task_management_system/screens/new_task.dart';
import 'package:task_management_system/screens/task_records.dart';
import 'package:task_management_system/script/table_fields.dart';
import 'package:task_management_system/script/table_names.dart';

import 'constants/colors.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseConnect conn = DatabaseConnect();
  Database? db = await conn.database;

  var roles = [
    {TableFields.roleID: 1, TableFields.roleName: 'Administrator'},
    {TableFields.roleID: 2, TableFields.roleName: 'Manager'},
    {TableFields.roleID: 3, TableFields.roleName: 'Employee'},
  ];
  var departments = [
    {TableFields.deptID: 1, TableFields.deptName: 'Administrator'},
    {TableFields.deptID: 2, TableFields.deptName: 'Information Technology'},
    {TableFields.deptID: 3, TableFields.deptName: 'Human Resources'},
  ];
  var adminEmp = {
    'empID': 1,
    'roleID': 1,
    'deptID': 1,
    'empName': 'Super Admin',
    'empEmail': 'task.management.smtp@gmail.com',
    'empMobile': '0555555555',
    'empAddress': '123 Some st',
    'empAvatar': 'assets/avatars/img1.png',
    'empPassword': 'Admin123',
  };

  var existRoles = await db!.query(TableNames.roleTableName);
  // print('existRoles ${existRoles.toString()}, isEmpty: ${existRoles.isEmpty}');

  var existDepartments = await db.query(TableNames.deptTableName);
  // print('existDepartments ${existDepartments.toString()}, isEmpty: ${existDepartments.isEmpty}');

  var existAdmin = await db.query(TableNames.empTableName,
      where: '${TableFields.empID} = 1 and ${TableFields.roleID} = 1');
  // print('existAdmin ${existAdmin.toString()}, isEmpty: ${existAdmin.isEmpty}');

  if (existRoles.isEmpty) {
    for (var role in roles) {
      db.insert(TableNames.roleTableName, role);
      print('Role inserted: $role');
    }
  } else {
    print('Roles exist!');
  }
  if (existDepartments.isEmpty) {
    for (var department in departments) {
      db.insert(TableNames.deptTableName, department);
      print('Department inserted: $department');
    }
  } else {
    print('Departments exist!');
  }
  if (existAdmin.isEmpty) {
    db.insert(TableNames.empTableName, adminEmp);
    print('Admin inserted: $adminEmp');
  } else {
    print('Admin exist!');
  }
  // final insertRoles = db.insert(TableNames.roleTableName, ['', 'f']);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: kOrange,
              primary: kOrange,
            ),
      ),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        AppRoutes.HOME: (context) => LoginPage(),
        AppRoutes.LOGIN_PAGE: ((context) => LoginPage()),
        AppRoutes.MANAGER_HOME: (context) => ManagerHomePage(),
        AppRoutes.NEW_EMPLOYEE: (context) => NewEmployee(),
        AppRoutes.NEW_TASK: (context) => NewTask(),
        AppRoutes.NEW_DEPARTMENT: (context) => NewTask(),
        AppRoutes.TASK_RECORDS: (context) => TaskRecords(),
        AppRoutes.LOGOUT: (context) => LoginPage(),
        AppRoutes.ADMIN_HOME: (context) => AdminHomePage(),
      },
    );
  }
}
