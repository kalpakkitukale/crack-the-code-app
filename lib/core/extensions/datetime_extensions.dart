import 'package:intl/intl.dart';

/// Extension methods for DateTime to add utility functions
extension DateTimeExtensions on DateTime {
  /// Format date to 'dd MMM yyyy' (e.g., '01 Jan 2025')
  String get formatDayMonthYear => DateFormat('dd MMM yyyy').format(this);

  /// Format date to 'MMM dd, yyyy' (e.g., 'Jan 01, 2025')
  String get formatMonthDayYear => DateFormat('MMM dd, yyyy').format(this);

  /// Format date to 'dd/MM/yyyy' (e.g., '01/01/2025')
  String get formatSlash => DateFormat('dd/MM/yyyy').format(this);

  /// Format date to 'yyyy-MM-dd' (e.g., '2025-01-01')
  String get formatISO => DateFormat('yyyy-MM-dd').format(this);

  /// Format time to 'HH:mm' (e.g., '14:30')
  String get formatTime => DateFormat('HH:mm').format(this);

  /// Format date and time to 'dd MMM yyyy, HH:mm' (e.g., '01 Jan 2025, 14:30')
  String get formatDateTime => DateFormat('dd MMM yyyy, HH:mm').format(this);

  /// Get relative time (e.g., '2 hours ago', 'yesterday', 'last week')
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        } else if (difference.inMinutes == 1) {
          return '1 minute ago';
        } else {
          return '${difference.inMinutes} minutes ago';
        }
      } else if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 14) {
      return 'Last week';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 60) {
      return 'Last month';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays < 730) {
      return 'Last year';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is in this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  /// Check if date is in this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in this year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Get end of week (Sunday)
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6)).endOfDay;

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Copy date with new values
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
    );
  }
}
