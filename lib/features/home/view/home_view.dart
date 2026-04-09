import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/localization/locale_provider.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';
import 'package:personal_task/features/home/view/layouts/mobile_layout.dart';
import 'package:personal_task/features/home/view/layouts/tablet_layout.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth < 1281;

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
          child: isMobile
              ? MobileLayout()
              : isTablet
              ? TabletLayout()
              : null,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskView()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.add_task_sharp, color: AppColors.primary),
      ),
    ).animate().moveX(begin: isArabic ? -100 : 100, end: 0, duration: 500.ms);
  }
}
