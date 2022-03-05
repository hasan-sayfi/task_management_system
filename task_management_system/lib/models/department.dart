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
}
