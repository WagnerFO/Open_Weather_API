import 'package:dio/dio.dart';
import 'package:flutter_application/core/constants/api_constants.dart';
import 'package:flutter_application/core/errors/exceptions.dart';
import 'package:flutter_application/data/models/weather_model.dart';

class WeatherRepository {
  final Dio _dio;

  WeatherRepository() : _dio = Dio();

  Future<WeatherModel> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(ApiConstants.oneCall(lat: lat, lon: lon));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      }
      throw WeatherExceptions('Erro ao buscar dados: ${response.statusCode}');
    } on DioException catch (e) {
      throw WeatherExceptions(e.message ?? 'Erro de conexão');
    }
  }
}
