import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Mapa', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(child: Text('Mapa em Breve')),
    );
  }
}
