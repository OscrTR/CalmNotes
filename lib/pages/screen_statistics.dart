import 'package:calm_notes/components/chart.dart';
import 'package:flutter/material.dart';

class ScreenStatistics extends StatelessWidget {
  const ScreenStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () {}, child: const Text('Week')),
              TextButton(onPressed: () {}, child: const Text('Month')),
              TextButton(onPressed: () {}, child: const Text('Year'))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mood graph',
                  style: Theme.of(context).textTheme.titleMedium),
              OutlinedButton(onPressed: () {}, child: const Text('Add factor'))
            ],
          ),
          const SizedBox(height: 10),
          const Chart(),
        ],
      ),
    );
  }
}
