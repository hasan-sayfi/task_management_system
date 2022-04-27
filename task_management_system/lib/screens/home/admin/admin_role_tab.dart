import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/role.dart';
import 'package:task_management_system/script/table_fields.dart';

class AdminRoleTab extends StatefulWidget {
  @override
  State<AdminRoleTab> createState() => _AdminRoleTabState();
}

class _AdminRoleTabState extends State<AdminRoleTab> {
  DatabaseConnect conn = DatabaseConnect();
  var _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _roles = [];
  bool _isLoading = true;
  int count = 0;

  // This function is used to fetch all data from the database
  void _refreshRoles() async {
    final data = await conn.getRoleMapList();
    setState(() {
      _roles = data;
      _isLoading = false;
    });
  }

  void _showForm(int? roleID) async {
    if (roleID != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingRole =
          _roles.firstWhere((element) => element[TableFields.roleID] == roleID);
      _nameController.text = existingRole[TableFields.roleName];
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
                    labelText: 'Role Name',
                    helperText: 'E.g: Manager',
                    hintText: 'E.g: Manager',
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
                          if (roleID == null) {
                            await _addRole();
                          }
                          if (roleID != null) {
                            await _updateRole(roleID);
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
                            roleID == null ? "Create New Role" : 'Update Role',
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

  // Insert a new role to the database
  Future<void> _addRole() async {
    Role role = Role(roleName: _nameController.text);

    await conn.insertRole(role);
    _refreshRoles();
  }

  // Update an existing role
  Future<void> _updateRole(int roleID) async {
    Role role = Role(roleID: roleID, roleName: _nameController.text);

    await conn.updateRole(role);
    _refreshRoles();
  }

  // Delete a role
  void _deleteRole(int roleID) async {
    Role role = Role(roleID: roleID, roleName: _nameController.text);
    await conn.deleteRole(role);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted ${role.roleName} role!'),
    ));
    _refreshRoles();
  }

  // Delete all roles
  void _deleteAllRoles() async {
    await conn.deleteAllRoles();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted all roles!'),
    ));
    _refreshRoles();
  }

  @override
  void initState() {
    super.initState();
    _refreshRoles(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          return _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'No Roles added yet!',
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
                    leading: Text(_roles[index][TableFields.roleID].toString()),
                    title: Text(_roles[index][TableFields.roleName]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () =>
                                _showForm(_roles[index][TableFields.roleID]),
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
      title: Text('Delete this role?'),
      content: Text('Are you sure you want to delete this role?'),
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
            _deleteRole(_roles[index][TableFields.roleID]);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            _deleteAllRoles();
            Navigator.pop(context);
          },
          child: Text('Delete All Roles'),
        ),
      ],
    );
  }

  void _save() async {
    FocusScope.of(context).unfocus();
    Role role = Role(roleName: _nameController.text);
    int result;

    if (!_formKey.currentState!.validate())
      return;
    else {
      if (role.roleID != null) {
        result = 0;
        print("Need update method for ROLE!");
        print("role.roleID: ${role.roleID}");
      } else {
        //Insert Operation
        result = await conn.insertRole(role);
        // role.roleID = roles.length + 1;
        // print("role.roleID: ${role.roleID}");
        // result = 1;
        // roles.add(role);
        print("Need INSERT method for ROLE!");
      }
    }
    Navigator.pop(context);

    if (result != 0) {
      AlertDialog(
        title: Text('Status'),
        content: Text('Role has been successfully added!'),
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
        content: Text('Problem adding role!'),
        actions: [
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('OK'))),
        ],
      );
    }
  } //_save()

  // Refresh inficator
  Future<void> _refresh() async {
    return await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // _allEmployees = Employee.getEmployeesInDepartment(2);
        _AdminRoleTabState();
      });
    });
  }
}
