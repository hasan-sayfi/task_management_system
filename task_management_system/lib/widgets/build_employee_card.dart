import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/script/table_fields.dart';

class BuildEmployeeCard extends StatefulWidget {
  final BuildContext context;
  final Map<String, dynamic> employee;
  static const double SPACE_BETWEEN_CONTENT = 4;
  static const double FONT_SIZE = 15;

  BuildEmployeeCard({
    required this.context,
    required this.employee,
  });

  @override
  State<BuildEmployeeCard> createState() => _BuildEmployeeCardState();
}

class _BuildEmployeeCardState extends State<BuildEmployeeCard> {
  DatabaseConnect conn = DatabaseConnect();
  String _deptName = '';

  Future<void> getDepartmentName() async {
    final int deptID = widget.employee[TableFields.deptID];
    final data = await conn.getDepartmentNameMap(deptID);

    _deptName = data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDepartmentName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Text(ConnectionState.done.toString());
        } else {
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
                        radius: 30,
                        backgroundImage: AssetImage(
                          (widget.employee[TableFields.empAvatar] == null)
                              ? "assets/avatars/img2.png"
                              : widget.employee[TableFields
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
                                  widget.employee[TableFields.empName],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      color: Colors.grey[700]),
                                ),
                                Text(
                                  ' (${widget.employee[TableFields.roleID] == 1 ? "Adminitrator" : widget.employee[TableFields.roleID] == 2 ? "Manager" : "Employee"})',
                                  // ' (${employee[TableFields.roleID]})',
                                  style: TextStyle(
                                      fontSize: BuildEmployeeCard.FONT_SIZE,
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: 1,
                                      color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              _deptName, // Department Name
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee[TableFields.empEmail],
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  // fontWeight: FontWeight.bold,
                                  // letterSpacing: 1,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee[TableFields.empMobile],
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
                                  // fontWeight: FontWeight.bold,
                                  // letterSpacing: 1,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(
                                height:
                                    BuildEmployeeCard.SPACE_BETWEEN_CONTENT),
                            Text(
                              widget.employee[TableFields.empAddress],
                              style: TextStyle(
                                  fontSize: BuildEmployeeCard.FONT_SIZE,
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
                                  color: kYellowDark,
                                  fontWeight: FontWeight.bold),
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
                                  color: kYellowDark,
                                  fontWeight: FontWeight.bold),
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
      },
    );
  }
}
