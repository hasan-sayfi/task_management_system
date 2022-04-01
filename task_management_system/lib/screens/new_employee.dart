import 'package:flutter/material.dart';
import 'package:task_management_system/constants/colors.dart';
import 'package:task_management_system/models/employee.dart';

class NewEmployee extends StatefulWidget {
  @override
  _NewEmployeeState createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Employee"),
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
      body: SingleChildScrollView(
        child: Container(
          height: 480,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitData,
        child: Icon(Icons.save),
      ),
    );
  }

  void _submitData() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate())
      return;
    else {
      final empName = _nameController.text;
      final empEmail = _emailController.text;
      final empMobile = _mobileController.text;
      final empAddress = _addressController.text;

      Employee newEmp = Employee(
        empID: 10,
        roleID: 3,
        deptID: 2,
        empName: empName,
        empEmail: empEmail,
        empMobile: empMobile,
        empAddress: empAddress,
      );
      Navigator.pop(context, newEmp);
      // Employee.generateEmployees().add(newEmp);
      // setState(() {
      //   ManagerEmployeeTab.allEmployees.add(newEmp);
      //   print("Length All: " +
      //       Employee.generateEmployees()[
      //               Employee.generateEmployees().length - 1]
      //           .toString() +
      //       " Length Dep: " +
      //       ManagerEmployeeTab.allEmployees.length.toString());
      //   print("Employee Dept: " + ManagerEmployeeTab.allEmployees.toString());
      //   print("Employee Added: " + newEmp.toString());

      //   Navigator.pop(context);
      // });
    }
  }
}
