import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/shared/task/tasks_shimmer.dart';
import 'package:personal_task/core/utils/DB/models/Weather.dart';
import 'package:personal_task/core/utils/helpers.dart';

class WeatherWidget extends StatelessWidget {
  final Weather? weather;
  final bool state;

  const WeatherWidget({super.key, this.weather, this.state = false});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.95,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: state
          ? TasksShimmer(length: 1)
          : _buildWeatherContent(context, screenWidth, screenHeight),
    );
  }

  Widget _buildWeatherContent(
      BuildContext context, double screenWidth, double screenHeight) {
    if (weather == null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No Internet Connection',
            style: TextStyle(
              color: Colors.red,
              fontFamily: AppStrings.primaryFont,
              fontSize: 17,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          FutureBuilder<bool>(
            future: Helpers.isConnectedToInternet(),
            builder: (context, snapshot) {
              bool connected = snapshot.data ?? false;

              return Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: (weather?.current.condition.icon != null && connected)
                    ? Image.network(
                  'https:${weather!.current.condition.icon}',
                  fit: BoxFit.contain,
                )
                    : Icon(Icons.sunny_snowing,
                    color: Colors.yellow, size: 32),
              );
            },
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather?.current.tempC ?? '--'}°C in ${weather?.location.country ?? '--'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weather?.current.condition.text ?? '--',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Humidity: ${weather?.current.humidity ?? '--'}%',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'Wind: ${weather?.current.windKph ?? '--'} kph',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
