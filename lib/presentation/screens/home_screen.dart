import 'package:flutter/material.dart';
import 'package:flutter_application/data/models/weather_model.dart';
import 'package:flutter_application/domain/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weaterAsync = ref.watch(WeatherProvider);

    return Scaffold(
      body: weaterAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (weather) => _WeatherView(weather: weather),
      ),
    );
  }
}

//────Loading────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1565C0),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

//────Error────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}

//────Main View─────
class _WeatherView extends StatefulWidget {
  final WeatherModel weather;
  const _WeatherView({required this.weather});

  @override
  State<_WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<_WeatherView> {
  bool _showHourly = true;
  double _headerHeight = 0;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() => _headerHeight = box.size.height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          Column(
            children: [
              _BlueHeader(key: _headerKey, weather: widget.weather),
              Expanded(
                child: _BottomSheet(
                  weather: widget.weather,
                  showHourly: _showHourly,
                  onTabChanged: (v) => setState(() => _showHourly = v),
                ),
              ),
            ],
          ),
          if (_headerHeight > 0)
            Positioned(
              top: _headerHeight - 24,
              left: 16,
              right: 16,
              child: const _SearchBar(),
            ),
        ],
      ),
    );
  }
}

//──Blue Header─────
class _BlueHeader extends StatelessWidget {
  final WeatherModel weather;
  const _BlueHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat("EEEE, dd 'de' MMMM", 'pt_BR').format(now);
    final timeStr = DateFormat('HH:mm').format(now);

    return Container(
      color: const Color(0xFF1565C0),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  /*Abrir Edge Menu*/
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {
                  /*Perfil*/
                },
              ),
            ],
          ),
          Text(
            timeStr,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Row(
            children: [
              Text(
                dateStr,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.notifications_none,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.timezone.split('/').last.replaceAll('_', ' '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${weather.current.temp.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '${weather.current.description} · sensação ${weather.current.feelsLike.round()}°',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                weather.current.iconUrl,
                width: 72,
                height: 72,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.wb_sunny, color: Colors.yellow, size: 60),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  label: 'umidade',
                  value: '${weather.current.humidity}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatPill(
                  icon: Icons.air,
                  label: '',
                  value: '${weather.current.windSpeed.round()} km/h',
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _StatPill(label: 'UV', value: 'Alto'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _StatPill({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (label.isNotEmpty)
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar Cidade...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          suffixIcon: const Icon(
            Icons.location_on_outlined,
            color: Colors.grey,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final WeatherModel weather;
  final bool showHourly;
  final ValueChanged<bool> onTabChanged;

  const _BottomSheet({
    required this.weather,
    required this.showHourly,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // espaço reservado para a search bar flutuante
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECF0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _Tab(
                  label: 'Por hora',
                  active: showHourly,
                  onTap: () => onTabChanged(true),
                ),
                _Tab(
                  label: 'Semanal',
                  active: !showHourly,
                  onTap: () => onTabChanged(false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weather.hourly.take(8).length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final h = weather.hourly[i];
                return _HourCard(hour: h, isNow: i == 0);
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'PRÓXIMOS DIAS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: weather.daily.take(5).length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (_, i) {
                final d = weather.daily[i + 1];
                return _DailyRow(day: d);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF1565C0) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _HourCard extends StatelessWidget {
  final HourlyWeather hour;
  final bool isNow;

  const _HourCard({required this.hour, required this.isNow});

  @override
  Widget build(BuildContext context) {
    final label = isNow ? 'Agora' : DateFormat('HH\'h\'').format(hour.time);

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow ? const Color(0xFF1565C0) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isNow ? Colors.white70 : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Image.network(
            hour.iconUrl,
            width: 28,
            height: 28,
            errorBuilder: (_, __, ___) => Icon(
              Icons.wb_sunny,
              color: isNow ? Colors.white : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${hour.temp.round()}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isNow ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyWeather day;
  const _DailyRow({required this.day});

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE', 'pt_BR').format(day.date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              dayName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF444444),
              ),
            ),
          ),
          Image.network(
            day.iconUrl,
            width: 28,
            height: 28,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.wb_sunny, color: Colors.orange, size: 24),
          ),
          const Spacer(),
          Text(
            '${day.tempMax.round()}° / ${day.tempMin.round()}°',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}
