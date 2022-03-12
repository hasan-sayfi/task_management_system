class Task {
  int? taskID;
  final String taskName; // Header for task
  final String taskDesc; // Any description to help understand the task
  String? taskComment; // If there are any comment about the task
  DateTime taskStartDate; // Start date for the task
  DateTime taskEndDate; // Deadline for the task
  int taskProgress; // percentage of task completion
  bool taskStatus; // status of task: in-progress (false) or finished (true)
  int managerID;

  Task({
    this.taskID,
    required this.taskName,
    required this.taskDesc,
    this.taskComment,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskProgress,
    required this.taskStatus,
    required this.managerID,
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
      'managerID': managerID,
    };
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Task(taskID: $taskID, taskName: $taskName, taskDesc: $taskDesc,taskComment: $taskComment, taskStartDate: $taskStartDate, taskEndDate: $taskEndDate, taskProgress: $taskProgress, taskStatus: $taskStatus, managerID: $managerID)';
  }

  // Dump Data
  List<Task> generateTasks() {
    return [
      Task(
        taskID: 1,
        taskName: "Backup Database",
        taskDesc: "Take a backup from all databases.",
        taskStartDate: DateTime.utc(2022, 3, 10, 08, 30),
        taskEndDate: DateTime.utc(2022, 3, 12, 12, 0),
        taskProgress: 50,
        taskStatus: false,
        managerID: 2,
      ),
      Task(
        taskID: 2,
        taskName: "Troubleshoot Bug",
        taskDesc: "There is a bug in Home Page where you cannot logout.",
        taskStartDate: DateTime.utc(2022, 3, 12, 08, 0),
        taskEndDate: DateTime.utc(2022, 3, 14, 17, 0),
        taskProgress: 0,
        taskStatus: false,
        managerID: 2,
      ),
      Task(
        taskID: 3,
        taskName: "Upgrade Payment Service",
        taskDesc: "Upgrade Payment Service with the new security update.",
        taskStartDate: DateTime.utc(2022, 3, 9, 11, 15),
        taskEndDate: DateTime.utc(2022, 3, 10, 16, 20),
        taskProgress: 100,
        taskStatus: true,
        managerID: 2,
      ),
      Task(
          taskID: 4,
          taskName: "Recruit Designer",
          taskDesc:
              "We are in need for a UI/UX employee with min of 3 years experience.",
          taskStartDate: DateTime.utc(2022, 3, 13, 08, 30),
          taskEndDate: DateTime.utc(2022, 3, 20, 12, 0),
          taskProgress: 20,
          taskStatus: false,
          managerID: 3),
      Task(
        taskID: 5,
        taskName: "Annual Raise",
        taskDesc: "Increase raise allowance for all employees by 5%.",
        taskStartDate: DateTime.utc(2022, 3, 16, 08, 30),
        taskEndDate: DateTime.utc(2022, 3, 12, 12, 0),
        taskProgress: 50,
        taskStatus: false,
        managerID: 3,
      ),
      Task(
        taskID: 6,
        taskName: "Contract Renewal",
        taskDesc: "Renew the contract for Employee #5 for 2 more years.",
        taskStartDate: DateTime.utc(2022, 3, 15, 08, 30),
        taskEndDate: DateTime.utc(2022, 3, 31, 12, 0),
        taskProgress: 100,
        taskStatus: true,
        managerID: 3,
      ),
      Task(
        taskID: 7,
        taskName: "Access Privalige to Employee #2",
        taskDesc:
            "Provide access to our servers to employee #2 until the end of the month.",
        taskStartDate: DateTime.utc(2022, 3, 11, 08, 30),
        taskEndDate: DateTime.utc(2022, 3, 13, 12, 0),
        taskProgress: 100,
        taskStatus: true,
        managerID: 2,
      ),
      Task(
        taskID: 8,
        taskName: "Advertise New Service",
        taskDesc:
            "W have launched a new service and we require more advertising to different platforms.",
        taskStartDate: DateTime.utc(2022, 3, 10, 08, 30),
        taskEndDate: DateTime.utc(2022, 3, 12, 12, 0),
        taskProgress: 67,
        taskStatus: false,
        managerID: 4,
      ),
    ];
  }
}
