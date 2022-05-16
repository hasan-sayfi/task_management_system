import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/script/table_fields.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;
import 'package:task_management_system/widgets/build_employee_card.dart';
import 'package:toast/toast.dart';

class ManagerEmployeeTab extends StatefulWidget {
  @override
  State<ManagerEmployeeTab> createState() => _ManagerEmployeeTabState();
}

class _ManagerEmployeeTabState extends State<ManagerEmployeeTab> {
  DatabaseConnect conn = DatabaseConnect();
  var _formKey = GlobalKey<FormState>();
  int _roleController = 3;
  int _deptController = globals.loggedEmployee!.deptID;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var _concealPass;
  List<Employee> _employees = [];
  bool _isLoading = true;
  int count = 0;
  static const double SIZE_BETWEEN_TEXT_FIELDS = 15;
  var size, height, width;

  @override
  void initState() {
    super.initState();
    _concealPass = true;
    ToastContext().init(context);
    _refreshEmployees(); // Loading the employees when the app starts
  }

  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 8]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  Widget _showAlertDialog(int empID) {
    return AlertDialog(
      title: Text('Delete this Employee?'),
      content: Text('All tasks related to this employee will be deleted too?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _deleteEmployee(empID);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  _sendEmail(String empEmail) async {
    String email = 'task.management.smtp@gmail.com';
    String password = r'Lt@mjVf&$6GM';
    String emailName = 'Task Management';
    final smtpServer = gmail(email, password);

    final message = Message()
      ..from = Address(empEmail, emailName)
      ..recipients = [empEmail]
      ..subject = 'Test Subject'
      ..text = 'Something to rememebr by!';
    try {
      await send(message, smtpServer);
      print('Email sent to ($empEmail)');
    } catch (e) {
      print('Send mail Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
// getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: 780,
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'No Employees added yet!',
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
            : _employees.isNotEmpty
                ? GridView.builder(
                    itemCount: _employees.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      // crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      childAspectRatio: height * 0.0024,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          BuildEmployeeCard(
                            context: context,
                            employee: _employees[index],
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
                                        child: Text("Delete"),
                                        value: 2,
                                      ),
                                      PopupMenuItem(
                                        child: Text("Send Email"),
                                        value: 3,
                                      ),
                                    ],
                                onSelected: (value) {
                                  switch (value) {
                                    case 1:
                                      _showForm(_employees[index].empID);
                                      print('_showForm called!');
                                      break;
                                    case 2:
                                      showDialog(
                                          context: context,
                                          builder: (_) => _showAlertDialog(
                                              _employees[index].empID!));
                                      print('_showAlertDialog called!');
                                      break;
                                    case 3:
                                      _sendEmail(_employees[index].empEmail);
                                      print('Send Email called!');
                                      break;
                                    default:
                                      print('Default Case');
                                  }
                                }),
                          ),
                        ],
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'No Employees added yet!',
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
                  ),
      ),
    );
  }

  // This function is used to fetch all data from the database
  void _refreshEmployees() async {
    final empMapList =
        await conn.getEmployeeList(globals.loggedEmployee!.deptID);
    // print('empMapList: $empMapList');
    setState(() {
      _employees = empMapList.where((emp) => emp.roleID == 3).toList();
      _isLoading = false;
    });
  }

  Future<void> _validateForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate())
      await _addEmployee();
    else
      print('Validation is false');
  }

  // Insert a new Employee to the database
  Future<void> _addEmployee() async {
    final String subject = 'Account Created for ${_emailController.text}';
    final List<String> recipients = [_emailController.text];
    final String toastMessage = 'Employee Successfully Added!';
    final String password = createCryptoRandomString();
    _passwordController.text = password;

    final String body = '''
    Your account details below:
    Username: ${_emailController.text}
    Password: ${_passwordController.text}

    You can change your password once you login.
    ''';

    Employee employee = Employee(
      roleID: 3,
      deptID: globals.loggedEmployee!.deptID,
      empName: _nameController.text,
      empEmail: _emailController.text,
      empMobile: _mobileController.text,
      empAddress: _addressController.text,
      empPassword: _passwordController.text,
    );
    await conn.insertEmployee(employee);
    print('Employee inserted: ' + employee.toString());

    _roleController = 3;
    _deptController = globals.loggedEmployee!.deptID;
    _nameController.text = '';
    _emailController.text = '';
    _mobileController.text = '';
    _addressController.text = '';
    _passwordController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    globals.sendEmail(subject, recipients, body);
    globals.showToast(toastMessage);
    // showToast('Employee Successfully Added!');

    _refreshEmployees();
  }

  // Update an existing Employee
  Future<void> _updateEmployee(int empID) async {
    Employee employee = Employee(
      empID: empID,
      roleID: _roleController,
      deptID: _deptController,
      empName: _nameController.text,
      empEmail: _emailController.text,
      empMobile: _mobileController.text,
      empAddress: _addressController.text,
      empPassword: _passwordController.text,
    );
    print('(conn.updateEmployee): ' + employee.toString());

    await conn.updateEmployee(employee);
    _roleController = 3;
    _deptController = globals.loggedEmployee!.deptID;
    _nameController.text = '';
    _emailController.text = '';
    _mobileController.text = '';
    _addressController.text = '';
    _passwordController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    globals.showToast('Employee Successfully updated!');

    _refreshEmployees();
  }

  // Delete an existing Employee
  void _deleteEmployee(int empID) async {
    await conn.deleteEmployee(empID);
    _roleController = 3;
    _deptController = globals.loggedEmployee!.deptID;
    _nameController.text = '';
    _emailController.text = '';
    _mobileController.text = '';
    _addressController.text = '';
    _passwordController.text = '';

    // Close the bottom sheet
    // Navigator.pop(context);
    globals.showToast('Employee Successfully delete!');

    _refreshEmployees();
  }

  void _showForm(int? empID) async {
    List<Map<String, dynamic>> _departments = [];
    List<String> _departmentsValue = [];
    List<int> _departmentsID = [];
    String _departmentName = 'Administrator';
    String _roleName = 'Manager';

    _departments = await conn.getDepartmentMapList(null);
    // _departmentsValue.add('Please select a deparment');
    // _departmentsID.add(-1);

    for (var dept in _departments) {
      _departmentsValue.add(dept['deptName'].toString());
      _departmentsID.add(dept['deptID']);
    }

    if (empID != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingEmployee =
          _employees.firstWhere((emp) => emp.empID == empID);
      _roleController = existingEmployee.roleID;
      _deptController = existingEmployee.deptID;
      _nameController.text = existingEmployee.empName;
      _emailController.text = existingEmployee.empEmail;
      _mobileController.text = existingEmployee.empMobile;
      _addressController.text = existingEmployee.empAddress;
      _passwordController.text = existingEmployee.empPassword;
    } else {
      _roleController = -1;
      _deptController = -1;
      _nameController.text = '';
      _emailController.text = '';
      _mobileController.text = '';
      _addressController.text = '';
      _passwordController.text = '';
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
            // height: 700,
            child: SingleChildScrollView(
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
                          cursorColor: Colors.amber[800],
                          maxLength: 25,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length < 6 ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                              return 'Please enter correct name';
                            else
                              return null;
                          },
                          // autovalidate: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            labelText: 'Full Name',
                            helperText: 'John Doe',
                            hintText: 'John Doe',
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
                          cursorColor: Colors.amber[800],
                          maxLength: 30,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length < 8 ||
                                !RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
                                    .hasMatch(value)) {
                              return 'Please enter a valid email address!';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            labelText: 'Email',
                            helperText: 'exampl@domain.com',
                            hintText: 'exampl@domain.com',
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
                          cursorColor: Colors.amber[800],
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.length < 10 ||
                                !RegExp(r'^05\d{8}$').hasMatch(value)) {
                              return 'Please enter a valid phone number!';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_android,
                            ),
                            labelText: 'Mobile',
                            helperText: '05xxxxxxxx',
                            hintText: '05xxxxxxxx',
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
                          cursorColor: Colors.amber[800],
                          maxLength: 30,
                          maxLines: 2,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (_) async {
                            // Validate form then create
                            if (empID == null) {
                              _validateForm();
                            }
                            if (empID != null) {
                              await _updateEmployee(empID);
                            }
                          },
                          keyboardType: TextInputType.streetAddress,
                          controller: _addressController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return 'Please enter a valid address!';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on),
                            labelText: 'Address',
                            helperText: '1234 Street, Riyadh, Saudi Arabia',
                            hintText: '1234 Street, Riyadh, Saudi Arabia',
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
                        empID == null
                            ? Text('')
                            : TextFormField(
                                cursorColor: Colors.amber[800],
                                maxLength: 30,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                obscureText: _concealPass,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Please enter a valid password!';
                                  } else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _concealPass = !_concealPass;
                                      });
                                    },
                                    icon: _concealPass
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),
                                  labelText: 'Password',
                                  helperText: 'password',
                                  hintText: 'password',
                                  enabledBorder: OutlineInputBorder(),
                                  border: OutlineInputBorder(),
                                  focusColor: kGreenDark,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kOrangeDark),
                                  ),
                                  // errorText: 'Error message',
                                ),
                              ),
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
                              if (empID == null) {
                                _validateForm();
                              }
                              if (empID != null) {
                                await _updateEmployee(empID);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                empID == null
                                    ? "Create New Employee"
                                    : 'Update Employee',
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
  }
}
