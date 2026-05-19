import 'package:dio/dio.dart';
import 'package:flutter_application/core/constants/api_constants.dart';
import 'package:flutter_application/core/errors/exceptions.dart';
import 'package:flutter_application/data/models/weather_model.dart';

class CitySuggestion {
  final String name;
  final String state;
  final String country;
  final double lat;
  final double lon;

  CitySuggestion({
    required this.name,
    required this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  String get displayName {
    if (state.isNotEmpty) return '$name - $state, $country';
    return '$name, $country';
  }
}

class WeatherRepository {
  final Dio _dio;

  WeatherRepository() : _dio = Dio();

  Future<WeatherModel> fetchWeather({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'pt_br',
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.oneCall(lat: lat, lon: lon, units: units, lang: lang),
      );
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      }
      throw WeatherExceptions('Erro ao buscar dados: ${response.statusCode}');
    } on DioException catch (e) {
      throw WeatherExceptions(e.message ?? 'Erro de conexão');
    }
  }

  Future<List<CitySuggestion>> fetchCitySuggestions(String cityName) async {
    if (cityName.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {
          'q': cityName,
          'limit': 5,
          'appid': ApiConstants.apiKey,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((item) {
          return CitySuggestion(
            name: item['name'] ?? '',
            state: item['state'] ?? '',
            country: item['country'] ?? '',
            lat: (item['lat'] as num).toDouble(),
            lon: (item['lon'] as num).toDouble(),
          );
        }).toList();
      }

      return [];
    } on DioException catch (e) {
      throw WeatherExceptions(e.message ?? 'Erro de conexão');
    }
  }
}
