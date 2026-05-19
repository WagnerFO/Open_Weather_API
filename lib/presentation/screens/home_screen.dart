import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/core/helpers/weather_icon_helper.dart';
import 'package:flutter_application/data/models/weather_model.dart';
import 'package:flutter_application/data/repositories/weather_repository.dart';
import 'package:flutter_application/domain/providers/weather_provider.dart';
import 'package:flutter_application/presentation/widgets/base_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      loading: () => const Scaffold(body: _LoadingView()),
      error: (e, _) => Scaffold(body: _ErrorView(message: e.toString())),
      data: (weather) => _WeatherView(weather: weather),
    );
  }
}

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

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}

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

class _BlueHeader extends ConsumerWidget {
  final WeatherModel weather;
  const _BlueHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateStr = DateFormat("EEEE, dd 'de' MMMM", 'pt_BR').format(now);
    final timeStr = DateFormat('HH:mm').format(now);
    final selectedName = ref.watch(selectedCityNameProvider);
    final cityName =
        selectedName ?? weather.timezone.split('/').last.replaceAll('_', ' ');

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
                onPressed: () => menuKey.currentState?.open(),
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
                      cityName,
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
              Icon(
                WeatherIconHelper.getIcon(weather.current.icon),
                color: WeatherIconHelper.getColor(weather.current.icon),
                size: 60,
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

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<CitySuggestion> _suggestions = [];
  bool _loading = false;
  bool _showSuggestions = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _showSuggestions = false);
        });
      }
    });
  }

  Future<void> _onTextChanged(String text) async {
    final trimmed = text.trim();
    _debounce?.cancel();

    if (trimmed.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      await _fetchSuggestions(trimmed);
    });
  }

  Future<void> _fetchSuggestions(String text) async {
    try {
      final repo = ref.read(weatherRepositoryProvider);
      final results = await repo.fetchCitySuggestions(text);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _showSuggestions = results.isNotEmpty && _focusNode.hasFocus;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectCity(CitySuggestion city) {
    _controller.text = city.displayName;
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);
    ref.read(selectedLocationProvider.notifier).state = {
      'lat': city.lat,
      'lon': city.lon,
    };
    ref.read(selectedCityNameProvider.notifier).state = city.displayName;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.text,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.search,
            onChanged: _onTextChanged,
            decoration: InputDecoration(
              hintText: 'Buscar Cidade...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    )
                  : _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _showSuggestions = false);
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
          ),
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: _suggestions.map((city) {
                  return InkWell(
                    onTap: () => _selectCity(city),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF1565C0),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              city.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
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
          Expanded(
            child: showHourly
                ? _HourlyView(weather: weather)
                : _WeeklyView(weather: weather),
          ),
        ],
      ),
    );
  }
}

class _WeatherRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String rightText;
  final bool highlight;

  const _WeatherRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.rightText,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = highlight
        ? const Color(0xFF1565C0)
        : const Color(0xFF222222);
    final rightColor = highlight
        ? const Color(0xFF1565C0)
        : const Color(0xFF222222);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: rightColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyView extends StatelessWidget {
  final WeatherModel weather;
  const _HourlyView({required this.weather});

  @override
  Widget build(BuildContext context) {
    final hours = weather.hourly.take(5).toList();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hours.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (_, i) {
        final h = hours[i];
        final label = i == 0 ? 'Agora' : DateFormat('HH\'h\'').format(h.time);
        return _WeatherRow(
          icon: WeatherIconHelper.getIcon(h.icon),
          iconColor: WeatherIconHelper.getColor(h.icon),
          title: label,
          subtitle: h.description,
          rightText: '${h.temp.round()}°',
          highlight: i == 0,
        );
      },
    );
  }
}

class _WeeklyView extends StatelessWidget {
  final WeatherModel weather;
  const _WeeklyView({required this.weather});

  @override
  Widget build(BuildContext context) {
    final days = weather.daily.skip(1).take(7).toList();

    return ListView.separated(
      itemCount: days.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (_, i) {
        final d = days[i];
        final dayName = DateFormat('EEEE', 'pt_BR').format(d.date);
        return _WeatherRow(
          icon: WeatherIconHelper.getIcon(d.icon),
          iconColor: WeatherIconHelper.getColor(d.icon),
          title: dayName,
          subtitle: d.description,
          rightText: '${d.tempMax.round()}° / ${d.tempMin.round()}°',
        );
      },
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
