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

class _HomeViewState extends ConsumerState<HomeView> with TickerProviderStateMixin {
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1281;

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow background to extend under AppBar
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        title: Text(
          localizations.home,
          style: const TextStyle(
            color: AppColors.light,
            fontSize: 45,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black26,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: _AnimatedBackground(
        gradientController: _gradientController,
        child: RefreshIndicator(
          onRefresh: () {
            return ref.read(homeViewModelProvider.notifier).getHomeData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: screenHeight * 0.1), // Offset for transparent AppBar
            child: isMobile
                ? MobileLayout()
                : isTablet
                ? TabletLayout()
                : const DesktopLayout(), // Ensure all cases handled
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskView()),
          );
        },
        backgroundColor: theme.colorScheme.primaryContainer,
        child: const Icon(Icons.add_task_sharp, color: AppColors.primary),
      ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
    ).animate().moveX(
      begin: isArabic ? -100 : 100,
      end: 0,
      duration: 500.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

// Custom animated gradient background widget
class _AnimatedBackground extends StatelessWidget {
  final AnimationController gradientController;
  final Widget child;

  const _AnimatedBackground({
    required this.gradientController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define color sets based on theme
    final lightGradientColors = [
      const Color(0xFFE8F0FF), // Soft blue
      const Color(0xFFF5E6FF), // Soft lavender
      const Color(0xFFFFF0E6), // Soft peach
      const Color(0xFFE6FFFA), // Soft mint
    ];

    final darkGradientColors = [
      const Color(0xFF1A1A2E), // Deep navy
      const Color(0xFF16213E), // Dark blue
      const Color(0xFF1B1B3A), // Purple-black
      const Color(0xFF0F3460), // Deep teal
    ];

    final colors = isDark ? darkGradientColors : lightGradientColors;

    return AnimatedBuilder(
      animation: gradientController,
      builder: (context, _) {
        // Smoothly shift gradient stops based on animation value
        final t = gradientController.value;
        final offset1 = 0.2 + (t * 0.3);
        final offset2 = 0.5 + (t * 0.2);
        final offset3 = 0.8 - (t * 0.1);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: [offset1, offset2, offset3, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Subtle noise texture overlay (optional, adds depth)
              Opacity(
                opacity: isDark ? 0.03 : 0.02,
                child: Image.asset(
                  'assets/noise.png', // Add your noise texture or remove
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeat,
                  errorBuilder: (_, __, ___) => Container(),
                ),
              ),
              // Animated floating particles (optional decorative)
              ..._buildParticles(context),
              // Main content
              child,
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildParticles(BuildContext context) {
    return List.generate(12, (index) {
      return Positioned(
        left: (index * 37) % 1.0 * MediaQuery.of(context).size.width,
        top: (index * 23) % 1.0 * MediaQuery.of(context).size.height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(seconds: 5 + index),
          curve: Curves.easeInOutSine,
          builder: (context, value, _) {
            return Opacity(
              opacity: 0.3 + (value * 0.4),
              child: Icon(
                Icons.circle,
                size: 2 + (value * 3),
                color: Colors.white.withOpacity(0.15),
              ),
            );
          },
        ),
      );
    });
  }
}

// Desktop layout placeholder (if missing)
class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          'Desktop layout coming soon',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}