import 'package:flutter/material.dart';
import 'package:flutter_application/core/navigation/menu_key.dart';

class AppBarMenu extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarMenu({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1565C0),
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => menuKey.currentState?.open(),
      ),
      elevation: 0,
    );
  }
}
