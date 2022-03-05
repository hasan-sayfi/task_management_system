class Task {
  int? taskID;
  final String taskName;
  final String taskDesc;
  String taskComment;
  DateTime taskStartDate;
  DateTime taskEndDate;
  int taskProgress;
  bool taskStatus;

  Task({
    this.taskID,
    required this.taskName,
    required this.taskDesc,
    required this.taskComment,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskProgress,
    required this.taskStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'taskName': taskName,
      'taskDesc': taskDesc,
      'taskComment': taskComment,
      'taskStartDate': taskStartDate.toString(),
      'taskEndDate': taskEndDate.toString(),
      'taskProgress': taskProgress,
      'taskStatus': taskStatus ? 1 : 0,
    };
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Task(taskID: $taskID, taskName: $taskName, taskDesc: $taskDesc,taskComment: $taskComment, taskStartDate: $taskStartDate, taskEndDate: $taskEndDate, taskProgress: $taskProgress, taskStatus: $taskStatus)';
  }
}
