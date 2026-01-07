import 'schedule.dart';

class Task {
  const Task({
    required this.id,
    required this.name,
    required this.schedule,
    this.description,
    this.isHabit = false,
  });

  final int id;
  final String name;
  final String? description;
  final Schedule schedule;
  final bool isHabit;
}
