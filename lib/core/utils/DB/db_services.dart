import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../features/auth/data/login_data.dart';
import 'models/attachment.dart';
import 'models/user.dart';
import 'models/task.dart';

class DBServices {
  static final DBServices _instance = DBServices.internal();
  DBServices.internal();
  factory DBServices() => _instance;

  static Database? _database;
  final String fileName = "personal_task.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    print("[Local DB] First-time initialization...");
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    print("[Local DB] Database path: $path");

    if (!await Directory(dbPath).exists()) {
      print("[Local DB] Creating database directory...");
      await Directory(dbPath).create(recursive: true);
    }

    print("[Local DB] Opening database...");
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  // ----------------- CREATE TABLES -----------------
  Future<void> _createDB(Database db, int version) async {
    print("[Local DB] Creating USERS table...");
    await db.execute('''
      CREATE TABLE USERS (
        UID TEXT PRIMARY KEY,
        NAME TEXT NOT NULL,
        EMAIL TEXT NOT NULL UNIQUE,
        PASSWORD TEXT NOT NULL,
        PHONE_NUMBER TEXT NOT NULL,
        IMAGE TEXT
      );
    ''');

    print("[Local DB] Creating TASKS table...");
    await db.execute('''
      CREATE TABLE TASKS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        OWNER_ID TEXT NOT NULL,
        TITLE TEXT NOT NULL,
        DESCRIPTION TEXT,
        CATEGORY TEXT CHECK (CATEGORY IN ('Work','Study','Personal')),
        PRIORITY TEXT NOT NULL CHECK (PRIORITY IN ('Low', 'Medium', 'High')),
        STATUS TEXT NOT NULL CHECK (STATUS IN ('In Progress', 'Completed')) DEFAULT 'In Progress',
        START_DATE TEXT,
        END_DATE TEXT,
        REMINDER_DATE TEXT,
        IS_UPDATED INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SHARED INTEGER DEFAULT 0,
        UPLOAD_STATUS INTEGER DEFAULT 0,
        FOREIGN KEY (OWNER_ID) REFERENCES USERS(UID)
      );
    ''');

    print("[Local DB] Creating ATTACHMENTS table...");
    await db.execute('''
      CREATE TABLE ATTACHMENTS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        TASK_ID INTEGER NOT NULL,
        IMAGE TEXT NOT NULL,
        IS_DELETED INTEGER DEFAULT 0,
        UPLOAD_STATUS INTEGER DEFAULT 0,
        FOREIGN KEY (TASK_ID) REFERENCES TASKS(ID)
      );
    ''');

    print("[Local DB] Creating WEATHER table...");
    await db.execute('''
      CREATE TABLE WEATHER (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        DATA TEXT NOT NULL,
        UPDATED_AT TEXT
      );
    ''');
  }

