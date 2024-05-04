import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavBar({
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // return NavBarCupertino(navigationShell: navigationShell);
    return NavBarMaterial(navigationShell: navigationShell);
  }
}

class NavBarMaterial extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavBarMaterial({
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 29;
    const double fontSize = 10;

    final iconColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.grey[600]
            : Colors.grey[500];

    final iconTheme = Theme.of(context).iconTheme.copyWith(
          size: iconSize,
          color: iconColor,
        );

    final selectedIconTheme = Theme.of(context).iconTheme.copyWith(
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        );

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: iconColor,
      selectedFontSize: fontSize,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedFontSize: fontSize,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: iconTheme,
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.creditcard),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.square_list),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.money_dollar_circle),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.doc_on_doc),
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
