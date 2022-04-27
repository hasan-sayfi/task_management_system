import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/script/table_fields.dart';

class AdminDepartmentTab extends StatefulWidget {
  const AdminDepartmentTab({Key? key}) : super(key: key);

  @override
  State<AdminDepartmentTab> createState() => _AdminDepartmentTabState();
}

class _AdminDepartmentTabState extends State<AdminDepartmentTab> {
  DatabaseConnect conn = DatabaseConnect();
  var _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;
  int count = 0;

  // This function is used to fetch all data from the database
  void _refreshDepartment() async {
    final data = await conn.getDepartmentMapList(null);
    setState(() {
      _departments = data;
      _isLoading = false;
    });
  }

  void _showForm(int? deptID) async {
    if (deptID != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingDepartments = _departments
          .firstWhere((element) => element[TableFields.deptID] == deptID);
      _nameController.text = existingDepartments[TableFields.deptName];
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
        return Padding(
          // height: 300,
          padding: EdgeInsets.all(20),
          // color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  cursorColor: Colors.amber[800],
                  maxLength: 25,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length < 4 ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                      return 'Please enter correct name';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.settings_accessibility_sharp,
                    ),
                    labelText: 'Department Name',
                    helperText: 'E.g: Information Technology',
                    hintText: 'E.g: Information Technology',
                    enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                    focusColor: kGreenDark,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kOrangeDark),
                    ),
                  ),
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
                          if (deptID == null) {
                            await _addDepartment();
                          }
                          if (deptID != null) {
                            await _updateDepartment(deptID);
                          }
                          // Clear the text fields
                          _nameController.text = '';

                          // Close the bottom sheet
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            deptID == null
                                ? "Create New Department"
                                : 'Update Department',
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
        );
      },
    );
  }

  // Insert a new Department to the database
  Future<void> _addDepartment() async {
    Department department = Department(deptName: _nameController.text);

    await conn.insertDepartment(department);
    _refreshDepartment();
  }

  // Update an existing Department
  Future<void> _updateDepartment(int deptID) async {
    Department department =
        Department(deptID: deptID, deptName: _nameController.text);

    await conn.updateDepartment(department);
    _refreshDepartment();
  }

  // Delete a Department
  void _deleteDepartment(int deptID) async {
    Department department =
        Department(deptID: deptID, deptName: _nameController.text);
    await conn.deleteDepartment(department);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${department.deptName} department!'),
    ));
    _refreshDepartment();
  }

  // Delete all Departments
  void _deleteAllDepartments() async {
    await conn.deleteAllDepartments();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted all Departments!'),
    ));
    _refreshDepartment();
  }

  @override
  void initState() {
    super.initState();
    _refreshDepartment(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    // print("Departments.isEmpty: " + Departments.isEmpty.toString());
    // if (Departments.isEmpty) {
    //   Departments = <Department>[];
    //   updateRolesListView();
    // }
    return Scaffold(
      body: ListView.builder(
        itemCount: _departments.length,
        itemBuilder: (context, index) {
          return _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'No Departments added yet!',
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
              : Card(
                  child: ListTile(
                    leading: Text(
                        _departments[index][TableFields.deptID].toString()),
                    title: Text(_departments[index][TableFields.deptName]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => _showForm(
                                _departments[index][TableFields.deptID]),
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) => _showAlertDialog(index)),
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _showAlertDialog(index) {
    print('Inside _showAlertDialog');
    return AlertDialog(
      title: Text('Delete this Department?'),
      content: Text('Are you sure you want to delete this Department?'),
      actions: [
        // ElevatedButton(onPressed: () {}, child: Text('Cancel')),
        // ElevatedButton(onPressed: () {}, child: Text('Delete')),
        // ElevatedButton(onPressed: () {}, child: Text('Delete All Roles')),
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _deleteDepartment(_departments[index][TableFields.deptID]);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            _deleteAllDepartments();
            Navigator.pop(context);
          },
          child: Text('Delete All Departments'),
        ),
      ],
    );
  }

  void _save() async {
    FocusScope.of(context).unfocus();
    Department department = Department(deptName: _nameController.text);
    int result;

    if (!_formKey.currentState!.validate())
      return;
    else {
      if (department.deptID != null) {
        result = 0;
        print("Need update method for DEPARTMENT!");
        print("department.deptID: ${department.deptID}");
      } else {
        //Insert Operation
        result = await conn.insertDepartment(department);
        print("Need INSERT method for DEPARTMENT!");
      }
    }
    Navigator.pop(context);

    if (result != 0) {
      AlertDialog(
        title: Text('Status'),
        content: Text('Department has been successfully added!'),
        actions: [
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('OK'))),
        ],
      );
    } else {
      AlertDialog(
        title: Text('Status'),
        content: Text('Problem adding department!'),
        actions: [
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('OK'))),
        ],
      );
    }
  } //_save()
}
