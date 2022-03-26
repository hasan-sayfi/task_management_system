import 'package:flutter/material.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:task_management_system/screens/home/manager/manager_homepage.dart';
import 'package:task_management_system/screens/login/logout.dart';
import 'package:task_management_system/screens/new_employee.dart';
import 'package:task_management_system/screens/new_task.dart';
import 'package:task_management_system/screens/task_records.dart';

import 'constants/colors.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
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
        AppRoutes.HOME: (context) => HomePage(),
        AppRoutes.NEW_EMPLOYEE: (context) => NewEmployee(),
        AppRoutes.NEW_TASK: (context) => NewTask(),
        AppRoutes.NEW_DEPARTMENT: (context) => NewTask(),
        AppRoutes.TASK_RECORDS: (context) => TaskRecords(),
        AppRoutes.LOGOUT: (context) => Logout(),
      },
    );
  }
}
