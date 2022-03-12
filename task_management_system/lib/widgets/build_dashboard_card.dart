import 'package:flutter/material.dart';

import 'package:task_management_system/models/dashboard_cards.dart';

class BuildDashboardCard extends StatelessWidget {
  final BuildContext context;
  final DashboardCards dashboardCard;

  const BuildDashboardCard({
    Key? key,
    required this.context,
    required this.dashboardCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
