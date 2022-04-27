class Department {
  int? deptID;
  late String deptName;

  Department({
    this.deptID,
    required this.deptName,
  });

  Map<String, dynamic> toMap() {
    return {
      'deptID': deptID,
      'deptName': deptName,
    };
  }

  //Extract Department object from MAP object
  Department.fromMapObject(Map<String, dynamic> map) {
    this.deptID = map['deptID'];
    this.deptName = map['deptName'];
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Department(deptID: $deptID,deptName: $deptName)';
  }

  // Dump Data
  List<Department> generateDepartments() {
    return [
      Department(deptID: 1, deptName: "Administrator"),
      Department(deptID: 2, deptName: "Information Technology"),
      Department(deptID: 3, deptName: "Human Resources"),
      Department(deptID: 4, deptName: "Marketing"),
    ];
  }
}
