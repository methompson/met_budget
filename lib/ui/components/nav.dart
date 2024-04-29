import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:met_budget/ui/components/transactions/add_deposit_withdrawal_form.dart';

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

class NavBarCupertino extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavBarCupertino({required this.navigationShell});

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

class NavBarMaterial extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  NavBarMaterial({
    required this.navigationShell,
  });

  @override
  State createState() => NavBarMaterialState();
}

class NavBarMaterialState extends State<NavBarMaterial> {
  var _lastIndex = 0;

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
          icon: Icon(Icons.payments_outlined),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.money_dollar_circle),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.plus_circle, size: 42),
          label: 'Transaction',
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
      currentIndex: _lastIndex,
      onTap: (index) => _onTap(index),
    );
  }

  void _onTap(int index) {
    if (index == 2) {
      showTransactionDialog();
      return;
    }

    var theIndex = index;
    if (index > 2) {
      theIndex = index - 1;
    } else if (index == 2) {
      theIndex = 1;
    }

    if (index != 2) {
      _lastIndex = index;
    }

    widget.navigationShell.goBranch(
      theIndex,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void showTransactionDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Scaffold(
        body: FullSizeContainer(
          child: AddDepositWithdrawalForm(),
        ),
      ),
    );
  }
}
