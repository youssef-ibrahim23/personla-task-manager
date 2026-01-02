import 'package:flutter/material.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';

class TaskStatsCard extends StatelessWidget {
  final List<Task>? myTasks;
  final List<Task>? pendingTasks;
  final List<Task>? publicTasks;
  final bool isLoading;

  const TaskStatsCard({
    super.key,
    required this.myTasks,
    this.pendingTasks,
    this.publicTasks,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return Container(
        width: screenWidth * 0.95,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const TasksShimmer(length: 1),
      );
    }

    // Calculate statistics
    final allTasks = [
      ...(myTasks ?? []),
      ...(pendingTasks ?? []),
      ...(publicTasks ?? []),
    ];

    final totalTasks = allTasks.length;
    final completedTasks = allTasks
        .where((task) => task.endDate.isBefore(DateTime.now()))
        .length;
    final notCompletedTasks = totalTasks - completedTasks;
    final highPriorityTasks = allTasks
        .where((task) => task.priority.toLowerCase().contains('high'))
        .length;
    final completionPercentage = totalTasks > 0
        ? ((completedTasks / totalTasks) * 100).toInt()
        : 0;

    return Container(
      width: screenWidth * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.task_statistics,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        fontFamily: 'Rakkas-Regular',
                      ),
                    ),
                    Text(
                      localizations.overview_of_your_tasks,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatItem(
                context,
                localizations.total_tasks,
                totalTasks.toString(),
                Icons.format_list_bulleted_rounded,
                Colors.blue.shade500,
                theme,
              ),
              _buildStatItem(
                context,
                localizations.completed,
                completedTasks.toString(),
                Icons.check_circle_rounded,
                Colors.green.shade500,
                theme,
              ),
              _buildStatItem(
                context,
                localizations.not_completed,
                notCompletedTasks.toString(),
                Icons.pending_actions_rounded,
                Colors.orange.shade500,
                theme,
              ),
              _buildStatItem(
                context,
                localizations.high_priority,
                highPriorityTasks.toString(),
                Icons.priority_high_rounded,
                Colors.red.shade500,
                theme,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.completion_progress,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '$completionPercentage%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        fontFamily: 'Rakkas-Regular',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  fontFamily: 'Rakkas-Regular',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.primary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

