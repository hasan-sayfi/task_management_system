class EmployeeTaskRecord {
  int empId;
  int taskId;
  DateTime? finishedDate;

  EmployeeTaskRecord({
    required this.empId,
    required this.taskId,
    this.finishedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'empId': empId,
      'taskId': taskId,
      'finishedDate': finishedDate.toString(),
    };
  }

  // Dump Data
  List<EmployeeTaskRecord> generateRoles() {
    return [
      EmployeeTaskRecord(
        empId: 5,
        taskId: 1,
      ),
      EmployeeTaskRecord(
        empId: 6,
        taskId: 2,
      ),
      EmployeeTaskRecord(
        empId: 5,
        taskId: 3,
        finishedDate: DateTime.utc(2022, 3, 10, 11, 30),
      ),
      EmployeeTaskRecord(
        empId: 7,
        taskId: 4,
      ),
      EmployeeTaskRecord(
        empId: 7,
        taskId: 5,
      ),
      EmployeeTaskRecord(
        empId: 7,
        taskId: 6,
        finishedDate: DateTime.utc(2022, 3, 22, 18, 10),
      ),
      EmployeeTaskRecord(
        empId: 6,
        taskId: 7,
        finishedDate: DateTime.utc(2022, 3, 12, 9, 45),
      ),
      EmployeeTaskRecord(
        empId: 8,
        taskId: 8,
      ),
    ];
  }
}
