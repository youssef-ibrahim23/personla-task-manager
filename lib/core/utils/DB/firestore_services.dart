import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:personal_task/core/utils/DB/models/attachment.dart';
import 'package:personal_task/core/utils/helpers.dart';

import 'models/task.dart';
import 'models/user.dart';

class FireStoreServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadUser({required User user}) async {
    try {
      await firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(user.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> updateUser({required User user}) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid.toString())
          .update({
            'name': user.name,
            'email': user.email,
            'uid': user.uid,
            'phone': user.phoneNumber,
            'image': Helpers.imageToBase64(File(user.image!.path)),
          });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> uploadTask({required Task task}) async {
    try {
      await firebaseFirestore.collection('tasks').doc(task.id.toString()).set({
        'title': task.title,
        'description': task.description,
        'Priority': task.priority,
        'status': task.status,
        'createdAt': task.createdAt,
        'endDate': task.dueDate,
        'isShared': task.isShared,
        'ownerId': task.ownerId,
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> updateTask({required Task task}) async {
    try {
      await firebaseFirestore.collection('tasks').doc(task.id.toString()).update({
        'title': task.title,
        'description': task.description,
        'Priority': task.priority,
        'status': task.status,
        'createdAt': task.createdAt,
        'endDate': task.dueDate,
        'isShared': task.isShared,
        'ownerId': task.ownerId,
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    try {
      await firebaseFirestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> uploadTasks({required List<Task> tasks}) async {
    for (Task task in tasks) {
      try {
        await uploadTask(task: task);
      } catch (e) {
        print('Failed to upload task ${task.id}: $e');
      }
    }
  }

  Future<void> deleteTasks({required List<int> taskIds}) async {
    for (int taskId in taskIds) {
      try {
        await deleteTask(taskId: taskId.toString());
      } catch (e) {
        print('Failed to delete task $taskId: $e');
      }
    }
  }

  Future<void> uploadAttachment({required Attachment attachment}) async {
    try {
      await firebaseFirestore.collection('attachments').doc(attachment.id.toString()).set({
        'taskId': attachment.taskId,
        'filePath': attachment.filePath,
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> uploadAttachments({
    required List<Attachment> attachments,
  }) async {
    for (Attachment attachment in attachments) {
      try {
        uploadAttachment(attachment: attachment);
      } catch (e) {
        print(e);
      }
    }
  }
}