  // ----------------- WEATHER -----------------
  static Future<void> insertWeather(Map<String, dynamic> json) async {
    final db = await DBServices().database;
    await db.insert("WEATHER", {
      "DATA": jsonEncode(json),
      "UPDATED_AT": DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print("[Local DB] Weather saved locally");
  }

  static Future<Map<String, dynamic>?> getLastWeather() async {
    final db = await DBServices().database;
    final result = await db.query("WEATHER", orderBy: "ID DESC", limit: 1);
    if (result.isNotEmpty) {
      print("[Local DB] Weather loaded from local storage");
      return jsonDecode(result.first["DATA"] as String);
    }
    print("[Local DB] No saved weather found");
    return null;
  }

  // ----------------- USERS -----------------
  static Future<int> insertUser({required User user}) async {
    final db = await DBServices().database;
    return await db.insert(
      'USERS',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> getUser(String uid) async {
    final db = await DBServices().database;
    final res = await db.query('USERS', where: 'UID = ?', whereArgs: [uid]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  static Future<User?> getUserByEmailAndPassword(LoginData data) async {
    final db = await DBServices().database;
    final res = await db.query(
      'USERS',
      where: 'EMAIL = ? AND PASSWORD = ?',
      whereArgs: [data.email, data.password],
    );
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  static Future<int> updateUser({required User user}) async {
    final db = await DBServices().database;
    return await db.update(
      'USERS',
      user.toMap(),
      where: 'UID = ?',
      whereArgs: [user.uid],
    );
  }

  // ----------------- TASKS -----------------
  static Future<int> insertTask({required Task task}) async {
    final db = await DBServices().database;
    return await db.insert(
      'TASKS',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateTask({required Task task}) async {
    final db = await DBServices().database;
    return await db.update(
      'TASKS',
      task.toMap(),
      where: 'ID = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> updateTaskStatus(String taskId, String status) async {
    final db = await DBServices().database;
    return await db.update(
      'TASKS',
      {'STATUS': status},
      where: 'ID = ?',
      whereArgs: [taskId],
    );
  }

  static Future<int> deleteTask(int taskId) async {
    final db = await DBServices().database;
    return await db.delete(
      'TASKS',
      where: 'ID = ?',
      whereArgs: [taskId],
    );
  }

  static Future<int> toggleTaskIsDeleted({required int taskId, required int isDeleted}) async {
    final db = await DBServices().database;
    return await db.update(
      'TASKS',
      {'IS_DELETED': isDeleted},
      where: 'ID = ?',
      whereArgs: [taskId],
    );
  }

  static Future<int> toggleTaskIsUploaded({required int taskId, required int isUploaded}) async {
    final db = await DBServices().database;
    return await db.update(
      'TASKS',
      {'UPLOAD_STATUS': isUploaded, 'IS_UPDATED': 0},
      where: 'ID = ?',
      whereArgs: [taskId],
    );
  }

  static Future<int> toggleIsUpdatedStatus({required int taskId , required int isUpdated}) async{
    final db = await DBServices().database;
    return await db.update('TASKS',
    {'IS_UPDATED' : isUpdated},
      where: 'ID = ?',
      whereArgs: [taskId]
    );
  }


  static Future<List<Task>> getTasksByOwner(String ownerId) async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'OWNER_ID = ? AND IS_DELETED = 0',
      whereArgs: [ownerId],
    );

    List<Task> tasks = [];
    for (var taskMap in result) {
      Task task = Task.fromMap(taskMap);
      try {
        task.attachments = await getAttachmentsByTask(task.id!);
      } catch (e) {
        print("[Local DB] Error fetching attachments for task ${task.id}: $e");
        task.attachments = [];
      }
      tasks.add(task);
    }

    print(
      "[Local DB] getTasksByOwner: ${tasks.length} tasks fetched with attachments",
    );
    return tasks;
  }

  static Future<List<Task>> getPublicTasks() async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'IS_SHARED = ? AND IS_DELETED = 0',
      whereArgs: [1],
    );

    List<Task> tasks = [];
    for (var taskMap in result) {
      Task task = Task.fromMap(taskMap);
      try {
        task.attachments = await getAttachmentsByTask(task.id!);
      } catch (e) {
        print("[Local DB] Error fetching attachments for task ${task.id}: $e");
        task.attachments = [];
      }
      tasks.add(task);
    }

    print(
      "[Local DB] getPublicTasks: ${tasks.length} tasks fetched with attachments",
    );
    return tasks;
  }

  static Future<List<Task>> getUnUploadedTasks(String uid) async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'UPLOAD_STATUS = ? AND OWNER_ID = ?',
      whereArgs: [0, uid],
    );

    List<Task> tasks = [];
    for (var taskMap in result) {
      Task task = Task.fromMap(taskMap);
      try {
        task.attachments = await getAttachmentsByTask(task.id!);
      } catch (e) {
        task.attachments = [];
      }
      tasks.add(task);
    }

    return tasks;
  }


  static Future<List<Task>?> getUpdatedTasks(String uid) async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'IS_UPDATED = ? AND OWNER_ID = ?',
      whereArgs: [1, uid],
    );

    List<Task> tasks = [];
    for (var taskMap in result) {
      Task task = Task.fromMap(taskMap);
      try {
        task.attachments = await getAttachmentsByTask(task.id!);
      } catch (e) {
        task.attachments = [];
      }
      tasks.add(task);
    }

    return tasks;
  }

  static Future<List<Task>?> getDeletedTasks(String uid) async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'IS_DELETED = ? AND OWNER_ID = ?',
      whereArgs: [1, uid],
    );

    List<Task> tasks = [];
    for (var taskMap in result) {
      Task task = Task.fromMap(taskMap);
      try {
        task.attachments = await getAttachmentsByTask(task.id!);
      } catch (e) {
        task.attachments = [];
      }
      tasks.add(task);
    }

    return tasks;
  }

  // ----------------- ATTACHMENTS -----------------
  static Future<int> insertAttachment({required Attachment attachment}) async {
    final db = await DBServices().database;
    return await db.insert(
      'ATTACHMENTS',
      await attachment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Attachment>> getAttachmentsByTask(int taskId) async {
    final db = await DBServices().database;
    final result = await db.query(
      'ATTACHMENTS',
      where: 'TASK_ID = ?',
      whereArgs: [taskId],
    );

    return result.map((e) => Attachment.fromMap(e)).toList();
  }
}
