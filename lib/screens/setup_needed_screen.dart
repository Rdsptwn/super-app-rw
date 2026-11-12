import 'package:flutter/material.dart';

class SetupNeededScreen extends StatelessWidget {
  const SetupNeededScreen({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super App RW')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 16),
            Text(
              'Firebase belum dikonfigurasi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Jalankan di folder proyek:\n\n'
              'dart pub global activate flutterfire_cli\n'
              'flutterfire configure\n\n'
              'Lalu jalankan ulang aplikasi.',
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
