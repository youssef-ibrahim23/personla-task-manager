import 'package:personal_task/core/utils/DB/models/attachment.dart';

class Task {
  int? id;
  String? ownerId;
  String title;
  String description;
  String category;
  DateTime startDate;
  DateTime endDate;
  String priority;
  String? status;
  DateTime? reminder;
  bool? isUpdated;
  bool isDeleted;
  bool uploadStatus;
  bool isShared;
  List<Attachment>? attachments;

  Task({
    this.id,
    this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.endDate,
    required this.priority,
    this.status = 'In Progress',
    required this.startDate,
    DateTime? reminder,
    this.isUpdated = false,
    this.isDeleted = false,
    this.uploadStatus = false,
    this.isShared = false,
    this.attachments,
  }) : reminder = reminder ?? endDate.subtract(Duration(days: 1));

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['ID'] ?? 0,
      ownerId: map['OWNER_ID'] ?? '',
      title: map['TITLE'] ?? '',
      description: map['DESCRIPTION'] ?? '',
      category: map['CATEGORY'] ?? 'Personal',
      endDate: DateTime.parse(map['END_DATE']),
      priority: map['PRIORITY'] ?? 'Low',
      status: map['STATUS'] ?? 'In Progress',
      startDate: map['START_DATE'] != null
          ? DateTime.parse(map['START_DATE'])
          : DateTime.now(),
      reminder: DateTime.parse(map['REMINDER_DATE']),
      isUpdated: map['IS_UPDATED'] == 1,
      isDeleted: map['IS_DELETED'] == 1,
      uploadStatus: map['UPLOAD_STATUS'] == 1,
      isShared: map['IS_SHARED'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'OWNER_ID': ownerId,
      'TITLE': title,
      'DESCRIPTION': description,
      'CATEGORY': category,
      'END_DATE': endDate.toIso8601String(),
      'PRIORITY': priority,
      'STATUS': status ?? 'In Progress',
      'START_DATE': startDate.toIso8601String(),
      'REMINDER_DATE': reminder?.toIso8601String(),
      'IS_UPDATED': isUpdated == true ? 1 : 0,
      'IS_DELETED': isDeleted ? 1 : 0,
      'UPLOAD_STATUS': uploadStatus ? 1 : 0,
      'IS_SHARED': isShared ? 1 : 0,
    };
  }
}
