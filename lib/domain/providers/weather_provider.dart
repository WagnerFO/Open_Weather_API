import 'package:flutter_application/data/models/weather_model.dart';
import 'package:flutter_application/data/repositories/weather_repository.dart';
import 'package:flutter_application/domain/providers/history_provider.dart';
import 'package:flutter_application/domain/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final weatherRepositoryProvider = Provider((ref) => WeatherRepository());

final selectedLocationProvider = StateProvider<Map<String, double>?>(
  (ref) => null,
);

final selectedCityNameProvider = StateProvider<String?>((ref) => null);

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final selectedLocation = ref.watch(selectedLocationProvider);
  final settings = ref.watch(settingsProvider);
  final repo = ref.read(weatherRepositoryProvider);

  final units = settings.tempUnit == 'C' ? 'metric' : 'imperial';
  const lang = 'pt_br';

  if (selectedLocation != null) {
    final weather = await repo.fetchWeather(
      lat: selectedLocation['lat']!,
      lon: selectedLocation['lon']!,
      units: units,
      lang: lang,
    );

    final cityName = ref.read(selectedCityNameProvider);
    if (cityName != null) {
      ref
          .read(historyProvider.notifier)
          .add(
            name: cityName,
            lat: selectedLocation['lat']!,
            lon: selectedLocation['lon']!,
            weather: weather,
          );
    }

    return weather;
  }

  final permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Permissão de localização negada');
  }

  final position = await Geolocator.getCurrentPosition();
  return repo.fetchWeather(
    lat: position.latitude,
    lon: position.longitude,
    units: units,
    lang: lang,
  );
});
