import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.go('/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/stats'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/task-editor'),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Scheduled Tasks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _TaskCard(
            title: 'Deep Work',
            subtitle: 'Daily • 2h focus block',
            trailing: ElevatedButton.icon(
              onPressed: () => context.go('/timer'),
              icon: const Icon(Icons.timer),
              label: const Text('Start'),
            ),
          ),
          _TaskCard(
            title: 'Walk 5k',
            subtitle: 'Habit • Streak 6 days',
            trailing: FilledButton(
              onPressed: () {},
              child: const Text('Mark done'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Time Tracker',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('No active timer'),
              subtitle: const Text('Start a timer to capture focus sessions.'),
              trailing: OutlinedButton(
                onPressed: () => context.go('/timer'),
                child: const Text('Open timer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
