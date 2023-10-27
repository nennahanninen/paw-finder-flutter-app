import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 15.0,
              spreadRadius: 0.1,
              offset: Offset(0.0, 0.75),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xffFF966A),
          type: BottomNavigationBarType.fixed,
          currentIndex: _calculateSelectedIndex(context),
          selectedLabelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.2, 1.2),
                blurRadius: 15.0,
                color: Colors.black,
              ),
            ],
          ),
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          onTap: onTap,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded, color: Colors.white),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/dog_paw_location_icon.png",
                  color: Colors.white,
                  width: 30,
                  height: 30,
                ),
                label: 'Map'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded, color: Colors.white),
                label: 'Settings'),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location == '/home') {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 0;
    }
    if (location.startsWith('/map')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0;
  }

  void onTap(int value) {
    switch (value) {
      case 0:
        return context.go('/profile');
      case 1:
        return context.go('/map');
      case 2:
        return context.go('/settings');
      default:
        return context.go('/home');
    }
  }
}
