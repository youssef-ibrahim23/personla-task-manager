import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/localization/locale_provider.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';
import 'package:personal_task/features/home/view/widgets/tabbed_tasks_widget.dart';
import 'package:personal_task/features/home/view/widgets/weather_widget.dart';
import 'package:personal_task/features/home/view/widgets/task_stats_card.dart';
import 'package:personal_task/features/tasks/views/task_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context)!;

    final homeState = ref.watch(homeViewModelProvider);

    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        title: Text(
          localizations.home,
          style: const TextStyle(color: AppColors.light, fontSize: 45),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(homeViewModelProvider.notifier).getHomeData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskView()),
              ) ??
              false;

          if (result) {
            ref.read(homeViewModelProvider.notifier).getHomeData();
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.add_task_sharp, color: AppColors.primary),
      ),
    ).animate().moveX(begin: isArabic ? -100 : 100, end: 0, duration: 500.ms);
  }
}
