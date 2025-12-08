import 'package:personal_task/core/utils/DB/models/Weather.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';

class HomeModel {
   List<Task> myTasks;
   List<Task> publicTasks;
   Weather? weather;

  HomeModel({
    this.myTasks = const [],
    this.publicTasks = const [],
    this.weather
  });

  HomeModel copyWith({
    List<Task>? myTasks,
    List<Task>? publicTasks,
  }) {
    return HomeModel(
      myTasks: myTasks ?? this.myTasks,
      publicTasks: publicTasks ?? this.publicTasks,
    );
  }
}
