import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:local_auth/local_auth.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/DB/db_services.dart';
import '../data/login_data.dart';
import '../../../core/utils/DB/models/user.dart';

class AuthServices {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential?> signIn(LoginData data) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      if (credential.user == null) return null;

      print(credential.user!.uid);

      Helpers.saveUID(credential.user!.uid);

      await Helpers.toggleLoginState(true);

      return credential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<UserCredential?> register(User user) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      credential.user?.updateDisplayName(user.name);

      user.uid = credential.user!.uid;

      if (user.image != null) {
        user.image = await Helpers.imageToBase64(File(user.image!));
      }

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

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      print(userCredential.user!.uid);
      Future.wait([
        Helpers.toggleLoginState(true),
        Helpers.saveUID(userCredential.user!.uid),
        Helpers.saveString('email', googleUser.email),
        Helpers.saveString('name', googleUser.displayName ?? 'No name'),
        Helpers.saveString('photo', googleUser.photoUrl ?? ''),
        Helpers.saveBool('isGoogle', true)
      ]);

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  static Future<void> toggleBiometricAvailability(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricEnabled', status);
    print('status toggled to : $status');
  }

  static Future<bool> isBiometricEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isBiometricEnabled') ?? false;
  }

  static Future<bool> canUseBiometric() async {
    final canCheck = await LocalAuthentication().canCheckBiometrics;
    final isSupported = await LocalAuthentication().isDeviceSupported();
    return canCheck && isSupported;
  }

  static Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      GoogleSignIn().signOut();
      await Helpers.toggleLoginState(false);
      return true;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }
}
