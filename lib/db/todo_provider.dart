import 'package:flutter_project/db/todo_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoProvider {
  static const tableName = "TodoItemTable";

  Future<Database> database() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_item.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $tableName (id TEXT PRIMARY KEY, title TEXT, description TEXT, done INTEGER)",
        );
      },
    );
  }

  Future<List<TodoItem>> fetchTodos() async {
    Database db = await database();
    List<Map<dynamic, dynamic>> todosRaw = await db.query(
      "SELECT * FROM $tableName",
    );

    return todosRaw.map((e) => TodoItem.fromMap(e)).toList();
  }

  Future<void> insertTodo(TodoItem item) async {
    Database db = await database();
    await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
