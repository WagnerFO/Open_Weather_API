import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/screens/about_screen.dart';
import 'package:flutter_application/presentation/screens/alerts_screen.dart';
import 'package:flutter_application/presentation/screens/favorites_screen.dart';
import 'package:flutter_application/presentation/screens/home_screen.dart';
import 'package:flutter_application/presentation/screens/map_screen.dart';
import 'package:flutter_application/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String map = '/map';
  static const String favorites = '/favorites';
  static const String alerts = '/alerts';
  static const String settings = '/settings';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case alerts:
        return MaterialPageRoute(builder: (_) => const AlertsScreen());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
