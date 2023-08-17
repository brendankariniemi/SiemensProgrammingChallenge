import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_data.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

class AppSettings {
  final bool isFullScreen;
  final bool isLoggingIn;
  final bool isDarkMode;
  final bool isCharging;
  final String loggedInUser;

  AppSettings({
    required this.isFullScreen,
    required this.isLoggingIn,
    required this.isDarkMode,
    required this.isCharging,
    required this.loggedInUser
  });

  AppSettings copyWith({
    bool? isFullScreen,
    bool? isLoggingIn,
    bool? isDarkMode,
    bool? isCharging,
    String? loggedInUser,
  }) {
    return AppSettings(
      isFullScreen: isFullScreen ?? this.isFullScreen,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isCharging: isCharging ?? this.isCharging,
      loggedInUser: loggedInUser ?? this.loggedInUser,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings(
    isFullScreen: false,
    isLoggingIn: true,
    isDarkMode: false,
    isCharging: false,
    loggedInUser: '',
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
    if (state.loggedInUser == 'admin') {
      energyDataNotifier.setEnergyStorage(!state.isCharging);
      state = state.copyWith(isCharging: !state.isCharging);
    }
  }

  void toggleLoggingIn() {
    state = state.copyWith(isLoggingIn: false);
  }

  void setLoggedInUser(String user) {
    state = state.copyWith(loggedInUser: user);
  }
}
