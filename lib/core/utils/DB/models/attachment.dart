import 'dart:io';

import '../../helpers.dart';

class Attachment {
  int? id;
  int? taskId;
  String image; // can be local path or base64 string

  Attachment({this.id, this.taskId, required this.image});

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['ID'],
      taskId: map['TASK_ID'],
      image: map['IMAGE'] ?? '',
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    String? imageData = image;

    if ((image.startsWith('/') || image.contains(Platform.pathSeparator)) &&
        File(image).existsSync()) {
      imageData = await Helpers.imageToBase64(File(image));
    }

    return {'ID': id, 'TASK_ID': taskId, 'IMAGE': imageData};
  }

  bool get isBase64 => image.startsWith(RegExp(r'^[A-Za-z0-9+/=]+$'));
}
