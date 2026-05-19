import 'package:flutter/material.dart';
import 'package:flutter_application/core/helpers/weather_icon_helper.dart';
import 'package:flutter_application/domain/providers/weather_provider.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final cityName = ref.watch(selectedCityNameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AppBarMenu(title: 'Alertas'),
      body: weatherAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF1565C0)),
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (weather) {
          final displayName =
              cityName ?? weather.timezone.split('/').last.replaceAll('_', ' ');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _CityCard(
                cityName: displayName,
                temp: weather.current.temp,
                description: weather.current.description,
                icon: weather.current.icon,
              ),
              const SizedBox(height: 16),
              if (weather.alerts.isEmpty) ...[
                const _EmptyCard(),
                const SizedBox(height: 16),
                _TipsCard(weather: weather),
              ] else ...[
                const _SectionLabel(label: 'Alertas ativos'),
                const SizedBox(height: 8),
                ...weather.alerts.map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AlertCard(alert: alert),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String cityName;
  final double temp;
  final String description;
  final String icon;

  const _CityCard({
    required this.cityName,
    required this.temp,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                WeatherIconHelper.getIcon(icon),
                color: WeatherIconHelper.getColor(icon),
                size: 36,
              ),
              const SizedBox(width: 8),
              Text(
                '${temp.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final dynamic alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.thunderstorm_outlined,
                  color: Color(0xFFC62828),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ALERTA',
                        style: TextStyle(
                          color: Color(0xFFC62828),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.event,
                        style: const TextStyle(
                          color: Color(0xFFB71C1C),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dateFormat.format(alert.start)} até ${dateFormat.format(alert.end)}',
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AVISO METEOROLÓGICO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xFFE53935), width: 4),
                    ),
                    color: Color(0xFFFFF8F8),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_outlined,
                        color: Color(0xFFE53935),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fonte: ${alert.senderName}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF90CAF9),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum alerta ativo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Não há alertas meteorológicos\npara esta região no momento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final dynamic weather;
  const _TipsCard({required this.weather});

  List<Map<String, dynamic>> _getTips() {
    final tips = <Map<String, dynamic>>[];
    final current = weather.current;

    if (current.humidity > 80) {
      tips.add({
        'icon': Icons.water_drop_outlined,
        'color': const Color(0xFF1565C0),
        'title': 'Umidade elevada',
        'desc': 'Umidade em ${current.humidity}%. Hidrate-se bem.',
      });
    }

    if (current.windSpeed > 30) {
      tips.add({
        'icon': Icons.air_outlined,
        'color': const Color(0xFF0288D1),
        'title': 'Vento forte',
        'desc':
            'Vento a ${current.windSpeed.round()} km/h. Cuidado em áreas abertas.',
      });
    }

    if (current.icon.startsWith('01') || current.icon.startsWith('02')) {
      tips.add({
        'icon': Icons.wb_sunny_outlined,
        'color': const Color(0xFFFFB300),
        'title': 'UV alto',
        'desc': 'Céu aberto. Use protetor solar e evite exposição ao meio-dia.',
      });
    }

    if (tips.isEmpty) {
      tips.add({
        'icon': Icons.thumb_up_outlined,
        'color': const Color(0xFF43A047),
        'title': 'Clima estável',
        'desc': 'Condições climáticas favoráveis para a região.',
      });
    }

    return tips;
  }

  @override
  Widget build(BuildContext context) {
    final tips = _getTips();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DICAS DO DIA',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: tips.asMap().entries.map((entry) {
              final i = entry.key;
              final tip = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (tip['color'] as Color).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            tip['icon'] as IconData,
                            color: tip['color'] as Color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip['title'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tip['desc'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < tips.length - 1)
                    const Divider(
                      height: 1,
                      indent: 68,
                      color: Color(0xFFEEEEEE),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
