import 'package:flutter_application/data/models/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryCity {
  final String name;
  final double lat;
  final double lon;
  final double temp;
  final String description;
  final String icon;

  const HistoryCity({
    required this.name,
    required this.lat,
    required this.lon,
    required this.temp,
    required this.description,
    required this.icon,
  });
}

class HistoryNotifier extends StateNotifier<List<HistoryCity>> {
  HistoryNotifier() : super(const []);

  void add({
    required String name,
    required double lat,
    required double lon,
    required WeatherModel weather,
  }) {
    final city = HistoryCity(
      name: name,
      lat: lat,
      lon: lon,
      temp: weather.current.temp,
      description: weather.current.description,
      icon: weather.current.icon,
    );

    final withoutDuplicate = state.where((item) {
      return item.name != city.name ||
          item.lat != city.lat ||
          item.lon != city.lon;
    }).toList();

    state = [city, ...withoutDuplicate].take(5).toList();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryCity>>(
      (ref) => HistoryNotifier(),
    );
