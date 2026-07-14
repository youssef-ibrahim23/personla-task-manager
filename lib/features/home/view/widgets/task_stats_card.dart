import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    // Calculate statistics (cached for performance)
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
        ? (completedTasks / totalTasks).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: screenWidth * 0.95,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.primaryContainer.withOpacity(0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.15),
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? const _StatsCardShimmer()
                  : _buildContent(
                context,
                totalTasks,
                completedTasks,
                notCompletedTasks,
                highPriorityTasks,
                completionPercentage,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      int totalTasks,
      int completedTasks,
      int notCompletedTasks,
      int highPriorityTasks,
      double completionPercentage,
      ) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    if (totalTasks == 0) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with improved spacing
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.task_statistics,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    localizations.overview_of_your_tasks,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Stats Grid with improved aspect ratio
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _AnimatedStatItem(
              label: localizations.total_tasks,
              value: totalTasks.toDouble(),
              icon: Icons.format_list_bulleted_rounded,
              color: Colors.blue.shade500,
              theme: theme,
            ),
            _AnimatedStatItem(
              label: localizations.completed,
              value: completedTasks.toDouble(),
              icon: Icons.check_circle_rounded,
              color: Colors.green.shade500,
              theme: theme,
            ),
            _AnimatedStatItem(
              label: localizations.not_completed,
              value: notCompletedTasks.toDouble(),
              icon: Icons.pending_actions_rounded,
              color: Colors.orange.shade500,
              theme: theme,
            ),
            _AnimatedStatItem(
              label: localizations.high_priority,
              value: highPriorityTasks.toDouble(),
              icon: Icons.priority_high_rounded,
              color: Colors.red.shade500,
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Radial Completion Overview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Radial chart
              SizedBox(
                width: 90,
                height: 90,
                child: _AnimatedRadialProgress(
                  percentage: completionPercentage,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 20),
              // Text stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.completion_progress,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '$completedTasks',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                              fontFamily: 'Rakkas-Regular',
                            ),
                          ),
                          TextSpan(
                            text: ' / $totalTasks ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          TextSpan(
                            text: localizations.tasks_completed,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.primary.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.no_tasks_available,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.tasks_will_appear_here,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Animated stat item with tap ripple and smooth value transitions
class _AnimatedStatItem extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _AnimatedStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Provide haptic feedback on tap
          HapticFeedback.lightImpact();
          // You can add navigation or filter logic here
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.25),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 22),
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: value),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedValue, child) {
                      return Text(
                        animatedValue.toInt().toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          fontFamily: 'Rakkas-Regular',
                          fontSize: 26,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary.withOpacity(0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated radial progress indicator
class _AnimatedRadialProgress extends StatelessWidget {
  final double percentage;
  final Color color;

  const _AnimatedRadialProgress({
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: percentage),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                value: animatedValue,
                strokeWidth: 8,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${(animatedValue * 100).toInt()}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Rakkas-Regular',
              ),
            ),
          ],
        );
      },
    );
  }
}

// Accurate shimmer placeholder matching the stats card layout
class _StatsCardShimmer extends StatelessWidget {
  const _StatsCardShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header shimmer
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 20,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 14,
                    color: theme.colorScheme.primary.withOpacity(0.08),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Grid shimmer (2x2)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: List.generate(4, (_) => _ShimmerGridItem()),
        ),
        const SizedBox(height: 24),
        // Radial shimmer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 80,
                      height: 28,
                      color: theme.colorScheme.primary.withOpacity(0.08),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShimmerGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 26,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 12,
            color: theme.colorScheme.primary.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}