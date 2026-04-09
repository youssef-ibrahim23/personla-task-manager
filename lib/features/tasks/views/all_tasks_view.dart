import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/task/task_item.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/locale_provider.dart';

class AllTasksView extends ConsumerStatefulWidget {
  final List<Task>? tasks;
  final String? title;

  const AllTasksView({
    super.key,
    required this.tasks,
    this.title,
  });

  @override
  ConsumerState<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends ConsumerState<AllTasksView> {
  late ScrollController _scrollController;
  bool _showScrollToTop = false;
  List<Task>? _localTasks;
  bool _isDeleting = false;
  int? _deletingTaskId;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _localTasks = widget.tasks;
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final uid = await Helpers.getUID();
    if (mounted) {
      setState(() {
        _currentUserId = uid;
      });
    }
  }

  @override
  void didUpdateWidget(AllTasksView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local tasks when widget.tasks changes
    if (widget.tasks != oldWidget.tasks) {
      _localTasks = widget.tasks;
    }
  }

  void _handleScroll() {
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeViewModelProvider);
    final isLoading = homeState.isLoading;

    // Update local tasks from home state if available
    if (homeState.hasValue && homeState.value != null) {
      final homeData = homeState.value!;
      // Determine which task list to use based on title
      List<Task>? updatedTasks;
      if (widget.title == null || widget.title == AppLocalizations.of(context)!.my_tasks) {
        updatedTasks = homeData.myTasks;
      } else if (widget.title == AppLocalizations.of(context)!.pending_tasks) {
        updatedTasks = homeData.pendingTasks;
      } else if (widget.title == AppLocalizations.of(context)!.public_tasks) {
        updatedTasks = homeData.publicTasks;
      }

      if (updatedTasks != null && !_isDeleting) {
        _localTasks = updatedTasks;
      }
    }

