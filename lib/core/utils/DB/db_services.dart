import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/attachement.dart';
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
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName); // استخدام join من path package

    if (!await Directory(dbPath).exists()) {
      await Directory(dbPath).create(recursive: true);
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE USERS (
        UID TEXT PRIMARY KEY AUTOINCREMENT,
        NAME TEXT NOT NULL,
        EMAIL TEXT NOT NULL UNIQUE,
        PHONE_NUMBER TEXT NOT NULL,
        IMAGE_PATH TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE TASKS (
        ID TEXT PRIMARY KEY AUTOINCREMENT,
        OWNER_ID TEXT NOT NULL,
        TITLE TEXT NOT NULL,
        DESCRIPTION TEXT,
        PRIORITY TEXT NOT NULL CHECK (PRIORITY IN ('Low', 'Medium', 'High')),
        STATUS TEXT NOT NULL CHECK (STATUS IN ('In Progress', 'Completed')),
        CREATED_AT TEXT DEFAULT CURRENT_TIMESTAMP,
        END_DATE TEXT,
        IS_UPDATED INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SHARED INTEGER DEFAULT 0,
        UPLOAD_STATUS INTEGER DEFAULT 0,
        FOREIGN KEY (OWNER_ID) REFERENCES USERS(UID)
      );
    ''');

    await db.execute('''
      CREATE TABLE ATTACHMENTS (
        ID TEXT PRIMARY KEY AUTOINCREMENT,
        TASK_ID TEXT NOT NULL,
        FILE_PATH TEXT NOT NULL,
        IS_DELETED INTEGER DEFAULT 0,
        UPLOAD_STATUS INTEGER DEFAULT 0,
        FOREIGN KEY (TASK_ID) REFERENCES TASKS(ID)
      );
    ''');
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    await deleteDatabase(path);
    _database = null;
  }

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
    final result = await db.query('USERS', where: 'UID = ?', whereArgs: [uid]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  static Future<int> insertTask({required Task task}) async {
    final db = await DBServices().database;
    return await db.insert(
      'TASKS',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getTasksByOwner(String ownerId) async {
    final db = await DBServices().database;
    final result = await db.query(
      'TASKS',
      where: 'OWNER_ID = ?',
      whereArgs: [ownerId],
    );
    return result.map((map) => Task.fromMap(map)).toList();
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

  static Future<int> deleteTask(String taskId) async {
    final db = await DBServices().database;
    return await db.update(
      'TASKS',
      {'IS_DELETED': 1},
      where: 'ID = ?',
      whereArgs: [taskId],
    );
  }

  static Future<int> insertAttachment({required Attachment attachment}) async {
    final db = await DBServices().database;
    return await db.insert(
      'ATTACHMENTS',
      attachment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Attachment>> getAttachmentsByTask(String taskId) async {
    final db = await DBServices().database;
    final result = await db.query(
      'ATTACHMENTS',
      where: 'TASK_ID = ?',
      whereArgs: [taskId],
    );
    return result.map((map) => Attachment.fromMap(map)).toList();
  }
}
