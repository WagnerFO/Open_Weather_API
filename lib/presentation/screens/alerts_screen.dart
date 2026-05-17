import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Alertas', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(child: Text('Alertas em breve')),
    );
  }
}
