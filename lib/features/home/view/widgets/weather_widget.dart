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

  const WeatherWidget({super.key, this.weather, this.state = false});

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
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 380;

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
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.025,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.95),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.8],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: widget.state
            ? const TasksShimmer(length: 1)
            : _buildWeatherContent(context, screenWidth, isSmallScreen),
      ),
    );
  }

  Widget _buildWeatherContent(
      BuildContext context, double screenWidth, bool isSmallScreen) {
    if (widget.weather == null) {
      return SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 32,
              color: Colors.red.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.no_internet_connection,
              style: TextStyle(
                color: Colors.red.shade500,
                fontFamily: AppStrings.primaryFont,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.weather_data_unavailable,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          // Weather Icon Container
          _buildWeatherIcon(context, screenWidth, isSmallScreen),

          // Spacer
          SizedBox(width: isSmallScreen ? 12 : 20),

          // Weather Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Temperature and Location
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.weather?.current.tempC ?? '--'}°',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: AppStrings.primaryFont,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'C',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: AppStrings.primaryFont,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Location
                Text(
                  widget.weather?.location.name ?? AppLocalizations.of(context)!.unknown_location,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppStrings.primaryArabicFont,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Condition
                Text(
                  widget.weather?.current.condition.text ?? '--',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: AppStrings.primaryArabicFont,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            height: 50,
            width: 1.5,
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Weather Metrics
          _buildWeatherMetrics(context, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(
      BuildContext context, double screenWidth, bool isSmallScreen) {
    return FutureBuilder<bool>(
      future: Helpers.isConnectedToInternet(),
      builder: (context, snapshot) {
        final bool connected = snapshot.data ?? false;
        final iconSize = isSmallScreen ? 42.0 : 50.0;
        final containerSize = screenWidth * 0.20;

        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.25),
                AppColors.primary.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.15),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: (widget.weather?.current.condition.icon != null && connected)
                ? Image.network(
              'https:${widget.weather!.current.condition.icon}',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.wb_sunny_rounded,
                  size: iconSize,
                  color: Colors.amber.shade600,
                );
              },
            )
                : Icon(
              Icons.wb_sunny_rounded,
              size: iconSize,
              color: Colors.amber.shade600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherMetrics(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Humidity
        _buildMetricItem(
          icon: Icons.water_drop_rounded,
          value: '${widget.weather?.current.humidity ?? '--'}%',
          label: AppLocalizations.of(context)!.humidity,
          context: context,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        // Wind Speed
        _buildMetricItem(
          icon: Icons.air_rounded,
          value: '${widget.weather?.current.windKph ?? '--'} ${AppLocalizations.of(context)!.kph}',
          label: AppLocalizations.of(context)!.wind,
          context: context,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required BuildContext context,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSmallScreen ? 14 : 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: AppStrings.primaryFont,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 9 : 10,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}