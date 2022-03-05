class Employee {
  int? empID;
  int roleID;
  int deptID;
  final String empName;
  final String empEmail;
  final String empMobile;
  final String empAddress;
  final String empAvatar;

  Employee({
    this.empID,
    required this.roleID,
    required this.deptID,
    required this.empName,
    required this.empEmail,
    required this.empMobile,
    required this.empAddress,
    required this.empAvatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'empID': empID,
      'roleID': roleID,
      'deptID': deptID,
      'empName': empName,
      'empEmail': empEmail,
      'empMobile': empMobile,
      'empAddress': empAddress,
      'empAvatar': empAvatar,
    };
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Employee(empID: $empID, roleID: $roleID, deptID: $deptID, empName: $empName, empEmail: $empEmail, empMobile: $empMobile, empAddress: $empAddress, empAvatar: $empAvatar)';
  }
}
