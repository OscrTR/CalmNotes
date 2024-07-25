import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Regular Inter text.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Bold Inter text.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Bold PlayfairDisplay text.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () => context.push('/statistics'),
              child: const Text('Go to the stats screen'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/settings'),
              child: const Text('Go to the settings screen'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/entry'),
              child: const Text('Go to the entry screen'),
            ),
          ],
        ),
      ),
    );
  }
}
