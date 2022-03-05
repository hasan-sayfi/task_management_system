import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/dashboard_cards.dart';

class HomeManager extends StatefulWidget {
  const HomeManager({Key? key}) : super(key: key);

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  // Get the dump data for dashboard
  final _dahsboardCardsList = DashboardCards.generateDashboardCards();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Hello, ",
                  style: TextStyle(
                    fontSize: 20,
                    color: kFontBodyColor,
                  )),
              Text("John!", // TODO: Replace First Name
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text("Manager, ", // TODO: Replace Role Name
                  style: TextStyle(color: kFontBodyColor)),
              Text("IT Department", // TODO: Replace Department
                  style: TextStyle(color: kFontBodyColor)),
            ],
          ),
          SizedBox(height: 20),
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
                  return _buildDashboardCard(
                      context, _dahsboardCardsList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, DashboardCards dashboardCard) {
    return Container(
      height: 100,
      width: 50,
      // padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: dashboardCard.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              dashboardCard.iconData,
              size: 40,
              color: dashboardCard.iconColor,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                dashboardCard.title!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Card(
                color: dashboardCard.btnColor,
                // elevation: 8,
                child: Container(
                  // color: Colors.transparent,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Total: ${dashboardCard.total}",
                    style: TextStyle(
                        color: dashboardCard.iconColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
