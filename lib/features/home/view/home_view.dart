import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';
import 'package:personal_task/features/home/view/widgets/my_tasks_widget.dart';
import 'package:personal_task/features/home/view/widgets/public_tasks_widget.dart';
import 'package:personal_task/features/home/view/widgets/weather_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final homeState = ref.watch(homeViewModelProvider);

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(homeViewModelProvider.notifier).getHomeData(true);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.1,
          backgroundColor: AppColors.primary,
          title: Text(
            AppLocalizations.of(context)!.home,
            style: TextStyle(
              color: AppColors.light,
              fontSize: 45,
              fontFamily: AppStrings.primaryFont,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              WeatherWidget(
                weather: homeState.value?.weather,
                state: homeState.isLoading,
              ),
              SizedBox(height: screenHeight * 0.02),
              MyTasksWidget(
                tasks: homeState.value?.myTasks ?? [],
                state: homeState.isLoading,
              ),
              SizedBox(height: screenHeight * 0.03),
              PublicTasksWidget(
                tasks: homeState.value?.publicTasks ?? [],
                state: homeState.isLoading,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskView()),
            );

            if (result == true) {
              ref.read(homeViewModelProvider.notifier).getHomeData(true);
            }
          },
          backgroundColor: AppColors.light,
          child: Icon(Icons.add_task_sharp, color: AppColors.primary),
        ).animate().moveX(begin: 100, end: 0, duration: 500.ms),
      ),
    );
  }
}
