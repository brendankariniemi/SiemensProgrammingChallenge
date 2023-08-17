import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'google_sheets_api.dart';
import 'dart:async';

final energyDataProvider = StateNotifierProvider<EnergyDataNotifier, EnergyData>((ref) {
  return EnergyDataNotifier();
});

class EnergyData {
  final List<double> hours;
  final List<double> loadGeneration;
  final List<double> loadForecast;
  final List<double> windForecast;
  final List<double> solarForecast;
  final List<double> energyStorage;

  final List<String> changeLog;

  EnergyData({
    required this.hours,
    required this.loadGeneration,
    required this.loadForecast,
    required this.windForecast,
    required this.solarForecast,
    required this.energyStorage,
    required this.changeLog,
  });

  EnergyData copyWith({
    List<double>? hours,
    List<double>? loadGeneration,
    List<double>? loadForecast,
    List<double>? windForecast,
    List<double>? solarForecast,
    List<double>? energyStorage,
    List<String>? changeLog,
  }) {
    return EnergyData(
      hours: hours ?? this.hours,
      loadGeneration: loadGeneration ?? this.loadGeneration,
      loadForecast: loadForecast ?? this.loadForecast,
      windForecast: windForecast ?? this.windForecast,
      solarForecast: solarForecast ?? this.solarForecast,
      energyStorage: energyStorage ?? this.energyStorage,
      changeLog: changeLog ?? this.changeLog,
    );
  }
}

class EnergyDataNotifier extends StateNotifier<EnergyData> {
  EnergyDataNotifier() : super(EnergyData(
    hours: List<double>.generate(24, (index) => 0),
    loadGeneration: List<double>.generate(24, (index) => 0),
    loadForecast: List<double>.generate(24, (index) => 0),
    windForecast: List<double>.generate(24, (index) => 0),
    solarForecast: List<double>.generate(24, (index) => 0),
    energyStorage: List<double>.generate(24, (index) => 0),
    changeLog: [],
  )) {
    _startDataLoadingTimer();
  }

  final GoogleSheetsAPI _sheetsApi = GoogleSheetsAPI();
  final _curTime = DateTime.now();

  void _startDataLoadingTimer() {
    _sheetsApi.init();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadData();
    });
  }

  void _loadData() async {
    List<List<String>>? data = await _sheetsApi.getData();
    final formattedTime = "${_curTime.hour.toString().padLeft(2, '0')}:${_curTime.minute.toString().padLeft(2, '0')}:${_curTime.second.toString().padLeft(2, '0')}";
    List<String> newChanges = [];

    if (data != null) {
      List<double> hours = [];
      List<double> loadGeneration = [];
      List<double> loadForecast = [];
      List<double> windForecast = [];
      List<double> solarForecast = [];

      for (int i = 0; i < data.length; i++) {
        List<String> row = data[i];
        double hour = double.parse(row[0]) * 24;
        double load = double.parse(row[1]);
        double wind = double.parse(row[2]);
        double solar = double.parse(row[3]);
        double storage = state.energyStorage[i];
        double generated = load - wind - solar + storage;

        hours.add(hour);
        loadGeneration.add(generated);
        loadForecast.add(load);
        windForecast.add(wind);
        solarForecast.add(solar);

        if (state.loadForecast[i] != load && state.loadForecast[i] != 0.0) {
          newChanges.add("$formattedTime - Load Forecast for ${hours[i].toInt()}:00 changed from ${state.loadForecast[i]} to $load");
        }

        if (state.windForecast[i] != wind && state.windForecast[i] != 0.0) {
          newChanges.add("$formattedTime - Wind Forecast for ${hours[i].toInt()}:00 changed from ${state.windForecast[i]} to $wind");
        }

        if (state.solarForecast[i] != solar && state.solarForecast[i] != 0.0) {
          newChanges.add("$formattedTime - Solar Forecast for ${hours[i].toInt()}:00 changed from ${state.solarForecast[i]} to $solar");
        }
      }

      state = state.copyWith(
          hours: hours,
          loadGeneration: loadGeneration,
          loadForecast: loadForecast,
          windForecast: windForecast,
          solarForecast: solarForecast,
          changeLog: [...state.changeLog, ...newChanges]
      );
    }
  }

  void setEnergyStorage(bool charging) {
    List<double> newEnergyStorage = List<double>.generate(24, (index) => 0);

    if (charging) {
      double avg = calcAvg(state.loadGeneration, _curTime.hour.toInt(), state.loadGeneration.length);
      double curBattery = 0;
      bool empty = true;

      for (int i = _curTime.hour.toInt(); i < state.loadGeneration.length; i++) {

        double demand = state.loadGeneration[i];
        double diff = avg - demand;

        if (empty == true && diff < 0) {
          avg = calcAvg(state.loadGeneration, i+1, state.loadGeneration.length);
          newEnergyStorage[i] = 0;
          continue;
        }

        if (diff > 0) { // Charge the battery
          newEnergyStorage[i] = diff;
          curBattery += diff;
          empty = false;
        }
        else { // Discharge battery

          if (curBattery > diff*-1) { // battery has charge
            newEnergyStorage[i] = diff;
            curBattery += diff;
          }
          else { // Not enough charge
            newEnergyStorage[i] = curBattery*-1;
            curBattery = 0;
            empty = true;
          }
        }
      }
    }

    state = state.copyWith(
      energyStorage: newEnergyStorage
    );
  }

  double calcAvg(List<double> arr, int begin, int end) {
    double sum = 0;
    for (int i = begin; i < end; i++) {
      sum += arr[i];
    }
    return sum/(end - begin);
  }
}


