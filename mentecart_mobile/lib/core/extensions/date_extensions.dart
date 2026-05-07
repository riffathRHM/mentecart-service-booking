import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Format date as 'dd/MM/yyyy'
  String get formattedDate => DateFormat('dd/MM/yyyy').format(this);

  /// Format time as 'HH:mm'
  String get formattedTime => DateFormat('HH:mm').format(this);

  /// Format date and time as 'dd/MM/yyyy HH:mm'
  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  /// Format date as 'MMM dd, yyyy'
  String get formattedLongDate => DateFormat('MMM dd, yyyy').format(this);

  /// Format time as 'hh:mm a'
  String get formattedTimeAmPm => DateFormat('hh:mm a').format(this);

  /// Check if date is today
  bool get isToday {
    final today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Get days difference from now
  int get daysFromNow {
    final now = DateTime.now();
    final difference = DateTime(year, month, day).difference(
      DateTime(now.year, now.month, now.day),
    );
    return difference.inDays;
  }

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));
}