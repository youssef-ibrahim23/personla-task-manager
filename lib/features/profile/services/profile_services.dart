import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import '../../../core/utils/DB/models/user.dart';

class ProfileServices {
  static Future<User?> getProfileData() async {
    try {
      final uid = await Helpers.getUID();
      if (uid == null) return null;

      if(await Helpers.isConnectedToInternet()){
        return await FireStoreServices().getUser(uid);
      }else{
        return await DBServices.getUser(uid);
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      return null;
    }
  }
  static Future<bool> sendRestPasswordEmail(String email) async {
    try {
      if(await Helpers.isConnectedToInternet()){
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return true;
      } else{
        throw Exception("No internet connection. Cannot send password reset email.");
      }
    } catch (e) {
      print("Error sending password reset email: $e");
      throw Exception("Failed to send password reset email");
    }
  }
  static Future<void> updateProfile({required User user}) async {
    try {
      if(await Helpers.isConnectedToInternet()){
        await FireStoreServices().updateUser(user: user);
        await DBServices.updateUser(user: user);
        print("Profile updated for user: ${user.uid}");
      } else{
        throw Exception("No internet connection. Cannot update profile.");
      }
    } catch (e) {
      print("Error updating profile: $e");
      throw Exception("Failed to update profile");
    }
  }
}
