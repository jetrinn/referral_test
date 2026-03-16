import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        selectedItemColor: const Color(0xFF14C699),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.house),
            activeIcon: Icon(PhosphorIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.identification_card),
            activeIcon: Icon(PhosphorIcons.identification_card_fill),
            label: 'Membership',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.user_plus),
            activeIcon: Icon(PhosphorIcons.user_plus_fill),
            label: 'Refer',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.coin),
            activeIcon: Icon(PhosphorIcons.coin_fill),
            label: 'Points',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/membership')) {
      return 1;
    }
    if (location.startsWith('/refer')) {
      return 2;
    }
    if (location.startsWith('/points')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/membership');
        break;
      case 2:
        context.go('/refer');
        break;
      case 3:
        context.go('/points');
        break;
    }
  }
}
