import 'package:sqflite/sqflite.dart'; // sqflite for database
import 'package:path/path.dart'; // the path package
import './todo_model.dart'; // the todo model we created before

class DatabaseConnect {
  Database? _database;
  final todoSQL = '''
      CREATE TABLE "todo"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
        "title" TEXT, 
        "creationDate" TEXT, 
        "isChecked" INTEGER,
        PRIMARY KEY("recID" AUTOINCREMENT)
      )
      ''';
  // Create a getter and open a connection to database
  Future<Database?> get database async {
    // This is the location for the DB in device. ex - data/data/...
    final dbPath = await getDatabasesPath();
    // This is the name of our DB
    const db_name = 'todo.db';
    // This joins the db_path and db_name and creates a full path for DB
    // ex - data/data/todo.db
    final path = join(dbPath, db_name);

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
