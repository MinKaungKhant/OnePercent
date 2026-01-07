import '../../../data/local/app_database.dart' show TasksCompanion, Task;
import '../domain/schedule.dart';
import '../domain/task.dart' as domain;
import 'package:drift/drift.dart';

domain.Task mapTask(Task record) {
  return domain.Task(
    id: record.id,
    name: record.name,
    description: record.description,
    schedule: Schedule.fromJson(record.scheduleJson),
    isHabit: record.isHabit,
  );
}

TasksCompanion toCompanion({
  int? id,
  required String name,
  String? description,
  required Schedule schedule,
  bool isHabit = false,
  DateTime? createdAt,
}) {
  return TasksCompanion(
    id: id == null ? const Value.absent() : Value(id),
    name: Value(name),
    description: Value(description),
    scheduleJson: Value(schedule.toJson()),
    isHabit: Value(isHabit),
    createdAt: Value(createdAt ?? DateTime.now()),
  );
}
