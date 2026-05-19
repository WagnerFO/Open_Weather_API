import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/widgets/edge_menu.dart';

final menuKey = GlobalKey<EdgeMenuState>();

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
