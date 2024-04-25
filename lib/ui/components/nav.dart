import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.money_dollar_circle),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.plus_circle),
          label: 'Reports',
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
