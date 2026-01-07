import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Daily / Weekly / Monthly',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _ChartCard(
            title: 'Daily Focus',
            subtitle: 'Total minutes per day',
          ),
          _ChartCard(
            title: 'Weekly Habits',
            subtitle: 'Completion rate by habit',
          ),
          _ChartCard(
            title: 'Monthly Totals',
            subtitle: 'Time tracked per task',
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.show_chart),
      ),
    );
  }
}
