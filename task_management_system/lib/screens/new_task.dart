import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/task.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final int managerId = 2;
  late DateTime startDate;
  late DateTime endDate;
  String startDateSqlite = 'yyyy-MM-dd HH:mm:ss';
  String endDateSqlite = 'yyyy-MM-dd HH:mm:ss';

  var _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  // TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  String date = "";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign New Task"),
        foregroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        elevation: 0,
        backwardsCompatibility: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ),
      backgroundColor: kBgColor,
      body: Container(
        height: 550,
        color: Colors.grey[200],
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    cursorColor: kDefaultColor,
                    maxLength: 30,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6)
                        return 'Please enter task title';
                      else
                        return null;
                    },
                    // autovalidate: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.title,
                      ),
                      labelText: 'Title',
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusColor: kGreenDark,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrangeDark),
                      ),
                      // errorText: 'Error message',
                    ),
                  ),
                  TextFormField(
                    cursorColor: kDefaultColor,
                    maxLength: 80,
                    maxLines: 4,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    controller: _descController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Please enter a valid description';
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                      labelText: 'Description',
                      helperText: 'Task Details',
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusColor: kGreenDark,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrangeDark),
                      ),
                    ),
                  ),
                  TextFormField(
                    cursorColor: kDefaultColor,
                    maxLength: 50,
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    controller: _commentController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.comment,
                      ),
                      labelText: 'Comment',
                      helperText: 'If none, leave empty',
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusColor: kGreenDark,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrangeDark),
                      ),
                    ),
                  ),
                  TextFormField(
                    cursorColor: kDefaultColor,
                    maxLength: 20,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    controller: _startDateController,
                    onTap: () {
                      _selectStartDate(context);
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 20) {
                        return 'Please enter a valid Date';
                      } else
                        return null;
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      labelText: 'Start Date',
                      helperText: '1/1/1900',
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusColor: kGreenDark,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrangeDark),
                      ),
                    ),
                  ),
                  TextFormField(
                    cursorColor: kDefaultColor,
                    maxLength: 20,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.datetime,
                    controller: _endDateController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 20) {
                        return 'Please enter a valid Date';
                      } else
                        return null;
                    },
                    readOnly: true,
                    onTap: () {
                      _selectEndDate(context);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      labelText: 'End Date',
                      helperText: '1/1/1900',
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      focusColor: kGreenDark,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrangeDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitData,
        child: Icon(Icons.save),
      ),
    );
  }

  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedStartDate)
      setState(() {
        selectedStartDate = selected;
        // _startDateController.text =
        //     '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}';
        _selectStartTime(context);
      });
    else if (selected != null && selected == selectedStartDate)
      _selectStartTime(context);
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedEndDate)
      setState(() {
        selectedEndDate = selected;
        // _endDateController.text =
        //     '${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}';
        _selectEndTime(context);
      });
    else if (selected != null && selected == selectedStartDate)
      _selectEndTime(context);
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime)
      setState(() {
        selectedStartTime = picked;
        startDate = DateTime(
          selectedStartDate.year,
          selectedStartDate.month,
          selectedStartDate.day,
          selectedStartTime.hour,
          selectedStartTime.minute,
        );
        _startDateController.text =
            DateFormat('dd MMM yyyy hh:mm a').format(startDate).toString();

        print("_endTimeController.text: " + _endTimeController.text);
        print("Date: $date");
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedStartTime)
      setState(() {
        selectedEndTime = picked;
        endDate = DateTime(
          selectedEndDate.year,
          selectedEndDate.month,
          selectedEndDate.day,
          selectedEndTime.hour,
          selectedEndTime.minute,
        );
        _endDateController.text =
            DateFormat('dd MMM yyyy hh:mm a').format(endDate).toString();

        endDateSqlite =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate).toString();

        print("_endTimeController.text: " + _endTimeController.text);
        print("DateFormat('yyyy-MM-dd HH:mm:ss'): " + endDateSqlite);
      });
  }

  void _submitData() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate())
      return;
    else {
      final taskTitle = _titleController.text;
      final taskDesc = _descController.text;
      final taskComment = _commentController.text;
      final taskStartDate = startDate;
      final taskEndDate = endDate;

      print("taskTitle: $taskTitle");
      print("taskDesc: $taskDesc");
      print("taskComment: $taskComment");
      print("taskStartDate: $taskStartDate");
      print("taskEndDate: $taskEndDate");

      Task newTask = Task(
        taskName: taskTitle,
        taskDesc: taskDesc,
        taskComment: taskComment,
        taskStartDate: taskStartDate,
        taskEndDate: taskEndDate,
        taskProgress: 0,
        taskStatus: false,
        empID: managerId,
      );

      Navigator.pop(context, newTask);
    }
  }
}
