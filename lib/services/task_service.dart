import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import 'package:path/path.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, isCompleted INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add(task.toJson());
  }

  Stream<List<Task>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> cacheTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getCachedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }
}
