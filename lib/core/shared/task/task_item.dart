// ============================
// task_item.dart (enhanced)
// ============================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/task/task_helpers.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/tasks/views/task_view.dart';
import 'package:personal_task/features/home/view-model/home_view_model.dart';

class TaskItem extends ConsumerStatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> with SingleTickerProviderStateMixin {
  String? uid;
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _loadUid();
    _hoverController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
  }

  Future<void> _loadUid() async {
    final loadedUid = await Helpers.getUID();
    if (mounted) setState(() => uid = loadedUid);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _hoverController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) => _hoverController.reverse();
  void _onTapCancel() => _hoverController.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = TaskHelpers.getPriorityColor(widget.task.priority);
    final isCompleted = widget.task.endDate.isBefore(DateTime.now());
    final statusText = isCompleted ? 'Completed' : 'In Progress';
    final statusColor = TaskHelpers.getStatusColor(statusText);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskView(task: widget.task, isUpdate: true)),
        );
        if (result == true && mounted) {
          ref.read(homeViewModelProvider.notifier).getHomeData();
        }
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_hoverController.value * 0.01),
            child: Card(
              elevation: _hoverController.value * 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primaryContainer, theme.colorScheme.primaryContainer.withOpacity(0.95)],
                    begin: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 6, height: 60, margin: const EdgeInsets.only(right: 16), decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [priorityColor, priorityColor.withOpacity(0.6)]),
                      borderRadius: BorderRadius.circular(3),
                    )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(widget.task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2)),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(statusText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                              ),
                            ],
                          ),
                          if (widget.task.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(widget.task.description, style: TextStyle(fontSize: 13, color: theme.colorScheme.surface.withOpacity(0.7)), maxLines: 2),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.alarm, size: 14, color: theme.colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(TaskHelpers.formatDate(widget.task.reminder!), style: const TextStyle(fontSize: 12)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor)),
                                    const SizedBox(width: 6),
                                    Text(widget.task.priority, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: priorityColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.task.ownerId == uid) _buildActionMenu(context, theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) async {
        if (value == 'delete') await _handleDelete(context);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red.shade400),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red.shade400)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppLocalizations.of(context)!.delete_task),
        content: Text(AppLocalizations.of(context)!.delete_task_confirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text(AppLocalizations.of(context)!.delete)),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(homeViewModelProvider.notifier).deleteTask(widget.task);
    }
  }
}

// Helper extension (add to TaskHelpers)
extension TaskHelpersExt on TaskHelpers {
  static String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} d ago';
  }
}