class Employee {
  int? empID;
  late int roleID;
  late int deptID;
  late String empName;
  late String empEmail;
  late String empMobile;
  late String empAddress;
  String? empAvatar = "assets/avatars/img1.png";
  late String empPassword;

// Constructor
  Employee({
    this.empID,
    required this.roleID,
    required this.deptID,
    required this.empName,
    required this.empEmail,
    required this.empMobile,
    required this.empAddress,
    this.empAvatar = 'assets/avatars/img2.png',
    required this.empPassword,
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
      'empPassword': empPassword,
    };
  }

  //Extract Employee object from MAP object
  Employee.fromMapObject(Map<String, dynamic> map) {
    this.empID = map['empID'];
    this.roleID = map['roleID'];
    this.deptID = map['deptID'];
    this.empName = map['empName'];
    this.empEmail = map['empEmail'];
    this.empMobile = map['empMobile'];
    this.empAddress = map['empAddress'];
    this.empAvatar = map['empAvatar'];
    this.empPassword = map['empPassword'];
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Employee(empID: $empID, roleID: $roleID, deptID: $deptID, empName: $empName, empEmail: $empEmail, empMobile: $empMobile, empAddress: $empAddress, empAvatar: $empAvatar)';
  }

  // Dump Data
  static List<Employee> generateEmployees() {
    return [
      Employee(
        empID: 1,
        roleID: 1,
        deptID: 1,
        empName: "Admin",
        empEmail: "Admin@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empAvatar: "assets/avatars/img1.png",
        empPassword: "123",
      ),
      Employee(
        empID: 2,
        roleID: 2,
        deptID: 2,
        empName: "Ahmad",
        empEmail: "Ahmad@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empAvatar: "assets/avatars/img2.png",
        empPassword: "123",
      ),
      Employee(
        empID: 3,
        roleID: 2,
        deptID: 3,
        empName: "Ali",
        empEmail: "Ali@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empAvatar: "assets/avatars/img3.png",
        empPassword: "123",
      ),
      Employee(
        empID: 4,
        roleID: 2,
        deptID: 4,
        empName: "Mohammad",
        empEmail: "Mohammad@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empAvatar: "assets/avatars/img5.png",
        empPassword: "123",
      ),
      Employee(
        empID: 5,
        roleID: 3,
        deptID: 2,
        empName: "Noor",
        empEmail: "Noor@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empPassword: "123",
      ),
      Employee(
        empID: 6,
        roleID: 3,
        deptID: 2,
        empName: "Fahad",
        empEmail: "Fahad@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empPassword: "123",
      ),
      Employee(
        empID: 7,
        roleID: 3,
        deptID: 3,
        empName: "Khalid",
        empEmail: "Khalid@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empPassword: "123",
      ),
      Employee(
        empID: 8,
        roleID: 3,
        deptID: 4,
        empName: "Rayan",
        empEmail: "Rayan@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empPassword: "123",
      ),
      Employee(
        empID: 9,
        roleID: 3,
        deptID: 2,
        empName: "My Name",
        empEmail: "MyName@test.com",
        empMobile: "0512345678",
        empAddress: "123 Main Street",
        empPassword: "123",
      ),
    ];
  }

  static int getTotalEmployeesInDepartment(int deptId) {
    var counter = 0;
    for (var emp in generateEmployees()) {
      if (deptId == emp.deptID) counter++;
    }

    return counter - 1;
  }

  static List<Employee> getEmployeesInDepartment(int? deptId) {
    List<Employee> employeesList = [];
    for (var emp in generateEmployees()) {
      if (deptId != null) {
        if (deptId == emp.deptID && emp.roleID == 3) {
          employeesList.add(emp);
        }
      } else
        employeesList.add(emp);
    }
    print("Employees Size: " + employeesList.length.toString());

    return employeesList;
  }
}
