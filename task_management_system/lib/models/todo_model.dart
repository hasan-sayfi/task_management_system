class Todo {
  int? id;
  final String title;
  DateTime creationDate;
  bool isChecked;

  // Create construction
  Todo({
    this.id,
    required this.title,
    required this.creationDate,
    required this.isChecked,
  });

  // Convert to map to save in DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creationDate': creationDate
          .toString(), // sqflite doesn't support date, so we use string
      'isChecked':
          isChecked ? 1 : 0, // sqflite doesn't support bool, so we use int
    };
  }

  // This is for debuggin only
  @override
  String toString() {
    return 'Todo(id: $id,title: $title,creationDate: $creationDate,isChecked: $isChecked,)';
  }
}
