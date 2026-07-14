import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/home/view/widgets/task_list.dart';

class TabbedTasksWidget extends ConsumerStatefulWidget {
  final List<Task>? myTasks;
  final List<Task>? pendingTasks;
  final List<Task>? publicTasks;
  final bool state;

  const TabbedTasksWidget({
    super.key,
    required this.myTasks,
    required this.pendingTasks,
    required this.publicTasks,
    this.state = false,
  });

  @override
  ConsumerState<TabbedTasksWidget> createState() => _TabbedTasksWidgetState();
}

class _TabbedTasksWidgetState extends ConsumerState<TabbedTasksWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
 late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 600;
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: isMobile ? screenWidth * 0.95 : screenWidth * 0.7,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                // Tab Bar Header
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: theme.colorScheme.primary,
                      ),
                      insets: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    indicatorPadding: const EdgeInsets.only(bottom: 1),
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rakkas-Regular',
                      color: theme.colorScheme.primary,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Rakkas-Regular',
                      color: theme.colorScheme.primary.withOpacity(0.6),
                    ),
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: theme.colorScheme.primary.withOpacity(0.6),
                    splashBorderRadius: BorderRadius.circular(12),
                    overlayColor: MaterialStateProperty.all(
                      theme.colorScheme.primary.withOpacity(0.05),
                    ),
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.person_outline, size: 20),
                        text: AppLocalizations.of(context)!.my_tasks,
                      ),
                      Tab(
                        icon: const Icon(Icons.pending_actions_outlined, size: 20),
                        text: AppLocalizations.of(context)!.pending_tasks,
                      ),
                      Tab(
                        icon: const Icon(Icons.public_outlined, size: 20),
                        text: AppLocalizations.of(context)!.public_tasks,
                      ),
                    ],
                  ),
                ),
                // Tab Content
                SizedBox(
                  height: screenHeight * 0.46,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TaskList(
                        tasks: widget.myTasks ?? [],
                        title: AppLocalizations.of(context)!.my_tasks,
                        isLoading: widget.state,
                      ),
                      TaskList(
                        tasks: widget.pendingTasks ?? [],
                        title: AppLocalizations.of(context)!.pending_tasks,
                        isLoading: widget.state,
                      ),
                      TaskList(
                        tasks: widget.publicTasks ?? [],
                        title: AppLocalizations.of(context)!.public_tasks,
                        isLoading: widget.state,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}