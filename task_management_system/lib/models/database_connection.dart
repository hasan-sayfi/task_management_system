import 'package:sqflite/sqflite.dart'; // sqflite for database
import 'package:path/path.dart';
import 'package:task_management_system/models/todo_model.dart'; // the path package

class DatabaseConnect {
  // Tables Queries:
  final employeeSQL = '''
      CREATE TABLE "Employee" (
        "empID"	INTEGER NOT NULL,
        "roleID"	INTEGER NOT NULL,
        "deptID"	INTEGER NOT NULL,
        "empName"	TEXT NOT NULL,
        "empEmail"	TEXT NOT NULL,
        "empMobile"	TEXT,
        "empAddress"	TEXT,
        "empAvatar"	TEXT,
        FOREIGN KEY("deptID") REFERENCES "Department"("deptID"),
        FOREIGN KEY("roleID") REFERENCES "Role"("roleID"),
        PRIMARY KEY("empID" AUTOINCREMENT)
      );
      ''';
  final departmentSQL = '''
      CREATE TABLE "Department" (
        "deptID"	INTEGER NOT NULL,
        "deptName"	TEXT NOT NULL,
        PRIMARY KEY("deptID" AUTOINCREMENT)
      );
      ''';
  final taskSQL = '''
      CREATE TABLE "Task" (
        "taskID"	INTEGER,
        "taskName"	TEXT NOT NULL,
        "taskDesc"	TEXT NOT NULL,
        "taskComment"	TEXT,
        "taskStartDate"	TEXT NOT NULL,
        "taskEndDate"	TEXT NOT NULL,
        "taskProgress"	INTEGER NOT NULL DEFAULT 0,
        "taskStatus"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("taskID" AUTOINCREMENT)
      );
      ''';
  final roleSQL = '''
      CREATE TABLE "Role" (
        "roleID"	INTEGER NOT NULL,
        "roleName"	TEXT NOT NULL,
        PRIMARY KEY("roleID" AUTOINCREMENT)
      );
      ''';
  final employeeTaskRecordSQL = '''
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
  final todoSQL = '''
      CREATE TABLE "todo"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
        "title" TEXT, 
        "creationDate" TEXT, 
        "isChecked" INTEGER,
        PRIMARY KEY("recID" AUTOINCREMENT)
      )
      ''';

  Database? _database;

  // Create a getter and open a connection to database
  Future<Database?> get database async {
    // This is the location for the DB in device. ex - data/data/...
    final dbPath = await getDatabasesPath();
    // This is the name of our DB
    const dbName = 'task_management_system.db';
    // This joins the db_path and db_name and creates a full path for DB
    // ex - data/data/todo.db
    final path = join(dbPath, dbName);

    // Open the connection
    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database;
  }

  // Create the _createDB function seperately
  // This creates Tables in the DB
  Future<void> _createDB(Database db, int version) async {
    // Ensure that the columns in the DB match the todo_model fields
    await db.execute(todoSQL);
  }

  // Insert function
  Future<void> insertTodo(Todo todo) async {
    // Get connection to DB
    final db = await database;
    // Insert the todo
    await db!.insert(
      'todo', // Table name
      todo.toMap(), // Function created in todo_model
      conflictAlgorithm:
          ConflictAlgorithm.replace, // This helps to replace the dublicates
    );
  }

  // Delete function
  Future<void> deleteTodo(Todo todo) async {
    // Get connection to DB
    final db = await database;
    // Delete the todo from DB based on ID
    await db!.delete(
      'todo', // Table name
      where: 'id == ?', // Where condition
      whereArgs: [todo.id], // Args from the todo_model
    );
  }

  // Select Function
  Future<List<Todo>> getTodo() async {
    // Get connection to DB
    final db = await database;
    // Query the DB and save the todo as list of maps
    List<Map<String, dynamic>> items = await db!.query(
      'todo', // Table name
      orderBy: 'id DESC', // Order the list by descending order
    );

    // Convert the items from list of maps to list of todo
    return List.generate(
      items.length,
      (index) => Todo(
        id: items[index]['id'],
        title: items[index]['title'],
        creationDate: DateTime.parse(
            items[index]['creationDate']), // Reformat from text to datetime
        isChecked: items[index]['isChecked'] == 1
            ? true
            : false, // Convert int to bool
      ),
    );
  }
}
