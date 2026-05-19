import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final String tempUnit;
  final String windUnit;
  final bool notifications;

  const AppSettings({
    this.tempUnit = 'C',
    this.windUnit = 'km/h',
    this.notifications = true,
  });

  AppSettings copyWith({
    String? tempUnit,
    String? windUnit,
    bool? notifications,
  }) {
    return AppSettings(
      tempUnit: tempUnit ?? this.tempUnit,
      windUnit: windUnit ?? this.windUnit,
      notifications: notifications ?? this.notifications,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void setTempUnit(String unit) => state = state.copyWith(tempUnit: unit);

  void setWindUnit(String unit) => state = state.copyWith(windUnit: unit);

  void setNotifications(bool value) =>
      state = state.copyWith(notifications: value);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
