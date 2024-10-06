import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskRepository {
  static Database? _database;

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, priority TEXT, isCompleted INTEGER, createdAt TEXT)",
        );
      },
      version: 1,
    );
    return _database!;
  }

  static Future<void> insertTask(Task task) async {
    final db = await _getDatabase();
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Task>> getTasks() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  static Future<void> updateTask(Task task) async {
    final db = await _getDatabase();
    await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await _getDatabase();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Task copyWith(
    Task task, {
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: task.id, // Keep the existing ID
      title: title ?? task.title,
      description: description ?? task.description,
      dueDate: dueDate ?? task.dueDate,
      priority: priority ?? task.priority,
      isCompleted: isCompleted ?? task.isCompleted,
    );
  }
}
