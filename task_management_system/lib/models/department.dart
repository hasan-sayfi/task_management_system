class Department {
  int? deptID;
  final String deptName;

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
