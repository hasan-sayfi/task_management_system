class TableQueries {
  static const departmentSQL = '''
      CREATE TABLE "Department" (
        "deptID"	INTEGER NOT NULL,
        "deptName"	TEXT NOT NULL,
        PRIMARY KEY("deptID" AUTOINCREMENT)
      );
      ''';
  static const roleSQL = '''
      CREATE TABLE "Role" (
        "roleID"	INTEGER NOT NULL,
        "roleName"	TEXT NOT NULL,
        PRIMARY KEY("roleID" AUTOINCREMENT)
      );
      ''';
  static const employeeSQL = '''
      CREATE TABLE "Employee" (
        "empID"	INTEGER NOT NULL,
        "roleID"	INTEGER NOT NULL,
        "deptID"	INTEGER NOT NULL,
        "empName"	TEXT NOT NULL,
        "empEmail"	TEXT NOT NULL,
        "empMobile"	TEXT,
        "empAddress"	TEXT,
        "empAvatar"	TEXT,
        "empPassword"	TEXT,
        FOREIGN KEY("deptID") REFERENCES "Department"("deptID"),
        FOREIGN KEY("roleID") REFERENCES "Role"("roleID"),
        PRIMARY KEY("empID" AUTOINCREMENT)
      );
      ''';
  static const taskSQL = '''
      CREATE TABLE "Task" (
        "taskID"	INTEGER,
        "taskName"	TEXT NOT NULL,
        "taskDesc"	TEXT NOT NULL,
        "taskComment"	TEXT,
        "taskStartDate"	TEXT NOT NULL,
        "taskEndDate"	TEXT NOT NULL,
        "taskProgress"	INTEGER NOT NULL DEFAULT 0,
        "taskStatus"	INTEGER NOT NULL DEFAULT 0,
        "empID"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("empID") REFERENCES "Employee"("empID"),
        PRIMARY KEY("taskID" AUTOINCREMENT)
      );
      ''';
  static const employeeTaskRecordSQL = '''
      CREATE TABLE "EmployeeTaskRecord" (
        "recID"	INTEGER NOT NULL,
        "empID"	INTEGER NOT NULL,
        "taskID"	INTEGER NOT NULL,
        "finishedDate"	TEXT NOT NULL,
        FOREIGN KEY("empID") REFERENCES "Employee"("empID"),
        FOREIGN KEY("taskID") REFERENCES "Task"("taskID"),
        PRIMARY KEY("recID" AUTOINCREMENT)
      );
      ''';
  static const userSQL = '''
      CREATE TABLE "User" (
        "userID"	INTEGER NOT NULL,
        "empID"	INTEGER NOT NULL,
        "password"	TEXT NOT NULL,
        FOREIGN KEY("empID") REFERENCES "Employee"("empID"),
        PRIMARY KEY("userID" AUTOINCREMENT)
      );
      ''';
}
