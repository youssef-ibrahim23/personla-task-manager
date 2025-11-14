import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';

import '../data/login_data.dart';
import '../../../core/utils/DB/models/user.dart';

class AuthServices {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential?> signIn(LoginData data) async {
    try {
      UserCredential? userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
            email: data.email!,
            password: data.password!,
          );
      if(userCredential.user!.uid != null){
        print('user logged in: ${userCredential.user!.uid}');
        await Helpers.saveUID(userCredential.user!.uid);
        await Helpers.toggleLoginState();
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> register(User user) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );
      if(userCredential.user!.uid != null){
        Future.wait([
         Helpers.saveUID(userCredential.user!.uid),
         DBServices.insertUser(user: user),
         Helpers.toggleLoginState(),
        ]);
        if(await Helpers.isConnectedToInternet()){
          FireStoreServices().uploadUser(user: user);
        }
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
