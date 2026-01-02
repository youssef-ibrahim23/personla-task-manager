import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final DateTime? pickedDateTime =
            await TasksServices.pickEndDateTime(
              context,
              initialDate: selectedDate ?? DateTime.now(),
            );

            if (pickedDateTime != null) {
              onChanged(pickedDateTime);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDate != null
                            ? TasksServices.formatEndDate(selectedDate)!
                            : hintText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedDate != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selectedDate != null
                              ? theme.colorScheme.surface
                              : theme.colorScheme.surface.withOpacity(0.6),
                          fontFamily: 'Rakkas-Regular',
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getFormattedDate(selectedDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.surface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: theme.colorScheme.surface.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
