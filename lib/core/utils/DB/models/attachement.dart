class Attachment{
  String? id;
  String taskId;
  String filePath;

  Attachment({
    this.id,
    required this.taskId,
    required this.filePath,
  });

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['ID']?.toString(),
      taskId: map['TASK_ID'],
      filePath: map['FILE_PATH'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'TASK_ID': taskId,
      'FILE_PATH': filePath,
    };
  }
}
