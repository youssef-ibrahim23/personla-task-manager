
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';

import '../widgets/tabbed_tasks_widget.dart';
import '../widgets/task_stats_card.dart';
import '../widgets/weather_widget.dart';

class MobileLayout extends ConsumerWidget{

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final homeState = ref.watch(homeViewModelProvider);
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.02),
        WeatherWidget(
          weather: homeState.value?.weather,
          state: homeState.isLoading,
        ),
        SizedBox(height: screenHeight * 0.02),
        TabbedTasksWidget(
          myTasks: homeState.value?.myTasks ?? [],
          pendingTasks: homeState.value?.pendingTasks ?? [],
          publicTasks: homeState.value?.publicTasks,
          state: homeState.isLoading,
        ),
        SizedBox(height: screenHeight * 0.02),
        TaskStatsCard(
          myTasks: homeState.value?.myTasks ?? [],
          isLoading: homeState.isLoading,
        ),
      ],
    );
  }
}