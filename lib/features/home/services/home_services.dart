import 'package:personal_task/core/network/api_services.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/DB/models/Weather.dart';

class HomeServices {
  static Future<Weather?> getWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(AppStrings.prefLanguage) ?? 'en';
      if (await Helpers.isConnectedToInternet()) {
        String? country = await Helpers.getCountryUsingGPS();
        country ??= "Cairo";

        final response = await APIServices().get(
          endPoint: "https://api.weatherapi.com/v1/current.json",
          queryParameters: {
            'key': "53835f94cc41454aa90192103251311",
            'q': country,
            'lang': languageCode,
          },
        );

        Weather weather = Weather.fromJson(response);

        await DBServices.insertWeather(response);

        return weather;
      } else {
        print('No internet → return last saved weather');

        Map<String, dynamic>? lastWeather = await DBServices.getLastWeather();

        if (lastWeather != null) {
          return Weather.fromJson(lastWeather);
        } else {
          return null;
        }
      }
    } catch (e) {
      print('Weather fetch error: $e');
      return null;
    }
  }

  static Future<List<Task>?> getMyTasks() async {
    final uid = await Helpers.getUID();
    try {
      if (uid == null) return null;
        return DBServices.getTasksByOwner(uid);

    } catch (e) {
      print('Get my tasks error: $e');
      return null;
    }
  }

  static Future<List<Task>?> getPublicTasks() async {
    try {
      if (await Helpers.isConnectedToInternet()) {
        List<Task>? tasks = await FireStoreServices().getPublicTasks();
        if (tasks != null) {
          for (Task task in tasks) {
            if(task.ownerId != await Helpers.getUID()) {
              await DBServices.insertTask(task: task);
              if (task.attachments != null && task.attachments!.isNotEmpty) {
                for (int i = 0; i < task.attachments!.length; i++) {
                  task.attachments![i].taskId = task.id;
                  task.attachments![i].id = await DBServices.insertAttachment(
                    attachment: task.attachments![i],
                  );
                }
              }
            }
          }
        }
        return tasks;
      } else {
        return null;
      }
    } catch (e) {
      print('Get public tasks error: $e');
      return null;
    }
  }

  static Future<List<Task>?> getPendingTasks() async {
    final uid = await Helpers.getUID();
    try {
      if (uid == null) return null;
      return DBServices.getPendingTasks(uid);
    } catch (e) {
      print('Get pending tasks error: $e');
      return null;
    }
  }

  static Future<int> deleteTask(int taskId) async {
    try {

      
      if (await Helpers.isConnectedToInternet()) {
        DBServices.deleteTask(taskId);
        FireStoreServices().deleteTask(taskId: taskId.toString());
        return 1;
      } else {
        DBServices.toggleTaskIsDeleted(taskId: taskId, isDeleted: 1);
        return 1;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
