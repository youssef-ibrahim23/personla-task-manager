import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';
import 'package:personal_task/core/utils/DB/models/Weather.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

class WeatherWidget extends StatefulWidget {
  final Weather? weather;
  final bool state;
  final VoidCallback? onRefresh; // Optional refresh callback

  const WeatherWidget({
    super.key,
    this.weather,
    this.state = false,
    this.onRefresh,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.95,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.92),
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: widget.state
                    ? const TasksShimmer(length: 1)
                    : _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    final weather = widget.weather;

    if (weather == null) {
      return _buildErrorState(context, 'no_internet_connection');
    }

    // Validate essential data
    if (weather.current.tempC == null || weather.location.name == null) {
      return _buildErrorState(context, 'weather_data_unavailable');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;
        return Row(
          children: [
            // Animated weather icon
            _AnimatedWeatherIcon(
              iconUrl: weather.current.condition.icon,
              size: isSmall ? 48 : 56,
              containerSize: isSmall ? 70 : 80,
            ),
            const SizedBox(width: 16),

            // Main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Temperature with unit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${weather.current.tempC!.toInt()}',
                              style: TextStyle(
                                fontSize: isSmall ? 28 : 32,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: AppStrings.primaryFont,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: '°C',
                              style: TextStyle(
                                fontSize: isSmall ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: AppStrings.primaryFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Condition chip (optional)
                      if (!isSmall)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            weather.current.condition.text ?? '--',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Location with icon
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          weather.location.name!,
                          style: TextStyle(
                            fontSize: isSmall ? 12 : 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: AppStrings.primaryArabicFont,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Condition (for small screens)
                  if (isSmall)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        weather.current.condition.text ?? '--',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),

            // Metrics
            _WeatherMetrics(
              humidity: weather.current.humidity ?? 0,
              windKph: weather.current.windKph ?? 0,
              isSmallScreen: isSmall,
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String messageKey) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            localizations.no_internet_connection,
            style: TextStyle(
              color: Colors.red.shade400,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: AppStrings.primaryFont,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            localizations.weather_data_unavailable,
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Animated weather icon with shimmer and fallback
class _AnimatedWeatherIcon extends StatelessWidget {
  final String? iconUrl;
  final double size;
  final double containerSize;

  const _AnimatedWeatherIcon({
    required this.iconUrl,
    required this.size,
    required this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.25),
                  theme.primaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: ClipOval(
              child: _WeatherIcon(
                iconUrl: iconUrl,
                size: size,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final String? iconUrl;
  final double size;

  const _WeatherIcon({required this.iconUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    if (iconUrl == null || iconUrl!.isEmpty) {
      return Icon(Icons.wb_sunny_rounded, size: size, color: Colors.amber.shade600);
    }

    return Image.network(
      'https:${iconUrl!}',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.wb_sunny_rounded,
        size: size,
        color: Colors.amber.shade600,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

// Compact metrics widget with animated numbers
class _WeatherMetrics extends StatelessWidget {
  final int humidity;
  final double windKph;
  final bool isSmallScreen;

  const _WeatherMetrics({
    required this.humidity,
    required this.windKph,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MetricItem(
            icon: Icons.water_drop_rounded,
            value: '$humidity%',
            label: localizations.humidity,
            color: Colors.cyan.shade600,
          ),
          const SizedBox(height: 12),
          _MetricItem(
            icon: Icons.air_rounded,
            value: '${windKph.toInt()} ${localizations.kph}',
            label: localizations.wind,
            color: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, _, child) => child!,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFamily: AppStrings.primaryFont,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}