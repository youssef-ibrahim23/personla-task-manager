import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/shared/task/task_item.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/features/tasks/views/all_tasks_view.dart';

class MyTasksWidget extends StatelessWidget {
  final List<Task>? tasks;
  final bool state;

  const MyTasksWidget({super.key, required this.tasks, this.state = false});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'My Tasks',
                    style: TextStyle(
                      fontFamily: 'Luckiest Guy',
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      tasks?.length.toString() ?? '0',
                      style: TextStyle(
                        fontFamily: 'Luckiest Guy',
                        color: AppColors.light,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllTasksView(tasks: tasks)));
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Luckiest Guy',
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          state
              ? TasksShimmer()
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks!.length > 4
                ? 4
                : tasks?.length,
            itemBuilder: (context, index) {
              final task = tasks![index];
              return TaskItem(task: task,);
            },
          ),
        ],
      ),
    );
  }
}
