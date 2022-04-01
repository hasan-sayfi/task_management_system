import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/task.dart';

class BuildTaskCard extends StatelessWidget {
  final BuildContext context;
  final Task task;
  static const double SPACE_BETWEEN_CONTENT = 4;
  static const double FONT_SIZE = 16;
  static const double FONT_SIZE_DATE = 16;
  static const double FONT_SIZE_TITLE = 22;
  static const double FONT_SIZE_DESC = 18;

  const BuildTaskCard({
    required this.context,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: task.taskStatus ? kGreenLight : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        task.taskName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                            color: Colors.grey[700]),
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                      Text(
                        task.taskDesc,
                        style: TextStyle(
                            fontSize: FONT_SIZE, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: SPACE_BETWEEN_CONTENT),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Card(
                    color: Colors.grey[200],
                    child: Container(
                      width: 150,
                      height: 60,
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          _modalBottomSheet(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "More Details",
                              style: TextStyle(
                                  color: kOrangeDark,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.expand_more),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  Future<void> _modalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.grey[300],
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: EdgeInsets.all(20),
          // color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.taskName,
                style: TextStyle(
                    fontSize: FONT_SIZE_TITLE,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                    color: Colors.grey[700]),
              ),
              ExpandableText(
                task.taskDesc,
                expandText: 'show more',
                collapseText: 'show less',
                animation: true,
                animationDuration: Duration(seconds: 1),
                maxLines: 2,
                linkColor: Colors.blue,
                style: TextStyle(
                    fontSize: FONT_SIZE_DESC, color: Colors.grey[700]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 8,
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Start Date: ',
                            style: TextStyle(
                              fontSize: FONT_SIZE,
                              color: Colors.grey[700],
                            ),
                          ),
                          // SizedBox(width: 5),
                          Column(
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(task.taskStartDate),
                                style: TextStyle(
                                  fontSize: FONT_SIZE_DATE,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a').format(task.taskEndDate),
                                style: TextStyle(
                                  fontSize: FONT_SIZE_DATE,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Text(
                            'End Date: ',
                            style: TextStyle(
                              fontSize: FONT_SIZE_DATE,
                              color: Colors.grey[700],
                            ),
                          ),
                          // SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(task.taskEndDate),
                                style: TextStyle(
                                  fontSize: FONT_SIZE_DATE,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a').format(task.taskEndDate),
                                style: TextStyle(
                                  fontSize: FONT_SIZE_DATE,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Card(
                      color: Colors.grey[200],
                      child: Container(
                        // color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 38, vertical: 15),
                        child: Text(
                          "Status: ${task.taskStatus ? 'Complete' : 'Pending'}",
                          style: TextStyle(
                              color: kOrangeDark, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Card(
                      color: Colors.grey[200],
                      child: Container(
                        // color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Text(
                          "Progress: %${task.taskProgress}",
                          style: TextStyle(
                              color: kOrangeDark, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  // void _showModalBottomSheet(BuildContext context){

  // }
}
