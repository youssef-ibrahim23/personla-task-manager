import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../services/tasks_services.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String hintText;
  final ValueChanged<DateTime?> onChanged;

  const DateTimePicker({
    super.key,
    this.selectedDate,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: MaterialButton(
        onPressed: () async {
          final DateTime? pickedDateTime =
          await TasksServices.pickEndDateTime(
            context,
            initialDate: selectedDate ?? DateTime.now(),
          );

          if (pickedDateTime != null) {
            onChanged(pickedDateTime);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedDate != null
                      ? TasksServices.formatEndDate(selectedDate)!
                      : hintText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.dark,
                    fontFamily: AppStrings.primaryFont,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
