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
    print("[DB] First-time initialization...");
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    print("[DB] Database path: $path");

    if (!await Directory(dbPath).exists()) {
      print("[DB] Creating database directory...");
      await Directory(dbPath).create(recursive: true);
    }

    print("[DB] Opening database...");
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    print("[DB] Creating USERS table...");
    await db.execute('''
      CREATE TABLE USERS (
        UID TEXT PRIMARY KEY,
        NAME TEXT NOT NULL,
        EMAIL TEXT NOT NULL UNIQUE,
        PASSWORD TEXT NOT NULL,
        PHONE_NUMBER TEXT NOT NULL,
        IMAGE_PATH TEXT
      );
    ''');
    print("[DB] USERS table created ✔");

    print("[DB] Creating TASKS table...");
    await db.execute('''
      CREATE TABLE TASKS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
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
    print("[DB] TASKS table created ✔");

    print("[DB] Creating ATTACHMENTS table...");
    await db.execute('''
      CREATE TABLE ATTACHMENTS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        TASK_ID TEXT NOT NULL,
        FILE_PATH TEXT NOT NULL,
        IS_DELETED INTEGER DEFAULT 0,
        UPLOAD_STATUS INTEGER DEFAULT 0,
        FOREIGN KEY (TASK_ID) REFERENCES TASKS(ID)
      );
    ''');
    print("[DB] ATTACHMENTS table created ✔");
  }

  Future<void> deleteDB() async {
    print("[DB] Deleting entire database...");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    await deleteDatabase(path);
    _database = null;

    print("[DB] Database deleted ✔");
  }

  // ----------------- USERS -----------------

  static Future<int> insertUser({required User user}) async {
    print("[DB] insertUser(): inserting user...");
    print("[DB] User data: ${user.toMap()}");

    final db = await DBServices().database;
    int result = await db.insert(
      'USERS',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print(result != 0
        ? "[DB] insertUser(): success ✔ (UID: ${user.uid})"
        : "[DB] insertUser(): failed ✖");

    return result;
  }

  static Future<User?> getUser(String uid) async {
    print("[DB] getUser(): searching for UID = $uid");

    final db = await DBServices().database;
    final result =
    await db.query('USERS', where: 'UID = ?', whereArgs: [uid]);

    if (result.isNotEmpty) {
      print("[DB] getUser(): user found ✔");
      return User.fromMap(result.first);
    } else {
      print("[DB] getUser(): user not found ✖");
      return null;
    }
  }

  static Future<User?> getUserByEmailAndPassword(LoginData data) async {
    print(
        "[DB] getUserByEmailAndPassword(): email=${data.email}, password=${data.password}");

    final db = await DBServices().database;
    final result = await db.query('USERS',
        where: 'EMAIL = ? AND PASSWORD = ?', whereArgs: [data.email, data.password]);

    if (result.isNotEmpty) {
      print("[DB] getUserByEmailAndPassword(): user found ✔");
      return User.fromMap(result.first);
    } else {
      print("[DB] getUserByEmailAndPassword(): incorrect credentials ✖");
      return null;
    }
  }

  // ----------------- TASKS -----------------

  static Future<int> insertTask({required Task task}) async {
    print("[DB] insertTask(): inserting task...");
    print("[DB] Task data: ${task.toMap()}");

    final db = await DBServices().database;
    final result = await db.insert(
      'TASKS',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("[DB] insertTask(): inserted ID = $result ✔");
    return result;
  }

  static Future<List<Task>> getTasksByOwner(String ownerId) async {
    print("[DB] getTasksByOwner(): ownerId = $ownerId");

    final db = await DBServices().database;
    final result =
    await db.query('TASKS', where: 'OWNER_ID = ?', whereArgs: [ownerId]);

    print("[DB] getTasksByOwner(): found ${result.length} tasks");

    return result.map((map) => Task.fromMap(map)).toList();
  }

  static Future<int> updateTaskStatus(String taskId, String status) async {
    print("[DB] updateTaskStatus(): taskId=$taskId, status=$status");

    final db = await DBServices().database;
    final result = await db.update(
      'TASKS',
      {'STATUS': status},
      where: 'ID = ?',
      whereArgs: [taskId],
    );

    print("[DB] updateTaskStatus(): updated rows = $result");
    return result;
  }

  static Future<int> deleteTask(String taskId) async {
    print("[DB] deleteTask(): marking task as deleted (ID=$taskId)");

    final db = await DBServices().database;
    final result = await db.update(
      'TASKS',
      {'IS_DELETED': 1},
      where: 'ID = ?',
      whereArgs: [taskId],
    );

    print("[DB] deleteTask(): rows updated = $result");
    return result;
  }

  // ----------------- ATTACHMENTS -----------------

  static Future<int> insertAttachment({required Attachment attachment}) async {
    print("[DB] insertAttachment(): inserting attachment...");
    print("[DB] Attachment data: ${attachment.toMap()}");

    final db = await DBServices().database;
    final result = await db.insert(
      'ATTACHMENTS',
      attachment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("[DB] insertAttachment(): inserted ID = $result ✔");
    return result;
  }

  static Future<List<Attachment>> getAttachmentsByTask(String taskId) async {
    print("[DB] getAttachmentsByTask(): taskId = $taskId");

    final db = await DBServices().database;
    final result = await db.query(
      'ATTACHMENTS',
      where: 'TASK_ID = ?',
      whereArgs: [taskId],
    );

    print("[DB] getAttachmentsByTask(): found ${result.length} attachments");

    return result.map((map) => Attachment.fromMap(map)).toList();
  }
}
