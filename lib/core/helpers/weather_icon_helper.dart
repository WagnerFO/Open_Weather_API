import 'package:flutter/material.dart';

class WeatherIconHelper {
  static IconData getIcon(String icon) {
    if (icon.length < 2) return Icons.wb_sunny;

    switch (icon.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny;
      case '02':
        return Icons.wb_cloudy;
      case '03':
        return Icons.cloud;
      case '04':
        return Icons.cloud;
      case '09':
        return Icons.grain;
      case '10':
        return Icons.umbrella;
      case '11':
        return Icons.thunderstorm;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  static Color getColor(String icon) {
    if (icon.length < 2) return const Color(0xFFFFB300);

    switch (icon.substring(0, 2)) {
      case '01':
        return const Color(0xFFFFB300);
      case '02':
        return const Color(0xFF90CAF9);
      case '03':
      case '04':
        return const Color(0xFF90A4AE);
      case '09':
      case '10':
        return const Color(0xFF42A5F5);
      case '11':
        return const Color(0xFF7E57C2);
      case '13':
        return const Color(0xFF80DEEA);
      case '50':
        return const Color(0xFFB0BEC5);
      default:
        return const Color(0xFFFFB300);
    }
  }
}
