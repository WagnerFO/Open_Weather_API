class WeatherModel {
  final double lat;
  final double lon;
  final String timezone;
  final CurrentWeather current;
  final List<DailyWeather> daily;
  final List<HourlyWeather> hourly;

  WeatherModel({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.current,
    required this.daily,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    lat: (json['lat'] as num).toDouble(),
    lon: (json['lon'] as num).toDouble(),
    timezone: json['timezone'] ?? '',
    current: CurrentWeather.fromJson(json['current']),
    daily: (json['daily'] as List)
        .map((e) => DailyWeather.fromJson(e))
        .toList(),
    hourly: (json['hourly'] as List)
        .map((e) => HourlyWeather.fromJson(e))
        .toList(),
  );
}

class CurrentWeather {
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;

  CurrentWeather({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    temp: (json['temp'] as num).toDouble(),
    feelsLike: (json['feels_like'] as num).toDouble(),
    humidity: json['humidity'] as int,
    windSpeed: (json['wind_speed'] as num).toDouble(),
    description: json['weather'][0]['description'] ?? '',
    icon: json['weather'][0]['icon'] ?? '',
  );
}

class DailyWeather {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;

  DailyWeather({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  factory DailyWeather.fromJson(Map<String, dynamic> json) => DailyWeather(
    date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    tempMin: (json['temp']['min'] as num).toDouble(),
    tempMax: (json['temp']['max'] as num).toDouble(),
    description: json['weather'][0]['description'] ?? '',
    icon: json['weather'][0]['icon'] ?? '',
  );
}

class HourlyWeather {
  final DateTime time;
  final double temp;
  final String icon;

  HourlyWeather({required this.time, required this.temp, required this.icon});

  String get iconUrl => 'http://openweathermap.org/img/wn/$icon@2x.png';

  factory HourlyWeather.fromJson(Map<String, dynamic> json) => HourlyWeather(
    time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    temp: (json['temp'] as num).toDouble(),
    icon: json['weather'][0]['icon'] ?? '',
  );
}
