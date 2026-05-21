import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey =>
      (dotenv.env['OPENWEATHER_API_KEY'] ?? '').trim().replaceAll('-', '');

  static const String baseUrl = 'https://api.openweathermap.org/data/3.0';

  static String oneCall({
    required double lat,
    required double lon,
    String units = 'metric',
    String lang = 'pt_br',
  }) => 
      '$baseUrl/onecall?lat=$lat&lon=$lon'
      '&exclude=minutely'
      '&appid=$apiKey'
      '&units=$units'
      '&lang=$lang';

  static String weatherTileLayer(String layer) =>
      'https://tile.openweathermap.org/map/$layer/{z}/{x}/{y}.png'
      '?appid=$apiKey';
}
