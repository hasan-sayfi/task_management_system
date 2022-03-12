import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/dashboard_cards.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/widgets/build_dashboard_card.dart';

class HomeManager extends StatefulWidget {
  const HomeManager({Key? key}) : super(key: key);

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  // Get the dump data for dashboard
  final _dahsboardCardsList = DashboardCards.generateDashboardCards();
  static const double PROFILE_CONTAINER = 140;
  final _employeeData = Employee.generateEmployees();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: PROFILE_CONTAINER / 3),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            // fit: StackFit.passthrough,
            children: [
              Container(
                height: PROFILE_CONTAINER,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: PROFILE_CONTAINER / 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hello, ",
                            style: TextStyle(
                              fontSize: 30,
                              color: kFontBodyColor,
                            )),
                        Text("John!", // TODO: Replace First Name
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Manager, ", // TODO: Replace Role Name
                            style: TextStyle(color: kFontBodyColor)),
                        Text("IT Department", // TODO: Replace Department
                            style: TextStyle(color: kFontBodyColor)),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                // left: 50,
                top: -50,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(
                    _employeeData[1]
                        .empAvatar!, // TODO: Replace with avatar image
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: PROFILE_CONTAINER / 5),
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(bottom: 100, top: 100),
              child: GridView.builder(
                itemCount: _dahsboardCardsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return BuildDashboardCard(
                      context: context,
                      dashboardCard: _dahsboardCardsList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
