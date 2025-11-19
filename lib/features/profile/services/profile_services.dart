import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/helpers.dart';

import '../../../core/utils/DB/models/user.dart';

class ProfileServices {
  static Future<User?> getProfileData() async {
    try {
      final uid = await Helpers.getUID();
      print("UID = $uid");
      final user = await DBServices.getUser(uid!);
      return user;
    } catch (e) {
      return null;
    }
  }
}

