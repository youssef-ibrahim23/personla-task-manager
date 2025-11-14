class Task {
  String? id;
  String ownerId;
  String title;
  String? description;
  String? dueDate;
  String priority;
  String status;
  String? createdAt;
  bool isDeleted;
  bool uploadStatus;
  bool isShared;

  Task({
    this.id,
    required this.ownerId,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    this.createdAt,
    this.isDeleted = false,
    this.uploadStatus = false,
    this.isShared = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['ID']?.toString(),
      ownerId: map['OWNER_ID'],
      title: map['TITLE'],
      description: map['DESCRIPTION'],
      dueDate: map['DUE_DATE'],
      priority: map['PRIORITY'],
      status: map['STATUS'],
      createdAt: map['CREATED_AT'],
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
      'DUE_DATE': dueDate,
      'PRIORITY': priority,
      'STATUS': status,
      'CREATED_AT': createdAt,
      'IS_DELETED': isDeleted ? 1 : 0,
      'UPLOAD_STATUS': uploadStatus ? 1 : 0,
      'IS_SHARED': isShared ? 1 : 0,
    };
  }
}
