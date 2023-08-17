import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_settings.dart';
import 'energy_chart.dart';
import 'energy_table.dart';
import 'energy_data.dart';
import 'energy_log.dart';
import 'login_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsData = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.watch(appSettingsProvider.notifier);
    final energyDataNotifier = ref.watch(energyDataProvider.notifier);

    if (appSettingsData.isLoggingIn) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Energy Generation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Energy Generation',
              style: TextStyle(color: Color(0xFF009899), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: () { appSettingsNotifier.toggleDarkMode(); },
                  icon: Icon(appSettingsData.isDarkMode ? Icons.nights_stay : Icons.wb_sunny)
              ),
              IconButton(
                  onPressed: () { appSettingsNotifier.toggleCharging(energyDataNotifier); },
                  icon: Icon(!appSettingsData.isCharging ? Icons.battery_0_bar : Icons.battery_charging_full, color: Colors.green)
              ),
              IconButton(
                  onPressed: () { appSettingsNotifier.toggleFullScreen(); },
                  icon: Icon(appSettingsData.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.blue)
              ),
            ],
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                return EnergyChart(isLandscape: true, isDarkMode: appSettingsData.isDarkMode); // Display only the chart in landscape mode
              } else {
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Expanded(child: EnergyChart(isLandscape: false, isDarkMode: appSettingsData.isDarkMode)),
                      const TabBar(
                        tabs: [
                          Tab(text: 'Hourly Forecast'),
                          Tab(text: 'Change Log'),
                        ],
                        unselectedLabelColor: Colors.grey, // Inactive tab label color
                        labelColor: Color(0xFF009899),
                        labelStyle: TextStyle(color: Color(0xFF009899), fontWeight: FontWeight.bold, fontSize: 18),
                        indicator: BoxDecoration(
                          color: Colors.black, // Tab indicator color
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            const EnergyDataTable(), // Replace with your data table widget
                            EnergyLog(),      // Replace with your log widget
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

        ),
      );
    }
  }
}