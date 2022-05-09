import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart'; // sqflite for database
import 'package:task_management_system/models/department.dart';
import 'package:task_management_system/models/employee.dart';
import 'package:task_management_system/models/role.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/script/table_fields.dart';
import 'package:task_management_system/script/table_names.dart';
import 'package:task_management_system/script/table_queries.dart';

class DatabaseConnect {
  static DatabaseConnect? _databaseConnect; //Singleton DatabaseHelper
  static Database? _database; //Singleton Database
  static const String DB_NAME = 'task_management_system2';

  // Tables Queries:
  final departmentSQL = TableQueries.departmentSQL;
  final roleSQL = TableQueries.roleSQL;
  final employeeSQL = TableQueries.employeeSQL;
  final taskSQL = TableQueries.taskSQL;
  final employeeTaskRecordSQL = TableQueries.employeeTaskRecordSQL;
  final userSQL = TableQueries.userSQL;

  DatabaseConnect._createInstance();

  factory DatabaseConnect() {
    if (_databaseConnect == null) {
      _databaseConnect = DatabaseConnect._createInstance();
    }
    return _databaseConnect!;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // This is the location for the DB in device. ex - data/data/...
    Directory directory = await getApplicationDocumentsDirectory();

    // This joins the db_path and db_name and creates a full path for DB
    // ex - data/data/todo.db
    String path = directory.path + DB_NAME;

    // Open/Create the database at the given path
    var taskDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);

