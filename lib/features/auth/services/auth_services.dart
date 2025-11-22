import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';

import '../../../core/utils/DB/db_services.dart';
import '../data/login_data.dart';
import '../../../core/utils/DB/models/user.dart';

class AuthServices {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential?> signIn(LoginData data) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: data.email!,
        password: data.password!,
      );

      if (credential.user == null) return null;

      Helpers.saveUID(credential.user!.uid);

      await Helpers.toggleLoginState();

      return credential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<UserCredential?> register(User user) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      user.uid = credential.user!.uid;

      user.image = await Helpers.imageToBase64(File(user.image!));

      await DBServices.insertUser(user: user);

      await FireStoreServices().uploadUser(user: user);

      await credential.user!.sendEmailVerification();

      return credential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      rethrow;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
