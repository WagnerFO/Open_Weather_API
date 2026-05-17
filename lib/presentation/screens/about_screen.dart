import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Sobre', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(child: Text('Sobre em breve')),
    );
  }
}
