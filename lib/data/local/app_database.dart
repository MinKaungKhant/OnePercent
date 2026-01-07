import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks, Habits, HabitEntries, TimeEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'one_percent'));

  @override
  int get schemaVersion => 1;

  Future<int> upsertTask(TasksCompanion companion) {
    return into(tasks).insertOnConflictUpdate(companion);
  }

  Future<int> insertTimeEntry(TimeEntriesCompanion companion) {
    return into(timeEntries).insert(companion);
  }

  Stream<List<Task>> watchActiveTasks() {
    return (select(tasks)..where((tbl) => tbl.archivedAt.isNull())).watch();
  }

  Stream<List<HabitEntry>> watchHabitEntries(int habitId) {
    return (select(habitEntries)..where((tbl) => tbl.habitId.equals(habitId)))
        .watch();
  }
}
