import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/screens/home/manager/manager_task_tab.dart';
import 'package:task_management_system/widgets/build_task_card.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;

class ManagerTaskTabList extends StatefulWidget {
  final List<Task> allTasks;

  ManagerTaskTabList(this.allTasks);

  @override
  State<ManagerTaskTabList> createState() => _ManagerTaskTabListState();
}

class _ManagerTaskTabListState extends State<ManagerTaskTabList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widget.allTasks.isEmpty
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
                height: 450,
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: widget.allTasks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    // crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        BuildTaskCard(
                          context: context,
                          task: widget.allTasks[index],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            // onPressed: _showForm(widget.allTasks[index].taskID),
                            onPressed: () {
                              setState(() {
                                // globals.editedTask = widget.allTasks[index];
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  /* void _showForm(int? taskID) async {
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
      final existingTask =
          _tasks.firstWhere((task) => task[TableFields.taskID] == taskID);
      _empController = existingTask[TableFields.empID];
      _titleController.text = existingTask[TableFields.taskName];
      _descController.text = existingTask[TableFields.taskDesc];
      _commentController.text = existingTask[TableFields.taskComment];
      _startDateController.text = existingTask[TableFields.taskStartDate];
      _endDateController.text = existingTask[TableFields.taskEndDate];
    } else {
      _empController = -1;
      _titleController.text = '';
      _descController.text = '';
      _commentController.text = '';
      _startDateController.text = '';
      _endDateController.text = '';
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
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
                        DropdownButtonFormField(
                          value: _empController == -1
                              ? null
                              // : _employeesValue[_empController - 1],
                              : _employeesValue[
                                  _employeesID.indexOf(_empController)],
                          items: _employeesValue
                              .map((String item) => DropdownMenuItem<String>(
                                  child: Text(item), value: item))
                              .toList(),
                          onChanged: (String? value) {
                            this.setState(() {
                              _empController = _employeesID[
                                  _employeesValue.indexOf(value.toString())];
                              print('value: $value');
                              print(
                                  '_employeesID.indexOf(_empController): ${_employeesID.indexOf(_empController)}');
                              print(
                                  '_employeesValue[_employeesID.indexOf(_empController)] ${_employeesValue[_employeesID.indexOf(_empController)]}');
                              print('_empController After: ' +
                                  _empController.toString());
                            });
                          },
                          validator: (value) {
                            if (value.toString().isEmpty ||
                                value == -1 ||
                                value == null)
                              return 'Please select an employee';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.groups,
                            ),
                            labelText: 'Please select an employee',
                            helperText: 'John Doe',
                            hintText: 'Please select a employee',
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
                          cursorColor: kDefaultColor,
                          maxLength: 100,
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
                        SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
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
                        SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
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
                              // Save new journal
                              if (taskID == null) {
                                _validateForm();
                              }
                              if (taskID != null) {
                                await _updateTask(taskID);
                              }
                              // Clear the text fields
                              // _nameController.text = '';
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
          ),
        );
      },
    );
  } */
}
