import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarMenu(title: 'Mapa'),
      body: Center(child: Text('Mapa em Breve')),
    );
  }
}
