import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TaskHelpers {
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formats a DateTime object to a readable string
  /// Example output: 05/12/2025 – 16:45
  static String formatDate(DateTime dateTime, {String pattern = 'dd/MM/yyyy – HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }
}
