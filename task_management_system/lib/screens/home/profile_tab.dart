import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/role.dart';
import 'package:task_management_system/utils/common_methods.dart' as globals;
import 'package:toast/toast.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  DatabaseConnect conn = DatabaseConnect();
  late Employee employeeAccount;
  late Department department;
  late Role role;
  var _formKey = GlobalKey<FormState>();
  bool textChanged = false;

  // int _roleController = globals.loggedEmployee!.roleID;
  // int _deptController = globals.loggedEmployee!.deptID;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _concealPass = true;
  int count = 0;
  static const double SIZE_BETWEEN_TEXT_FIELDS = 15;
  static const double PROFILE_CONTAINER = 140;

  Future<void> getObjectsInitialized() async {
    var allEmployees = await conn.getEmployeeList(null);
    var allDepartments = await conn.getDepartmentList();
    var allRoles = await conn.getRoleList();
    this.employeeAccount = allEmployees
        .firstWhere((emp) => emp.empID == globals.loggedEmployee!.empID);
    this.department = allDepartments
        .firstWhere((dept) => dept.deptID == employeeAccount.deptID);
    this.role =
        allRoles.firstWhere((role) => role.roleID == employeeAccount.roleID);

    _nameController.text = employeeAccount.empName;
    _emailController.text = employeeAccount.empEmail;
    _mobileController.text = employeeAccount.empMobile;
    _addressController.text = employeeAccount.empAddress;
    _passwordController.text = employeeAccount.empPassword;
  }

  String _getDepartment(String deptName) {
    var deptNameList = deptName.split(' '); //[Human, Resources] -> length = 2
    String shortenName = '';
    if (deptName.length > 10 && deptNameList.length > 0) {
      for (var name in deptNameList) {
        shortenName += name.substring(0, 1).toUpperCase();
      }
    } else {
      shortenName = deptName;
    }
    return shortenName + ' Department';
  }

  Future<void> _validateForm() async {
    // FocusScope.of(context).unfocus();
    print('textChanged: $textChanged');
    if (!textChanged) {
      globals.showToast('No changes occured!');
      return;
    }
    if (_formKey.currentState!.validate())
      await _updateEmployee();
    else {
      globals.showToast('Validation is false!');
      print('Validation is false');
    }
  }

  Future<void> _updateEmployee() async {
    Employee employee = Employee(
      empID: employeeAccount.empID,
      roleID: employeeAccount.roleID,
      deptID: employeeAccount.deptID,
      empName: _nameController.text,
      empEmail: _emailController.text,
      empMobile: _mobileController.text,
      empAddress: _addressController.text,
      empPassword: _passwordController.text,
    );
    print('(conn.updateEmployee): ' + employee.toString());

    await conn.updateEmployee(employee);

    globals.showToast('Employee Successfully updated!');

    getObjectsInitialized();
  }

  @override
  void initState() {
    super.initState();
    _concealPass = true;
    textChanged = false;
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: ,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // FocusScopeNode currentFocus = FocusScope.of(context);
          // if (!currentFocus.hasPrimaryFocus) {
          //   currentFocus.unfocus();
          // }
          // Validate form then update
          _validateForm();
        },
        child: Icon(Icons.save),
      ),
      body: FutureBuilder(
          future: getObjectsInitialized(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text(ConnectionState.done.toString());
            } else {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: PROFILE_CONTAINER / 3),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        // fit: StackFit.passthrough,
                        children: [
                          Container(
                            height: PROFILE_CONTAINER,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                SizedBox(height: PROFILE_CONTAINER / 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Hello, ",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: kFontBodyColor,
                                        )),
                                    Text(
                                        employeeAccount.empName
                                                .split(' ')
                                                .first +
                                            '!',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${role.roleName}, ",
                                        style:
                                            TextStyle(color: kFontBodyColor)),
                                    Text(_getDepartment(department.deptName),
                                        style:
                                            TextStyle(color: kFontBodyColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            // left: 50,
                            top: -50,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: AssetImage(
                                  employeeAccount.empAvatar == null
                                      ? 'assets/avatars/img2.png'
                                      : employeeAccount.empAvatar!),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: PROFILE_CONTAINER / 5),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: _textFieldsWidgets(),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget _textFieldsWidgets() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: SIZE_BETWEEN_TEXT_FIELDS),
          TextFormField(
            enabled: false,
            cursorColor: Colors.amber[800],
            maxLength: 25,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            controller: _nameController,
            onChanged: (_) {
              textChanged = true;
            },
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
            enabled: false,
            cursorColor: Colors.amber[800],
            maxLength: 30,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            onChanged: (_) {
              textChanged = true;
            },
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
            onChanged: (_) {
              textChanged = true;
            },
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
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
            controller: _addressController,
            onChanged: (_) {
              textChanged = true;
            },
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
          TextFormField(
            scrollPadding: EdgeInsets.only(bottom: 450),
            cursorColor: Colors.amber[800],
            maxLength: 30,
            textInputAction: TextInputAction.go,
            onChanged: (_) {
              textChanged = true;
            },
            onFieldSubmitted: (_) async {
              // Validate form then update
              _validateForm();
            },
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
    );
  }
}
