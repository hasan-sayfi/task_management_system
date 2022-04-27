import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/database_connection.dart';
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/script/table_fields.dart';
import 'package:task_management_system/widgets/build_employee_card.dart';
import 'package:task_management_system/widgets/manager_employee_list.dart';

class AdminEmployeeTab extends StatefulWidget {
  @override
  _AdminEmployeeTabState createState() => _AdminEmployeeTabState();
}

class _AdminEmployeeTabState extends State<AdminEmployeeTab> {
  // List<Employee> employees = Employee.getEmployeesInDepartment(null);

  DatabaseConnect conn = DatabaseConnect();
  var _formKey = GlobalKey<FormState>();
  int _roleController = -1;
  int _deptController = -1;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  List<Map<String, dynamic>> _employees = [];
  var _selectedDep = 0;

  bool _isLoading = true;
  int count = 0;
  static const double SIZE_BETWEEN_TEXT_FIELDS = 15;

  // This function is used to fetch all data from the database
  void _refreshEmployees() async {
    final data = await conn.getEmployeeMapList(null);
    setState(() {
      _employees = data;
      _isLoading = false;
    });
  }

  Future<void> _validateForm() async {
    FocusScope.of(context).unfocus();
    print('Before validate: ' + _formKey.currentState!.validate().toString());
    if (_formKey.currentState!.validate())
      await _addEmployee();
    else
      print('Validation is false');
  }

  // Insert a new Employee to the database
  Future<void> _addEmployee() async {
    Employee employee = Employee(
      roleID: _roleController,
      deptID: _deptController,
      empName: _nameController.text,
      empEmail: _emailController.text,
      empMobile: _mobileController.text,
      empAddress: _addressController.text,
    );
    await conn.insertEmployee(employee);

    _roleController = -1;
    _deptController = -1;
    _nameController.text = '';
    _emailController.text = '';
    _mobileController.text = '';
    _addressController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    _refreshEmployees();
  }

  // Update an existing Employee
  Future<void> _updateEmployee(int empID) async {
    print('(_updateEmployee) _deptController: ' + _deptController.toString());

    Employee employee = Employee(
      empID: empID,
      roleID: _roleController,
      deptID: _deptController,
      empName: _nameController.text,
      empEmail: _emailController.text,
      empMobile: _mobileController.text,
      empAddress: _addressController.text,
    );
    print('(conn.updateEmployee): ' + employee.toString());

    await conn.updateEmployee(employee);
    _roleController = -1;
    _deptController = -1;
    _nameController.text = '';
    _emailController.text = '';
    _mobileController.text = '';
    _addressController.text = '';

    // Close the bottom sheet
    Navigator.pop(context);

    _refreshEmployees();
  }

  @override
  void initState() {
    super.initState();
    _refreshEmployees(); // Loading the employees when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: 520,
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
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.1,
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
                              ],
                              onSelected: (value) => value == 1
                                  ? {
                                      print('onSelected: (value): ' +
                                          value.toString()),
                                      print('_employees[index]: ' +
                                          _employees[index].toString()),
                                      _showForm(
                                          _employees[index][TableFields.empID]),
                                    }
                                  : {
                                      print(
                                          '_employees[index][TableFields.empID]: ' +
                                              _employees[index].toString()),
                                    },
                            ),
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

    print("#_departments: " + _departments.toString());
    print("#_departmentsValue: " + _departmentsValue[1].length.toString());
    print("#_departmentsID: " + _departmentsID.toString());

    if (empID != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingEmployee = _employees
          .firstWhere((element) => element[TableFields.empID] == empID);
      _roleController = existingEmployee[TableFields.roleID];
      _deptController = existingEmployee[TableFields.deptID];
      _nameController.text = existingEmployee[TableFields.empName];
      _emailController.text = existingEmployee[TableFields.empEmail];
      _emailController.text = existingEmployee[TableFields.empEmail];
      _mobileController.text = existingEmployee[TableFields.empMobile];
      _addressController.text = existingEmployee[TableFields.empAddress];

      print('(_showForm)_deptController: ' + _deptController.toString());

      print('_deptController Before: ' + _deptController.toString());
    }
    List<String> deptList = [
      'Administrator',
      'Information Technology',
      'Human Resources',
      'Marketing'
    ];

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
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: _roleController == -1
                            ? null
                            : _roleController == 2
                                ? 'Manager'
                                : 'Employee',
                        items: ['Manager', 'Employee']
                            .map((String item) => DropdownMenuItem<String>(
                                child: Text(item), value: item))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            print("previous $_roleName");
                            print("selected $value");
                            _roleName = value!;
                            switch (_roleName) {
                              case 'Manager':
                                _roleController = 2;
                                break;
                              case 'Employee':
                                _roleController = 3;
                                break;
                              default:
                                _roleController = -1;
                            }
                            print('_roleController: ' +
                                _roleController.toString());
                          });
                        },
                        validator: (value) {
                          print('Validator value: ' + value.toString());
                          if (value.toString().isEmpty ||
                              value == -1 ||
                              value == null)
                            return 'Please select a role';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.settings_accessibility_sharp,
                          ),
                          labelText: 'Please select user role',
                          helperText: 'Employee',
                          hintText: 'Employee',
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
                      DropdownButtonFormField(
                        value: _deptController == -1
                            ? null
                            : _departmentsValue[_deptController - 1],
                        items: _departmentsValue
                            .map((String item) => DropdownMenuItem<String>(
                                child: Text(item), value: item))
                            .toList(),
                        // items: deptList
                        //     .map((e) =>
                        //         DropdownMenuItem(child: Text(e), value: e))
                        //     .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            print("previous $_departmentName");
                            print("selected $value");
                            _departmentName = value!;

                            _deptController =
                                deptList.indexOf(_departmentName) + 1;

                            print('deptList.indexOf(_departmentName): ' +
                                deptList.indexOf(_departmentName).toString());
                            print('_deptController: ' +
                                _deptController.toString());

                            // _deptController = _departmentsID[
                            //     _departmentsValue.indexOf(_departmentName)];
                            // print('_deptController After: ' +
                            //     _deptController.toString());
                            // print(
                            //     '_departmentsID[_departmentsValue.indexOf(_departmentName)]: ' +
                            //         _departmentsID[_departmentsValue
                            //                 .indexOf(_departmentName)]
                            //             .toString());
                            // print('_departmentsValue[_deptController - 1]: ' +
                            //     _departmentsValue[_deptController - 1]);
                          });
                        },
                        validator: (value) {
                          print('Validator value: ' + value.toString());

                          if (value.toString().isEmpty ||
                              value == -1 ||
                              value == null)
                            return 'Please select a department';
                          else
                            return null;
                        },
                        // value: _departmentName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.business_outlined,
                          ),
                          labelText: 'Please select a department',
                          helperText: 'Information Technology',
                          hintText: 'Please select a department',
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
                        textInputAction: TextInputAction.done,
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
                            if (empID == null) {
                              _validateForm();
                            }
                            if (empID != null) {
                              await _updateEmployee(empID);
                            }
                            // Clear the text fields
                            _nameController.text = '';
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
        );
      },
    );
  }
}
