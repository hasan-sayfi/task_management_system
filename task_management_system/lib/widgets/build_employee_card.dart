import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';

class BuildEmployeeCard extends StatelessWidget {
  final BuildContext context;
  final Employee employee;
  static const double SPACE_BETWEEN_CONTENT = 4;
  static const double FONT_SIZE = 15;

  const BuildEmployeeCard({
    required this.context,
    required this.employee,
  });

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    (employee.empAvatar == null)
                        ? "assets/avatars/img2.png"
                        : employee
                            .empAvatar!, // TODO: Replace with avatar image
                  ),
                ),
                SizedBox(width: 25),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        employee.empName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee.empEmail,
                        style: TextStyle(
                            fontSize: FONT_SIZE,
                            // fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee.empMobile,
                        style: TextStyle(
                            fontSize: FONT_SIZE,
                            // fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        employee.empAddress,
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                ),
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
