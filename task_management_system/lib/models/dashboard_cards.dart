import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';

class DashboardCards {
  IconData iconData;
  String title;
  int total;
  Color bgColor;
  Color btnColor;
  Color iconColor;

  DashboardCards({
    required this.iconData,
    required this.title,
    required this.total,
    required this.bgColor,
    required this.btnColor,
    required this.iconColor,
  });

  static List<DashboardCards> generateDashboardCards() {
    return [
      DashboardCards(
        iconData: Icons.group_sharp,
        title: "Employees",
        bgColor: kYellowLight,
        btnColor: kYellow,
        total: 6,
        iconColor: kYellowDark,
      ),
      DashboardCards(
        iconData: Icons.work,
        title: "Tasks",
        bgColor: kBlueLight,
        btnColor: kBlue,
        total: 18,
        iconColor: kBlueDark,
      ),
      DashboardCards(
        iconData: Icons.add_task,
        title: "Finished Tasks",
        bgColor: kGreenLight,
        btnColor: kGreen,
        total: 13,
        iconColor: kGreenDark,
      ),
      DashboardCards(
        iconData: Icons.watch_later,
        title: "Remaining Tasks",
        bgColor: kRedLight,
        btnColor: kRed,
        total: 5,
        iconColor: kRedDark,
      ),
    ];
  }
}
