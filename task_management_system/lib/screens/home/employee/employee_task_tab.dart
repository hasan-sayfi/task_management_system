import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:toast/toast.dart';

import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;
import 'package:task_management_system/widgets/build_task_card.dart';

class EmployeeTaskTab extends StatefulWidget {
  final List<Task> allTasks;
  final List<Task> finishedTasks;

  const EmployeeTaskTab({
    required this.allTasks,
    required this.finishedTasks,
  });

  @override
  State<EmployeeTaskTab> createState() => _EmployeeTaskTabState();
}

class _EmployeeTaskTabState extends State<EmployeeTaskTab> {
  DatabaseConnect conn = DatabaseConnect();
  var _formKey = GlobalKey<FormState>();
  List<Task> allTasks = [];
  List<Task> finishedTasks = [];
  List<Task> filteredTasks = [];
  late Employee managerAccount;
  late Employee employeeAccount;
  Task? editedTask;
  late DateTime startDate;
  late DateTime endDate;

  int _empController = -1;
  int _progressController = 0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  String date = "";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);

  bool _isLoading = true;
  int count = 0;
  static const double SIZE_BETWEEN_TEXT_FIELDS = 12;
  bool _isTaskFiltered = false;

  // This function is used to fetch all data from the database
  void _refreshTasks() async {
    filteredTasks = await conn.getTaskList(globals.loggedEmployee!.deptID);
    filteredTasks = filteredTasks
        .where((task) => task.empID == widget.allTasks.first.empID)
        .toList();
    var allEmployees =
        await conn.getEmployeeList(globals.loggedEmployee!.deptID);
    log('allEmployees: $allEmployees');
    managerAccount = allEmployees.firstWhere((emp) => emp.roleID == 2);
    employeeAccount = allEmployees
        .firstWhere((emp) => emp.empID == widget.allTasks.first.empID);
    setState(() {
      // filteredTasks = widget.allTasks;
      this.allTasks = filteredTasks;
      this.finishedTasks =
          filteredTasks.where((task) => task.taskStatus == true).toList();

      _isLoading = false;
    });
  }

  Future<void> _validateForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate())
      await _addTasks();
    else
      print('Validation is false');
  }

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    filteredTasks = widget.allTasks;
    _isTaskFiltered = false;
    _refreshTasks(); // Loading the tasks when the app starts
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBgColor,
      body: Container(
        child: allTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'No Tasks added yet!',
                      style: TextStyle(fontSize: 24, color: kOrange),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 200,
                        child: Image.asset(
                          'assets/background/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              )
            : Container(
                height: 800,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RollingSwitch.icon(
                      onChanged: (bool state) {
                        setState(() {
                          _isTaskFiltered = state;
                          state
                              ? filteredTasks = finishedTasks
                              : filteredTasks = allTasks;
                        });
                        print(
                            'turned ${(state) ? 'Completed Tasks filter' : 'All Tasks filter'}');
                      },
                      width: 220,
                      rollingInfoLeft: const RollingIconInfo(
                        icon: Icons.flag,
                        backgroundColor: Colors.grey,
                        text: Text(
                          '   All Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      rollingInfoRight: const RollingIconInfo(
                        icon: Icons.check,
                        backgroundColor: kDefaultColor,
                        text: Text(
                          'Completed Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    filteredTasks.isEmpty
                        ? Center(
                            heightFactor: 1.2,
                            child: Container(
                              height: 400,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _isTaskFiltered
                                        ? 'No completed Tasks !'
                                        : 'No added Tasks yet!',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: kOrange),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      height: 200,
                                      child: Image.asset(
                                        'assets/background/waiting.png',
                                        fit: BoxFit.cover,
                                      )),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 680,
                            child: GridView.builder(
                              itemCount: filteredTasks.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                // crossAxisSpacing: 10,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1.8,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    SizedBox(height: 20),
                                    BuildTaskCard(
                                      context: context,
                                      task: filteredTasks[index],
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 20,
                                      child: PopupMenuButton(
                                        child: Center(
                                          child: Icon(Icons.edit),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: Text("Edit"),
                                            value: 1,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Submit Task"),
                                            value: 2,
                                          ),
                                        ],
                                        onSelected: (value) => value == 1
                                            ? {
                                                _showForm(filteredTasks[index]
                                                    .taskID),
                                              }
                                            : {
                                                _submitTask(
                                                    filteredTasks[index]),
                                              },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  void _submitTask(Task currentTask) async {
    if (currentTask.taskStatus) {
      globals.showToast('Task already submitted!');
      return;
    }
    String subject = 'Task ${currentTask.taskName} has been submitted!';
    List<String> recipients = [managerAccount.empEmail];
    String body = '''
(${employeeAccount.empName}) has submitted the following task:
    Task Name: ${currentTask.taskName}
    Task Desc: ${currentTask.taskDesc}
    ''';

    Task task = Task(
      taskID: currentTask.taskID,
      empID: currentTask.empID,
      taskName: currentTask.taskName,
      taskDesc: currentTask.taskDesc,
      taskComment: currentTask.taskComment,
      taskStartDate: currentTask.taskStartDate,
      taskEndDate: currentTask.taskEndDate,
      taskProgress: 100,
      taskStatus: true,
    );
    print('_submitTask: $task');
    await conn.updateTask(task);
    globals.sendEmail(subject, recipients, body);
    globals.showToast('Task Successfully submitted!');

    _refreshTasks();
  }

  // Insert a new Employee to the database
  Future<void> _addTasks() async {
    // final String subject = 'Task Created for ${_titleController.text}';
    // final List<String> recipients = [_emailController.text];
    // final String toastMessage = 'Employee Successfully Added!';
    // final String password = createCryptoRandomString();
    // _passwordController.text = password;

    // final String body = '''
    // Your account details below:
    // Username: ${_emailController.text}
    // Password: ${_passwordController.text}

    // You can change your password once you login.
    // ''';
    Task task = Task(
      empID: _empController,
      taskName: _titleController.text,
      taskDesc: _descController.text,
      taskComment: _commentController.text,
      taskStartDate: startDate,
      taskEndDate: endDate,
      taskProgress: 0,
      taskStatus: false,
    );

    await conn.insertTask(task);
    print('Task inserted: ' + task.toString());
    _empController = -1;
    _titleController.text = '';
    _descController.text = '';
    _commentController.text = '';
    _startDateController.text = '';
    _endTimeController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    // globals.sendEmail(subject, recipients, body);
    // globals.showToast(toastMessage);
    // showToast('Employee Successfully Added!');

    _refreshTasks();
  }

  // Update an existing Task
  Future<void> _updateTask(int taskID) async {
    Task task = Task(
      taskID: taskID,
      empID: filteredTasks.first.empID,
      taskName: _titleController.text,
      taskDesc: _descController.text,
      taskComment: _commentController.text,
      taskStartDate:
          DateFormat('dd MMM yyyy hh:mm a').parse(_startDateController.text),
      taskEndDate:
          DateFormat('dd MMM yyyy hh:mm a').parse(_endDateController.text),
      taskProgress: _progressController,
      taskStatus: _progressController == 100 ? true : false,
    );
    print('Task: $task');
    await conn.updateTask(task);

    _titleController.text = '';
    _descController.text = '';
    _commentController.text = '';
    _startDateController.text = '';
    _endTimeController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    globals.showToast('Task Successfully updated!');

    _refreshTasks();
  }

  // Delete an existing Task
  Future<void> _deleteTask(int taskID) async {
    await conn.deleteTask(taskID);
    _empController = -1;
    _titleController.text = '';
    _descController.text = '';
    _commentController.text = '';
    _startDateController.text = '';
    _endTimeController.text = '';

    // Close the bottom sheet
    // Navigator.pop(context);
    globals.showToast('Task Successfully delete!');

    _refreshTasks();
  }

  Widget _showAlertDialog(int taskID) {
    return AlertDialog(
      title: Text('Delete this Task?'),
      content: Text(
          'Are you sure you want to delete this task? You will not be able to retrieve it late!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _deleteTask(taskID);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  void _showForm(int? taskID) async {
    List<Employee> _employees = [];
    List<String> _employeesValue = [];
    List<int> _employeesID = [];
    String _employeeName = '';

    _employees = await conn.getEmployeeList(globals.loggedEmployee!.deptID);
    // print('globals.loggedEmployee!.deptID ${globals.loggedEmployee!.deptID}');
    // print('_employees:wtf ${_employees} ');
    // log('globals.loggedEmployee!.deptID: ${globals.loggedEmployee!.deptID}');
    // log('_employees: ${_employees} ');
    _employees.forEach((emp) {
      _employeesID.add(emp.empID!);
      _employeesValue.add(emp.empName);
    });

    if (taskID != null) {
      // id == null -> create new item
      // id != null -> update an existing task
      DateTime startDT;
      DateTime endDT;
      final existingTask =
          filteredTasks.firstWhere((task) => task.taskID == taskID);
      _empController = existingTask.empID;
      _titleController.text = existingTask.taskName;
      _descController.text = existingTask.taskDesc;
      _commentController.text = existingTask.taskComment.toString();
      // _startDateController.text = existingTask.taskStartDate;
      // _endDateController.text = existingTask.taskEndDate;
      startDT = DateTime.parse(existingTask.taskStartDate.toString());
      endDT = DateTime.parse(existingTask.taskEndDate.toString());
      _progressController = existingTask.taskProgress;
      _startDateController.text =
          DateFormat('dd MMM yyyy hh:mm a').format(startDT);
      _endDateController.text = DateFormat('dd MMM yyyy hh:mm a').format(endDT);
    } else {
      _empController = -1;
      _titleController.text = '';
      _descController.text = '';
      _commentController.text = '';
      _startDateController.text = '';
      _endDateController.text = '';
      _progressController = 0;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            padding: EdgeInsets.all(20),
            // height: 850,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      TextFormField(
                        enabled: false,
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
                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      TextFormField(
                        enabled: false,
                        cursorColor: kDefaultColor,
                        maxLength: 150,
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _selectStartDate(context);
                        },
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
                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      TextFormField(
                        enabled: false,
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
                          helperText: '1/1/1900 12:00 PM',
                          enabledBorder: OutlineInputBorder(),
                          border: OutlineInputBorder(),
                          focusColor: kGreenDark,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kOrangeDark),
                          ),
                        ),
                      ),
                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      TextFormField(
                        enabled: false,
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
                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      TextFormField(
                        cursorColor: kDefaultColor,
                        maxLength: 100,
                        maxLines: 2,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (_) async {
                          // Validate form then create
                          if (taskID == null) {
                            _validateForm();
                          }
                          if (taskID != null) {
                            await _updateTask(taskID);
                          }
                        },
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
                      // SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                      taskID == null
                          ? SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Task Progress: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  child: SfSlider(
                                    value: _progressController.toDouble(),
                                    min: 0,
                                    max: 100,
                                    interval: 20,
                                    showTicks: true,
                                    showLabels: true,
                                    enableTooltip: true,
                                    minorTicksPerInterval: 2,
                                    stepSize: 5,
                                    onChanged: (newRating) {
                                      setState(() {
                                        _progressController = newRating.toInt();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                      SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Card(
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () async {
                            // Validate form then create
                            if (taskID == null) {
                              _validateForm();
                            }
                            if (taskID != null) {
                              await _updateTask(taskID);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              taskID == null
                                  ? "Create New Task"
                                  : 'Update Task',
                              style: TextStyle(
                                color: kOrangeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        _selectStartTime(context);
      });
    else
      _selectStartTime(context);
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

        // print("_startDateController.text: " + _startDateController.text);
        // print("startDate: " + startDate.toString());
        // print("Date: $date");
      });
    else {
      setState(() {
        startDate = DateTime(
          selectedStartDate.year,
          selectedStartDate.month,
          selectedStartDate.day,
          picked!.hour,
          picked.minute,
        );
        _startDateController.text =
            DateFormat('dd MMM yyyy hh:mm a').format(startDate).toString();

        // print("_startDateController.text: " + _startDateController.text);
        // print("startDate: " + startDate.toString());
        // print("Date: $date");
      });
    }
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
        _selectEndTime(context);
      });
    else
      _selectEndTime(context);
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime)
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

        // print("_endTimeController.text: " + _endTimeController.text);
        // print("endDate'): " + endDate.toString());
      });
    else {
      endDate = DateTime(
        selectedEndDate.year,
        selectedEndDate.month,
        selectedEndDate.day,
        selectedEndTime.hour,
        selectedEndTime.minute,
      );
      _endDateController.text =
          DateFormat('dd MMM yyyy hh:mm a').format(endDate).toString();
    }
  }
}