    // Filter out the deleting task from display
    final displayTasks = _localTasks?.where((task) => task.id != _deletingTaskId).toList();
    final taskCount = displayTasks?.length ?? 0;
    final completedCount = taskCount > 0
        ? displayTasks!.where((t) => t.endDate.isBefore(DateTime.now())).length
        : 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          // Custom AppBar with background
          _buildAppBarBackground(theme, taskCount, completedCount),
          // Main Content
          _buildMainContent(context, isLoading, theme),
          // Scroll to Top Button
          if (_showScrollToTop) _buildScrollToTopButton(theme),
        ],
      ),
      floatingActionButton: _buildStatsFloatingActionButton(context, theme, taskCount),
    );
  }

  Widget _buildAppBarBackground(ThemeData theme, int taskCount, int completedCount) {
    return Column(
      children: [
        Container(
          height: 190, // Fixed height to prevent overflow
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Back button and title row
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.title != null && widget.title!.isNotEmpty ? widget.title! : AppLocalizations.of(context)!.my_tasks,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28, // Reduced from 32
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Rakkas-Regular',
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (taskCount > 0) ...[
                          _buildStatChip(
                            icon: Icons.format_list_bulleted_rounded,
                            text: AppLocalizations.of(context)!.tasks_count(taskCount),
                          ),
                          const SizedBox(width: 8),
                          _buildStatChip(
                            icon: Icons.check_circle_outline_rounded,
                            text: AppLocalizations.of(context)!.completed_count(completedCount),
                          ),
                        ] else ...[
                          _buildStatChip(
                            icon: Icons.format_list_bulleted_rounded,
                            text: AppLocalizations.of(context)!.no_tasks,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, bool isLoading, ThemeData theme) {
    // Filter out the deleting task from display
    final displayTasks = _localTasks?.where((task) => task.id != _deletingTaskId).toList();

    return Positioned.fill(
      top: 200,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: (isLoading && _isDeleting)
            ? TasksShimmer(length: displayTasks?.length ?? 10)
            : displayTasks == null || displayTasks.isEmpty
            ? _buildEmptyState(context, theme)
            : _buildTasksList(context, theme, displayTasks),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, ThemeData theme, List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.only(top: 32), // Space from app bar
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header Info - Only show if there are deletable tasks
          if (tasks.any((task) => task.ownerId == _currentUserId))
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getSwipeHint(context),
                        style: TextStyle(
                          color: theme.colorScheme.primary.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Tasks List
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final task = tasks[index];
                final canDelete = task.ownerId == _currentUserId;
                final locale = ref.watch(localeProvider);
                final isArabic = locale.languageCode == 'ar';

                return Dismissible(
                  key: ValueKey(task.id),
                  direction: canDelete
                      ? (isArabic ? DismissDirection.startToEnd : DismissDirection.endToStart)
                      : DismissDirection.none,
                  background: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    padding: EdgeInsets.only(
                      left: isArabic ? 24 : 0,
                      right: isArabic ? 0 : 24,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  confirmDismiss: canDelete
                      ? (direction) async {
                          return await _showDeleteConfirmation(context, task);
                        }
                      : null,
                  onDismissed: canDelete
                      ? (direction) async {
                          // Only proceed if user owns the task
                          if (task.ownerId != _currentUserId) return;

                          // Optimistically remove task from UI
                          setState(() {
                            _isDeleting = true;
                            _deletingTaskId = task.id;
                            _localTasks = _localTasks?.where((t) => t.id != task.id).toList();
                          });

                          try {
                            await ref.read(homeViewModelProvider.notifier).deleteTask(task);

                            // Refresh from home state after deletion
                            final homeState = ref.read(homeViewModelProvider);
                            if (homeState.hasValue && homeState.value != null) {
                              final homeData = homeState.value!;
                              List<Task>? updatedTasks;
                              if (widget.title == null || widget.title == AppLocalizations.of(context)!.my_tasks) {
                                updatedTasks = homeData.myTasks;
                              } else if (widget.title == AppLocalizations.of(context)!.pending_tasks) {
                                updatedTasks = homeData.pendingTasks;
                              } else if (widget.title == AppLocalizations.of(context)!.public_tasks) {
                                updatedTasks = homeData.publicTasks;
                              }
                              if (updatedTasks != null) {
                                setState(() {
                                  _localTasks = updatedTasks;
                                });
                              }
                            }

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green.shade600,
                                  content: Text(AppLocalizations.of(context)!.task_deleted_successfully),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            // Restore task if deletion failed
                            setState(() {
                              _localTasks = widget.tasks;
                            });

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red.shade600,
                                  content: Text(AppLocalizations.of(context)!.error),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          } finally {
                            setState(() {
                              _isDeleting = false;
                              _deletingTaskId = null;
                            });
                          }
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: TaskItem(
                        key: ValueKey(task.id),
                        task: task,
                      ),
                    ),
                  ),
                );
              },
              childCount: tasks.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt_rounded,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context)!.no_tasks_found,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
              fontFamily: 'Rakkas-Regular',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.no_tasks_in_category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.primary.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.create_new_task,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollToTopButton(ThemeData theme) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: GestureDetector(
        onTap: _scrollToTop,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsFloatingActionButton(BuildContext context, ThemeData theme, int taskCount) {
    if (taskCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FloatingActionButton.extended(
        onPressed: () {
          final displayTasks = _localTasks?.where((task) => task.id != _deletingTaskId).toList() ?? [];
          _showStatisticsDialog(context, theme, displayTasks);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(Icons.analytics_outlined, size: 20),
        label: Text(AppLocalizations.of(context)!.stats, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _showStatisticsDialog(BuildContext context, ThemeData theme, List<Task> displayTasks) async {
    final completedTasks = displayTasks.where((t) => t.endDate.isBefore(DateTime.now())).length;
    final pendingTasks = displayTasks.length - completedTasks;
    final highPriority = displayTasks.where((t) => t.priority.toLowerCase().contains('high')).length;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.task_statistics,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      fontFamily: 'Rakkas-Regular',
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildStatCard(
                    context,
                    AppLocalizations.of(context)!.total_tasks,
                    displayTasks.length.toString(),
                    Icons.format_list_bulleted_rounded,
                    Colors.blue.shade500,
                    theme,
                  ),
                  _buildStatCard(
                    context,
                    AppLocalizations.of(context)!.completed,
                    completedTasks.toString(),
                    Icons.check_circle_rounded,
                    Colors.green.shade500,
                    theme,
                  ),
                  _buildStatCard(
                    context,
                    AppLocalizations.of(context)!.not_completed,
                    pendingTasks.toString(),
                    Icons.pending_actions_rounded,
                    Colors.orange.shade500,
                    theme,
                  ),
                  _buildStatCard(
                    context,
                    AppLocalizations.of(context)!.high_priority,
                    highPriority.toString(),
                    Icons.priority_high_rounded,
                    Colors.red.shade500,
                    theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.completion_progress,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${displayTasks.length > 0 ? ((completedTasks / displayTasks.length) * 100).toInt() : 0}%',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: displayTasks.length > 0 ? completedTasks / displayTasks.length : 0,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      color: theme.colorScheme.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSwipeHint(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return localizations.swipe_to_delete_hint_owner;
  }

  Widget _buildStatCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      ThemeData theme,
      ) {
    return Container(

      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, Task task) async {
    final theme = Theme.of(context);
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.delete_task,
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_task_confirmation_with_title(task.title),
          style: TextStyle(
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }
}