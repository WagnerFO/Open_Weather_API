import 'package:flutter/material.dart';
import 'package:flutter_application/core/navigation/app_router.dart';

class EdgeMenu extends StatefulWidget {
  final Widget child;

  const EdgeMenu({super.key, required this.child});

  @override
  State<EdgeMenu> createState() => EdgeMenuState();
}

class EdgeMenuState extends State<EdgeMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _SlideAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _SlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void open() {
    setState(() => _isOpen = true);
    _controller.forward();
  }

  void close() {
    _controller.reverse().then((_) {
      setState(() => _isOpen = false);
    });
  }

  void _navigate(String route) {
    close();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pushNamed(context, route);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth * 0.62;

    return Stack(
      children: [
        widget.child,
        if (_isOpen) ...[
          Positioned(
            left: menuWidth,
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: close,
              child: Container(color: Colors.black.withOpacity(0.28)),
            ),
          ),
          SlideTransition(
            position: _SlideAnimation,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: menuWidth,
                height: double.infinity,
                child: _MenuPanel(onClose: close, onNavigate: _navigate),
              ),
            ),
          ),
          Positioned(
            left: menuWidth - 10,
            top: 0,
            bottom: 0,
            width: 10,
            child: Container(color: const Color(0xFF0D47A1)),
          ),
        ],
      ],
    );
  }
}

class _MenuPanel extends StatelessWidget {
  final VoidCallback onClose;
  final void Function(String route) onNavigate;
  const _MenuPanel({required this.onClose, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF90CAF9),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF0C447C)),
              onPressed: onClose,
            ),
          ),
          _MenuItem(
            icon: Icons.home_outlined,
            label: 'Início',
            onTap: () => onNavigate(AppRouter.home),
          ),
          const _MenuDivider(),
          _MenuItem(
            icon: Icons.map_outlined,
            label: 'Mapa',
            onTap: () => onNavigate(AppRouter.map),
          ),
          _MenuItem(
            icon: Icons.star_outline,
            label: 'Favoritos',
            onTap: () => onNavigate(AppRouter.favorites),
          ),
          _MenuItem(
            icon: Icons.notifications_outlined,
            label: 'Alertas',
            onTap: () => onNavigate(AppRouter.alerts),
          ),
          const _MenuDivider(),
          _MenuItem(
            icon: Icons.settings_outlined,
            label: 'Configurações',
            onTap: () => onNavigate(AppRouter.settings),
          ),
          _MenuItem(
            icon: Icons.info_outline,
            label: 'Sobre',
            onTap: () => onNavigate(AppRouter.about),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF1565C0),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      color: Colors.white.withOpacity(0.4),
    );
  }
}
