import 'package:test/test.dart';
import 'package:one_percent/features/tasks/domain/schedule.dart';

void main() {
  group('Schedule', () {
    test('daily occurs every day', () {
      final schedule = Schedule(type: ScheduleType.daily);
      expect(schedule.occursOn(DateTime(2024, 5, 1)), isTrue);
      expect(schedule.occursOn(DateTime(2024, 5, 2)), isTrue);
    });

    test('weekdays filters correctly', () {
      final schedule = Schedule(
        type: ScheduleType.weekdays,
        weekdays: {DateTime.monday, DateTime.wednesday, DateTime.friday},
      );

      expect(schedule.occursOn(DateTime(2024, 5, 1)), isTrue); // Wed
      expect(schedule.occursOn(DateTime(2024, 5, 2)), isFalse); // Thu
    });

    test('interval uses start date', () {
      final schedule = Schedule(
        type: ScheduleType.interval,
        startDate: DateTime(2024, 5, 1),
        intervalDays: 3,
      );

      expect(schedule.occursOn(DateTime(2024, 5, 1)), isTrue);
      expect(schedule.occursOn(DateTime(2024, 5, 2)), isFalse);
      expect(schedule.occursOn(DateTime(2024, 5, 4)), isTrue);
    });

    test('monthly uses day of month', () {
      final schedule = Schedule(
        type: ScheduleType.monthly,
        dayOfMonth: 15,
      );

      expect(schedule.occursOn(DateTime(2024, 5, 15)), isTrue);
      expect(schedule.occursOn(DateTime(2024, 5, 16)), isFalse);
    });

    test('specific dates only', () {
      final schedule = Schedule(
        type: ScheduleType.specificDates,
        specificDates: {
          DateTime(2024, 5, 10),
          DateTime(2024, 6, 10),
        },
      );

      expect(schedule.occursOn(DateTime(2024, 5, 10)), isTrue);
      expect(schedule.occursOn(DateTime(2024, 5, 11)), isFalse);
    });

    test('occurrencesBetween returns matching dates', () {
      final schedule = Schedule(
        type: ScheduleType.weekdays,
        weekdays: {DateTime.monday},
      );

      final occurrences = schedule.occurrencesBetween(
        DateTime(2024, 5, 1),
        DateTime(2024, 5, 15),
      );

      expect(occurrences.length, 2);
      expect(occurrences.first.weekday, DateTime.monday);
    });

    test('time window filters active times', () {
      final schedule = Schedule(
        type: ScheduleType.daily,
        timeWindow: const TimeWindow(startMinutes: 9 * 60, endMinutes: 17 * 60),
      );

      expect(schedule.isActiveAt(DateTime(2024, 5, 1, 10)), isTrue);
      expect(schedule.isActiveAt(DateTime(2024, 5, 1, 18)), isFalse);
    });

    test('serializes and deserializes schedule', () {
      final schedule = Schedule(
        type: ScheduleType.interval,
        startDate: DateTime(2024, 5, 1),
        intervalDays: 2,
        weekdays: {DateTime.monday},
        dayOfMonth: 5,
        specificDates: {DateTime(2024, 5, 10)},
        timeWindow: const TimeWindow(startMinutes: 480, endMinutes: 1020),
      );

      final encoded = schedule.toJson();
      final decoded = Schedule.fromJson(encoded);

      expect(decoded.type, schedule.type);
      expect(decoded.intervalDays, schedule.intervalDays);
      expect(decoded.weekdays, schedule.weekdays);
      expect(decoded.dayOfMonth, schedule.dayOfMonth);
      expect(decoded.specificDates?.first, schedule.specificDates?.first);
      expect(decoded.timeWindow?.startMinutes, schedule.timeWindow?.startMinutes);
    });
  });
}
