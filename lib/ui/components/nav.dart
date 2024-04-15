import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.money_dollar_circle),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.arrow_up_arrow_down_circle),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onTap(index),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