    return taskDatabase;
  }

  /*
  Create the _createDB function seperately
  This creates Tables in the DB 
  */
  Future<void> _createDB(Database db, int version) async {
    // Ensure that the columns in the DB match the todo_model fields
    await db.execute(departmentSQL);
    await db.execute(roleSQL);
    await db.execute(employeeSQL);
    await db.execute(taskSQL);
    await db.execute(employeeTaskRecordSQL);
  }

  /* START SELECT SECTION */

  //Fetch Operation: Get all Employee objects from database
  Future<List<Map<String, dynamic>>> getEmployeeMapList(int? deptID) async {
    Database? db = await this.database;
    //var result = db.rawQuery('SELECT * FROM $taskTable order by $colDate, $colTime ASC');
    var result;
    if (deptID == null) {
      result =
          db!.query(TableNames.empTableName, orderBy: '${TableFields.empID}');
    } else {
      result = db!.query(TableNames.empTableName,
          where: '${TableFields.deptID} = ? and ${TableFields.roleID} = ?',
          whereArgs: [deptID, 3],
          orderBy: '${TableFields.empName}');
    }
    return result;
  }

  //Fetch Operation: convert Employee map objects to List of Employees
  Future<List<Employee>> getAllEmployeeList() async {
    Database? db = await this.database;
    final List<Map<String, dynamic>> result = await db!
        .query(TableNames.empTableName, orderBy: '${TableFields.empID}');
    // Convert the List<Map<String, dynamic> into a List<Recipe>.
    return List.generate(result.length, (i) {
      // print('Generated List: ' + result[i].toString());
      return Employee(
        empID: result[i][TableFields.empID],
        roleID: result[i][TableFields.roleID],
        deptID: result[i][TableFields.deptID],
        empName: result[i][TableFields.empName],
        empEmail: result[i][TableFields.empEmail],
        empMobile: result[i][TableFields.empMobile],
        empAddress: result[i][TableFields.empAddress],
        empPassword: result[i][TableFields.empPassword],
      );
    });
  }

  //Fetch Operation: Get all Task objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList(
    int deptID,
  ) async {
    Database? db = await this.database;
    var result = db!.rawQuery(
        'SELECT * FROM ${TableNames.taskTableName} t WHERE t.empID IN (SELECT e.empID FROM Employee e WHERE e.deptID = $deptID)');
    /* var result = db!.query(TableNames.taskTableName,
        where: '${TableFields.empID} = ?',
        whereArgs: [empID],
        orderBy: '${TableFields.taskStartDate}'); */
    return result;
  }

  //Fetch Operation: Get all Department objects from database
  Future<List<Map<String, dynamic>>> getDepartmentMapList(int? deptID) async {
    Database? db = await this.database;
    //var result = db.rawQuery('SELECT * FROM $taskTable order by $colDate, $colTime ASC');
    var result;
    if (deptID == null)
      result = db!.query(TableNames.deptTableName);
    else
      result = db!.query(TableNames.deptTableName,
          where: '${TableFields.deptID} = ?', whereArgs: [deptID]);

    return result;
  }

  //Fetch Operation: convert Role map objects to List of Roles
  Future<List<Department>> getDepartmentList() async {
    var departmentMapList =
        await getDepartmentMapList(null); //Get Map List from database
    int count = departmentMapList.length;

    List<Department> departmentList = <Department>[];
    //For loop to create Task List from a Map List
    for (int i = 0; i < count; i++) {
      departmentList.add(Department.fromMapObject(departmentMapList[i]));
    }
    return departmentList;
  }

  //Fetch Operation: Get a Department name from database
  Future<String> getDepartmentNameMap(int deptID) async {
    Database? db = await this.database;
    String sql =
        'SELECT ${TableFields.deptName} FROM ${TableNames.deptTableName} WHERE ${TableFields.deptID} = ?';
    var result = await db!.rawQuery(sql, ['${deptID.toString()}']);
    if (result.length > 0) {
      String firstResult = result.first.values.first.toString();
      return firstResult;
    } else {
      return '';
    }
  }

  //Fetch Operation: Get all Role objects from database
  Future<List<Map<String, dynamic>>> getRoleMapList() async {
    Database? db = await this.database;
    //var result = db.rawQuery('SELECT * FROM $taskTable order by $colDate, $colTime ASC');
    var result = db!.query(TableNames.roleTableName);
    return result;
  }

  //Fetch Operation: convert Role map objects to List of Roles
  Future<List<Role>> getRoleList() async {
    var roleMapList = await getRoleMapList(); //Get Map List from database
    int count = roleMapList.length;

    List<Role> roleList = <Role>[];
    //For loop to create Task List from a Map List
    for (int i = 0; i < count; i++) {
      roleList.add(Role.fromMapObject(roleMapList[i]));
    }
    return roleList;
  }
  /* END SELECT SECTION */

  /* START INSERT SECTION */

  //Insert Operation: Insert a Task object to database
  Future<int> insertTask(Task task) async {
    Database? db = await this.database;
    var result = await db!.insert(TableNames.taskTableName, task.toMap());
    return result;
  }

  //Insert Operation: Insert a Role object to database
  Future<int> insertRole(Role role) async {
    Database? db = await this.database;
    var result = await db!.insert(TableNames.roleTableName, role.toMap());
    return result;
  }

  //Insert Operation: Insert a Department object to database
  Future<int> insertDepartment(Department department) async {
    Database? db = await this.database;
    var result = await db!.insert(TableNames.deptTableName, department.toMap());
    return result;
  }

  //Insert Operation: Insert an Employee object to database
  Future<int> insertEmployee(Employee employee) async {
    Database? db = await this.database;
    var result = await db!.insert(TableNames.empTableName, employee.toMap());
    return result;
  }
  /* END INSERT SECTION */

  /* START UPDATE SECTION */
  //Update Operation: Update a Role object to database
  Future<int> updateRole(Role role) async {
    Database? db = await this.database;
    var result = await db!.update(
      TableNames.roleTableName, role.toMap(),
      where: '${TableFields.roleID} = ?',
      whereArgs: [role.roleID],
      conflictAlgorithm:
          ConflictAlgorithm.replace, // This helps to replace the dublicates
    );

    return result;
  }

  //Update Operation: Update a Department object to database
  Future<int> updateDepartment(Department department) async {
    Database? db = await this.database;
    var result = await db!.update(
      TableNames.deptTableName, department.toMap(),
      where: '${TableFields.deptID} = ?', whereArgs: [department.deptID],
      conflictAlgorithm:
          ConflictAlgorithm.replace, // This helps to replace the dublicates
    );

    return result;
  }

  //Update Operation: Update a Employee object to database
  Future<int> updateEmployee(Employee employee) async {
    Database? db = await this.database;
    var result = await db!.update(
      TableNames.empTableName, employee.toMap(),
      where: '${TableFields.empID} = ?', whereArgs: [employee.empID],
      conflictAlgorithm:
          ConflictAlgorithm.replace, // This helps to replace the dublicates
    );

    return result;
  }
  /* END UPDATE SECTION */

  /* START DELETE SECTION */
  //Delete Operation: Delete a Role object in database
  Future<int> deleteRole(Role role) async {
    Database? db = await this.database;
    // var result = await db!.delete(TableNames.roleTableName, role.toMap(),
    //     where: '${TableFields.roleID} = ?', whereArgs: [role.roleID]);
    var result = await db!.delete(TableNames.roleTableName,
        where: '${TableFields.roleID} = ?', whereArgs: [role.roleID]);

    int count = await db.rawUpdate(
        'UPDATE sqlite_sequence SET seq = (SELECT MAX(${TableFields.roleID}) FROM ${TableNames.roleTableName}) WHERE name="${TableNames.roleTableName}"');

    print('deleteRole: $count');

    return result;
  }

  //Delete Operation: Delete all Roles object in database
  Future<int> deleteAllRoles() async {
    Database? db = await this.database;
    var result = await db!.rawDelete('DELETE FROM ${TableNames.roleTableName}');

    int count = await db.rawUpdate(
        'UPDATE sqlite_sequence SET seq = (SELECT MAX(${TableFields.roleID}) FROM ${TableNames.roleTableName}) WHERE name="${TableNames.roleTableName}"');

    print('deleteAllRole: $count');

    return result;
  }

  //Delete Operation: Delete a Department object in database
  Future<int> deleteDepartment(Department department) async {
    Database? db = await this.database;
    var result = await db!.delete(TableNames.deptTableName,
        where: '${TableFields.deptID} = ?', whereArgs: [department.deptID]);

    int count = await db.rawUpdate(
        'UPDATE sqlite_sequence SET seq = (SELECT MAX(${TableFields.deptID}) FROM ${TableNames.deptTableName}) WHERE name="${TableNames.deptTableName}"');

    print('deleteRole: $count');

    return result;
  }

  //Delete Operation: Delete all Departments object in database
  Future<int> deleteAllDepartments() async {
    Database? db = await this.database;
    var result = await db!.rawDelete('DELETE FROM ${TableNames.deptTableName}');

    int count = await db.rawUpdate(
        'UPDATE sqlite_sequence SET seq = (SELECT MAX(${TableFields.deptID}) FROM ${TableNames.deptTableName}) WHERE name="${TableNames.deptTableName}"');

    print('deleteAllDepartments: $count');

    return result;
  }

  //Delete Operation: Delete an Employee object in database
  Future<int> deleteEmployee(int empID) async {
    Database? db = await this.database;
    var result = await db!.delete(TableNames.empTableName,
        where: '${TableFields.empID} = ?', whereArgs: [empID]);

    print('deleteEmployee: $result successfully');

    return result;
  }

  /* END DELETE SECTION */
}
