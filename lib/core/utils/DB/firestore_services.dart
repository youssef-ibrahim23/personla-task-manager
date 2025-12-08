import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_task/core/utils/DB/models/attachment.dart';

import 'models/task.dart';
import 'models/user.dart';

class FireStoreServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadUser({required User user}) async {
    print("[FireStore] uploadUser(): uploading user...");
    print("[FireStore] User data: ${user.toMap()}");

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());

      print("[FireStore] uploadUser(): success");
    } catch (e) {
      print("[FireStore] uploadUser(): error -> $e");
    }
  }

  Future<void> updateUser({required User user}) async {
    print("[FireStore] updateUser(): updating user...");
    print("[FireStore] User UID: ${user.uid}");

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid.toString())
          .update(user.toMap());

      print("[FireStore] updateUser(): success");
    } catch (e) {
      print("[FireStore] updateUser(): error -> $e");
    }
  }

  Future<User?> getUser(String uid) async {
    print("[FireStore] getUser(): fetching user with UID=$uid");
    try {
      final doc = await firebaseFirestore.collection('users').doc(uid).get();
      if (doc.exists) {
        print("[FireStore] getUser(): success");
        final data = doc.data()!;
        return User(
          uid: uid,
          name: data['NAME'],
          email: data['EMAIL'],
          phoneNumber: data['PHONE_NUMBER'],
          password: data['PASSWORD'],
          image: data['IMAGE'],
        );
      }
      return null;
    } catch (e) {
      print("[FireStore] getUser(): error -> $e");
      return null;
    }
  }

  Future<void> uploadTask({required Task task}) async {
    print("[FireStore] uploadTask(): uploading task...");
    print("[FireStore] Task data: ${task.toMap()}");

    try {
      await firebaseFirestore
          .collection('tasks')
          .doc(task.id.toString())
          .set(task.toMap());

      if (task.attachments != null && task.attachments!.isNotEmpty) {
        for (Attachment attachment in task.attachments!) {
          attachment.taskId = task.id;

          await firebaseFirestore
              .collection('tasks')
              .doc(task.id.toString())
              .collection('attachments')
              .doc(attachment.id.toString())
              .set(await attachment.toMap());
        }
      }

      print("[FireStore] uploadTask(): success (ID=${task.id})");
    } catch (e) {
      print("[FireStore] uploadTask(): error -> $e");
    }
  }

  Future<void> updateTask({required Task task}) async {
    print("[FireStore] updateTask(): updating task...");
    print("[FireStore] Task ID: ${task.id}");

    try {
      print(task.id);
      await firebaseFirestore
          .collection('tasks')
          .doc(task.id.toString())
          .update(task.toMap());

      if (task.attachments != null && task.attachments!.isNotEmpty) {
        for (Attachment attachment in task.attachments!) {
          await firebaseFirestore
              .collection('tasks')
              .doc(task.id.toString())
              .collection('attachments')
              .doc(attachment.id.toString())
              .set(await attachment.toMap());
          print('[FireStore] update attachments');
        }

        print("[FireStore] updateTask(): success");
      }
    } catch (e) {
      print("[FireStore] updateTask(): error -> $e");
    }
  }

  Future<List<Task>?> getTasksByOwner({required String uid}) async {
    print("[FireStore] getTasksByOwner(): get tasks by owner (ID=$uid)");

    try {
      QuerySnapshot snapshot = await firebaseFirestore
          .collection('tasks')
          .where('OWNER_ID', isEqualTo: uid)
          .get();

      List<Task> tasks = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        Task task = Task.fromMap(data);

        QuerySnapshot attachmentSnapshot = await firebaseFirestore
            .collection('tasks')
            .doc(doc.id)
            .collection('attachments')
            .get();

        List<Attachment> attachments = attachmentSnapshot.docs
            .map((a) => Attachment.fromMap(a.data() as Map<String, dynamic>))
            .toList();

        task.attachments = attachments;

        tasks.add(task);
      }

      print(
        '[FireStore] getTasksByOwner(): success, found ${tasks.length} tasks',
      );
      print(tasks);
      return tasks;
    } catch (e) {
      print('[FireStore] getTasksByOwner(): error: $e');
      return null;
    }
  }

  Future<List<Task>?> getPublicTasks() async {
    print('[FireStore] getPublicTasks: work');

    try {
      QuerySnapshot snapshot = await firebaseFirestore
          .collection('tasks')
          .where('IS_SHARED', isNotEqualTo: 0)
          .get();

      List<Task> tasks = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final taskId = doc.id;

        List<Attachment> attachments = [];
        try {
          final attSnap = await firebaseFirestore
              .collection('tasks')
              .doc(taskId)
              .collection('attachments')
              .get();

          attachments = attSnap.docs
              .map(
                (attDoc) =>
                    Attachment.fromMap(attDoc.data()),
              )
              .toList();
          print(attachments.first);
        } catch (e) {
          print('[FireStore] attachments error for task $taskId: $e');
        }

        final task = Task.fromMap(data);
        task.attachments = attachments;
        print(task);
        tasks.add(task);
      }

      print('[FireStore] getPublicTasks: success , ${tasks.length}');
      return tasks;
    } catch (e) {
      print("[Firestore] getPublicTasks error: $e");
      return null;
    }
  }

  Future<void> deleteTask({required String taskId}) async {
    print("[FireStore] deleteTask(): deleting task (ID=$taskId)");

    try {
      await firebaseFirestore.collection('tasks').doc(taskId).delete();
      print("[FireStore] deleteTask(): success");
    } catch (e) {
      print("[FireStore] deleteTask(): error -> $e");
    }
  }

  Future<void> uploadTasks({required List<Task> tasks}) async {
    print("[FireStore] uploadTasks(): count = ${tasks.length}");

    for (Task task in tasks) {
      try {
        await uploadTask(task: task);
      } catch (e) {
        print(
          "[FireStore] uploadTasks(): failed to upload task ${task.id} -> $e",
        );
      }
    }
  }

  Future<void> deleteTasks({required List<int> taskIds}) async {
    print("[FireStore] deleteTasks(): count = ${taskIds.length}");

    for (int taskId in taskIds) {
      try {
        await deleteTask(taskId: taskId.toString());
      } catch (e) {
        print("[FireStore] deleteTasks(): failed to delete $taskId -> $e");
      }
    }
  }

  Future<void> uploadAttachment({required Attachment attachment}) async {
    print("[FireStore] uploadAttachment(): uploading attachment...");
    print("[FireStore] Attachment data: ${attachment.toMap()}");

    try {
      await firebaseFirestore
          .collection('attachments')
          .doc(attachment.id.toString())
          .set(await attachment.toMap());

      print("[FireStore] uploadAttachment(): success (ID=${attachment.id})");
    } catch (e) {
      print("[FireStore] uploadAttachment(): error -> $e");
    }
  }

  Future<void> uploadAttachments({
    required List<Attachment> attachments,
  }) async {
    print("[FireStore] uploadAttachments(): count = ${attachments.length}");

    for (Attachment attachment in attachments) {
      try {
        await uploadAttachment(attachment: attachment);
      } catch (e) {
        print(
          "[FireStore] uploadAttachments(): failed (ID=${attachment.id}) -> $e",
        );
      }
    }
  }
}
