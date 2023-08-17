import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_data.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

class AppSettings {
  final bool isFullScreen;
  final bool isLoading;
  final bool isDarkMode;
  final bool isCharging;

  AppSettings({
    required this.isFullScreen,
    required this.isLoading,
    required this.isDarkMode,
    required this.isCharging,
  });

  AppSettings copyWith({
    bool? isFullScreen,
    bool? isLoading,
    bool? isDarkMode,
    bool? isCharging,
  }) {
    return AppSettings(
      isFullScreen: isFullScreen ?? this.isFullScreen,
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isCharging: isCharging ?? this.isCharging,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings(
    isFullScreen: false,
    isLoading: true,
    isDarkMode: false,
    isCharging: false,
  ));

  void toggleFullScreen() {
    if (state.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    state = state.copyWith(isFullScreen: !state.isFullScreen);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void toggleCharging(EnergyDataNotifier energyDataNotifier) {
    energyDataNotifier.setEnergyStorage(!state.isCharging);
    state = state.copyWith(isCharging: !state.isCharging);
  }

  void toggleLoading() {
    state = state.copyWith(isLoading: false);
  }
}
