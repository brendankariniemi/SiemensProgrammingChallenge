import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_data.dart';

class EnergyLog extends ConsumerWidget {
  EnergyLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyData = ref.watch(energyDataProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: energyData.changeLog.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(energyData.changeLog[index]));
        },
      ),
    );
  }
}