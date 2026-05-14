import 'package:flutter_application/data/models/weather_model.dart';
import 'package:flutter_application/data/repositories/weather_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final weatherRepositoryProvider = Provider((ref) => WeatherRepository());

final WeatherProvider = FutureProvider<WeatherModel>((ref) async {
  final permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Permissão de localização negada');
  }

  final position = await Geolocator.getCurrentPosition();
  final repo = ref.read(weatherRepositoryProvider);

  return repo.fetchWeather(lat: position.latitude, lon: position.longitude);
});
