import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(child: Text('Configurações em breve')),
    );
  }
}
