import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Favoritos', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(child: Text('Favoritos em breve')),
    );
  }
}
