class HabitStreak {
  const HabitStreak({required this.current, required this.best});

  final int current;
  final int best;
}

HabitStreak computeStreak(Set<DateTime> completedDates) {
  if (completedDates.isEmpty) {
    return const HabitStreak(current: 0, best: 0);
  }
  final normalized = completedDates
      .map((date) => DateTime(date.year, date.month, date.day))
      .toList()
    ..sort();

  var best = 1;
  var current = 1;
  var streak = 1;

  for (var i = 1; i < normalized.length; i++) {
    final diff = normalized[i].difference(normalized[i - 1]).inDays;
    if (diff == 1) {
      streak += 1;
    } else if (diff > 1) {
      best = streak > best ? streak : best;
      streak = 1;
    }
  }
  best = streak > best ? streak : best;

  final today = DateTime.now();
  final last = normalized.last;
  final daysSinceLast =
      DateTime(today.year, today.month, today.day).difference(last).inDays;
  if (daysSinceLast == 0 || daysSinceLast == 1) {
    current = streak;
  } else {
    current = 0;
  }

  return HabitStreak(current: current, best: best);
}
