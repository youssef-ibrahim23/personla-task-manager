// ============================
// task_list.dart (enhanced)
// ============================
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/task/task_item.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/localization/locale_provider.dart';
import 'package:personal_task/features/tasks/views/all_tasks_view.dart';

class TaskList extends ConsumerWidget {
  final List<Task> tasks;
  final String title;
  final bool isLoading;

  const TaskList({
    super.key,
    required this.tasks,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider).languageCode;

    if (isLoading) {
      return const TasksShimmer();
    }

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              localizations.no_tasks_found,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.start_by_creating_task,
              style: TextStyle(fontSize: 13, color: theme.colorScheme.primary.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/add-task'),
              icon: const Icon(Icons.add),
              label: Text(localizations.add_task),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      );
    }

    final displayTasks = tasks.length > 4 ? tasks.sublist(0, 4) : tasks;

    return Column(
      children: [
        _buildHeader(context, theme, localizations, locale, tasks.length),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: displayTasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildAnimatedItem(displayTasks[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedItem(Task task, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      builder: (context, double value, child) {
        return Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child));
      },
      child: TaskItem(task: task),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, AppLocalizations localizations, String locale, int totalCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.03),
        border: Border(bottom: BorderSide(color: theme.colorScheme.primary.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 24, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.colorScheme.primary)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  locale == 'ar' ? Helpers.toArabicNumber(totalCount.toString()) : totalCount.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllTasksView(tasks: tasks, title: title))),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(localizations.see_all, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}