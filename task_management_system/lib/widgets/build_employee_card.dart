import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/script/table_fields.dart';

class BuildEmployeeCard extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> employee;
  static const double SPACE_BETWEEN_CONTENT = 4;
  static const double FONT_SIZE = 15;

  DatabaseConnect conn = DatabaseConnect();

  BuildEmployeeCard({
    required this.context,
    required this.employee,
  });

  Future<String> _deptName(int deptID) async {
    final data = await conn.getDepartmentMapList(deptID);
    print('_deptName: ' + data[0][0]);

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 50,
      // padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    (employee[TableFields.empAvatar] == null)
                        ? "assets/avatars/img2.png"
                        : employee[TableFields
                            .empAvatar]!, // TODO: Replace with avatar image
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Text(
                            employee[TableFields.empName],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                color: Colors.grey[700]),
                          ),
                          Text(
                            ' (${employee[TableFields.roleID] == 1 ? "Adminitrator" : employee[TableFields.roleID] == 2 ? "Manager" : "Employee"})',
                            // ' (${employee[TableFields.roleID]})',
                            style: TextStyle(
                                fontSize: FONT_SIZE,
                                // fontWeight: FontWeight.bold,
                                // letterSpacing: 1,
                                color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        // '(${employee[TableFields.deptID]})',
                        _deptName(employee[TableFields.deptID]).toString(),
                        style: TextStyle(
                            fontSize: FONT_SIZE, color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee[TableFields.empEmail],
                        style: TextStyle(
                            fontSize: FONT_SIZE,
                            // fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee[TableFields.empMobile],
                        style: TextStyle(
                            fontSize: FONT_SIZE,
                            // fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee[TableFields.empAddress],
                        style: TextStyle(
                            fontSize: FONT_SIZE,
                            // fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    color: kYellow,
                    // elevation: 8,
                    child: Container(
                      // color: Colors.transparent,
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Finished Tasks: 6",
                        style: TextStyle(
                            color: kYellowDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Card(
                    color: Colors.grey[200],
                    // elevation: 8,
                    child: Container(
                      // color: Colors.transparent,
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Remaining Tasks: 6",
                        style: TextStyle(
                            color: kYellowDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
