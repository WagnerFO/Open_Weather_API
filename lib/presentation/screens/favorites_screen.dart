import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarMenu(title: 'Favoritos'),
      body: Center(child: Text('Favoritos em breve')),
    );
  }
}
