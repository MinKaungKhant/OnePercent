import 'dart:convert';

import 'package:intl/intl.dart';

enum ScheduleType {
  daily,
  monthly,
  weekdays,
  interval,
  specificDates,
}

class TimeWindow {
  const TimeWindow({required this.startMinutes, required this.endMinutes});

  final int startMinutes;
  final int endMinutes;

  bool contains(DateTime value) {
    final minutes = value.hour * 60 + value.minute;
    return minutes >= startMinutes && minutes <= endMinutes;
  }

  Map<String, dynamic> toJson() => {
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      startMinutes: json['startMinutes'] as int,
      endMinutes: json['endMinutes'] as int,
    );
  }
}

class Schedule {
  const Schedule({
    required this.type,
    this.startDate,
    this.intervalDays,
    this.weekdays,
    this.dayOfMonth,
    this.specificDates,
    this.timeWindow,
  });

  final ScheduleType type;
  final DateTime? startDate;
  final int? intervalDays;
  final Set<int>? weekdays;
  final int? dayOfMonth;
  final Set<DateTime>? specificDates;
  final TimeWindow? timeWindow;

  bool occursOn(DateTime date) {
    final day = _dateOnly(date);
    switch (type) {
      case ScheduleType.daily:
        return true;
      case ScheduleType.monthly:
        return dayOfMonth != null && day.day == dayOfMonth;
      case ScheduleType.weekdays:
        return weekdays?.contains(day.weekday) ?? false;
      case ScheduleType.interval:
        if (startDate == null || intervalDays == null) return false;
        final diff = day.difference(_dateOnly(startDate!)).inDays;
        return diff >= 0 && diff % intervalDays! == 0;
      case ScheduleType.specificDates:
        return specificDates
                ?.map(_dateOnly)
                .contains(day) ??
            false;
    }
  }

  bool isActiveAt(DateTime dateTime) {
    if (!occursOn(dateTime)) return false;
    if (timeWindow == null) return true;
    return timeWindow!.contains(dateTime);
  }

  List<DateTime> occurrencesBetween(DateTime start, DateTime end) {
    final results = <DateTime>[];
    var cursor = _dateOnly(start);
    final last = _dateOnly(end);
    while (!cursor.isAfter(last)) {
      if (occursOn(cursor)) {
        results.add(cursor);
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return results;
  }

  String describe() {
    switch (type) {
      case ScheduleType.daily:
        return 'Daily';
      case ScheduleType.monthly:
        return 'Monthly on day ${dayOfMonth ?? '-'}';
      case ScheduleType.weekdays:
        final labels = weekdays
                ?.map((weekday) => DateFormat.E().format(
                      DateTime(2024, 1, weekday),
                    ))
                .join(', ') ??
            '';
        return 'Weekdays: $labels';
      case ScheduleType.interval:
        return 'Every ${intervalDays ?? '-'} days';
      case ScheduleType.specificDates:
        final labels = specificDates
                ?.map((date) => DateFormat.yMd().format(date))
                .join(', ') ??
            '';
        return 'Specific dates: $labels';
    }
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  String toJson() => jsonEncode({
        'type': type.name,
        'startDate': startDate?.toIso8601String(),
        'intervalDays': intervalDays,
        'weekdays': weekdays?.toList(),
        'dayOfMonth': dayOfMonth,
        'specificDates': specificDates?.map((date) => date.toIso8601String()).toList(),
        'timeWindow': timeWindow?.toJson(),
      });

  factory Schedule.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return Schedule(
      type: ScheduleType.values.firstWhere((value) => value.name == data['type']),
      startDate: data['startDate'] != null
          ? DateTime.parse(data['startDate'] as String)
          : null,
      intervalDays: data['intervalDays'] as int?,
      weekdays: (data['weekdays'] as List<dynamic>?)
          ?.map((value) => value as int)
          .toSet(),
      dayOfMonth: data['dayOfMonth'] as int?,
      specificDates: (data['specificDates'] as List<dynamic>?)
          ?.map((value) => DateTime.parse(value as String))
          .toSet(),
      timeWindow: data['timeWindow'] != null
          ? TimeWindow.fromJson(data['timeWindow'] as Map<String, dynamic>)
          : null,
    );
  }
}
