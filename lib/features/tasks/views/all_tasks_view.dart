import 'package:flutter/material.dart';
import 'package:personal_task/core/shared/task/task_item.dart';

import '../../../core/utils/DB/models/task.dart';

class AllTasksView extends StatelessWidget {
  List<Task>? tasks;

  String title;

  AllTasksView({super.key, required this.tasks, this.title = 'My Tasks'});

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.09,
        automaticallyImplyLeading: true,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontFamily: 'Luckiest Guy',
          ),
        ),
      ),
      body: ListView.builder(

        itemCount: tasks?.length,
        itemBuilder: (context, index) {
          final task = tasks?[index];
          return  TaskItem(task: task!);
        },
      ),
    );
  }
}
