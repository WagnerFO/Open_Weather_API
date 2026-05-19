import 'package:flutter/material.dart';
import 'package:flutter_application/core/constants/api_constants.dart';
import 'package:flutter_application/domain/providers/weather_provider.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  _WeatherLayer _selectedLayer = _WeatherLayer.precipitation;

  void _changeZoom(double delta) {
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(3.0, 12.0);
    _mapController.move(camera.center, nextZoom);
  }

  void _moveToWeather(double lat, double lon) {
    _mapController.move(LatLng(lat, lon), _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final cityName = ref.watch(selectedCityNameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AppBarMenu(title: 'Mapa'),
      body: weatherAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF1565C0)),
        ),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (weather) {
          final center = LatLng(weather.lat, weather.lon);
          final displayName =
              cityName ?? weather.timezone.split('/').last.replaceAll('_', ' ');

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 7,
                  minZoom: 3,
                  maxZoom: 12,
                  interactionOptions: const InteractionOptions(
                    flags:
                        InteractiveFlag.drag |
                        InteractiveFlag.flingAnimation |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.doubleTapZoom,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_application',
                  ),
                  TileLayer(
                    urlTemplate: ApiConstants.weatherTileLayer(
                      _selectedLayer.layerId,
                    ),
                    tileDisplay: const TileDisplay.fadeIn(),
                    userAgentPackageName: 'com.example.flutter_application',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 46,
                        height: 46,
                        child: const _LocationMarker(),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: _MapControls(
                  selectedLayer: _selectedLayer,
                  cityName: displayName,
                  onLayerChanged: (layer) {
                    setState(() => _selectedLayer = layer);
                  },
                  onRecenter: () => _moveToWeather(weather.lat, weather.lon),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 52,
                child: _ZoomControls(
                  onZoomIn: () => _changeZoom(1),
                  onZoomOut: () => _changeZoom(-1),
                ),
              ),
              const Positioned(left: 12, bottom: 8, child: _AttributionLabel()),
            ],
          );
        },
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const _ZoomControls({required this.onZoomIn, required this.onZoomOut});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(icon: Icons.add, tooltip: 'Aproximar', onTap: onZoomIn),
          const SizedBox(
            width: 36,
            child: Divider(height: 1, color: Color(0xFFE0E0E0)),
          ),
          _ZoomButton(
            icon: Icons.remove,
            tooltip: 'Distanciar',
            onTap: onZoomOut,
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ZoomButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: const Color(0xFF1565C0), size: 22),
      onPressed: onTap,
    );
  }
}

enum _WeatherLayer {
  precipitation('Chuva', 'precipitation_new', Icons.water_drop_outlined),
  clouds('Nuvens', 'clouds_new', Icons.cloud_outlined),
  temperature('Temp.', 'temp_new', Icons.thermostat_outlined),
  wind('Vento', 'wind_new', Icons.air);

  final String label;
  final String layerId;
  final IconData icon;

  const _WeatherLayer(this.label, this.layerId, this.icon);
}

class _MapControls extends StatelessWidget {
  final _WeatherLayer selectedLayer;
  final String cityName;
  final ValueChanged<_WeatherLayer> onLayerChanged;
  final VoidCallback onRecenter;

  const _MapControls({
    required this.selectedLayer,
    required this.cityName,
    required this.onLayerChanged,
    required this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    cityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF263238),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Centralizar',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.my_location,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                  onPressed: onRecenter,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _WeatherLayer.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final layer = _WeatherLayer.values[index];
                  return _LayerChip(
                    layer: layer,
                    selected: selectedLayer == layer,
                    onTap: () => onLayerChanged(layer),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayerChip extends StatelessWidget {
  final _WeatherLayer layer;
  final bool selected;
  final VoidCallback onTap;

  const _LayerChip({
    required this.layer,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1565C0) : const Color(0xFFE8F1FA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              layer.icon,
              size: 17,
              color: selected ? Colors.white : const Color(0xFF1565C0),
            ),
            const SizedBox(width: 5),
            Text(
              layer.label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF1565C0),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF1565C0),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Icons.location_on, color: Colors.white, size: 28),
    );
  }
}

class _AttributionLabel extends StatelessWidget {
  const _AttributionLabel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          'OpenStreetMap + OpenWeather',
          style: TextStyle(fontSize: 10, color: Color(0xFF455A64)),
        ),
      ),
    );
  }
}
