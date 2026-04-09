import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';

import '../widgets/tabbed_tasks_widget.dart';
import '../widgets/task_stats_card.dart';
import '../widgets/weather_widget.dart';

class TabletLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final homeState = ref.watch(homeViewModelProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          WeatherWidget(
            weather: homeState.value?.weather,
            state: homeState.isLoading,
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: screenHeight * 0.7, // Set a fixed height or use constraints
            child: GridView(
              physics: NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 1.3,
              ),
              padding: EdgeInsets.all(16.0),
              children: [
                TabbedTasksWidget(
                  myTasks: homeState.value?.myTasks ?? [],
                  pendingTasks: homeState.value?.pendingTasks ?? [],
                  publicTasks: homeState.value?.publicTasks,
                  state: homeState.isLoading,
                ),
                TaskStatsCard(
                  myTasks: homeState.value?.myTasks ?? [],
                  isLoading: homeState.isLoading,
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}