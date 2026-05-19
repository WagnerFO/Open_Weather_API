import 'package:flutter/material.dart';
import 'package:flutter_application/core/helpers/weather_icon_helper.dart';
import 'package:flutter_application/core/navigation/app_router.dart';
import 'package:flutter_application/domain/providers/history_provider.dart';
import 'package:flutter_application/domain/providers/weather_provider.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AppBarMenu(title: 'Histórico'),
      body: cities.isEmpty
          ? const _EmptyHistory()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cities.length + 1,
              separatorBuilder: (_, index) => index == 0
                  ? const SizedBox(height: 8)
                  : const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const _SectionLabel();
                }

                final city = cities[index - 1];
                return _HistoryCard(
                  city: city,
                  onTap: () {
                    ref.read(selectedLocationProvider.notifier).state = {
                      'lat': city.lat,
                      'lon': city.lon,
                    };
                    ref.read(selectedCityNameProvider.notifier).state =
                        city.name;
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
                  },
                );
              },
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ÚLTIMAS CIDADES BUSCADAS',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryCity city;
  final VoidCallback onTap;

  const _HistoryCard({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor(city.icon),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${city.temp.round()}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    city.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              WeatherIconHelper.getIcon(city.icon),
              color: WeatherIconHelper.getColor(city.icon),
              size: 54,
            ),
          ],
        ),
      ),
    );
  }

  Color _cardColor(String icon) {
    if (icon.startsWith('09') ||
        icon.startsWith('10') ||
        icon.startsWith('11')) {
      return const Color(0xFF38679F);
    }
    if (icon.startsWith('03') ||
        icon.startsWith('04') ||
        icon.startsWith('50')) {
      return const Color(0xFF7291AE);
    }
    return const Color(0xFF42A5F5);
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Busque uma cidade na tela inicial para criar o histórico.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}
