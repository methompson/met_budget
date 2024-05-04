import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:met_budget/ui/components/add_transaction_fab.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/ui/components/nav.dart';
import 'package:met_budget/utils/agent/agent.dart';

import 'package:met_budget/ui/components/authentication_watcher.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  PageContainer({
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: child,
    );
  }
}

class NavContainer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget? appBar;
  final bool showFAB;

  NavContainer({
    required this.navigationShell,
    this.appBar,
    this.showFAB = true,
  });

  @override
  Widget build(BuildContext context) {
    final padding = AgentGetter().isPWA() ? 25.0 : 0.0;

    final fab = Offstage(
      offstage: !showFAB,
      child: AddTransactionFAB(),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: AuthenticationWatcher(navigationShell)),
      floatingActionButton: fab,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: padding, top: 1),
        child: NavBar(navigationShell: navigationShell),
      ),
    );
  }
}

class FullSizeContainer extends StatelessWidget {
  final Widget child;

  FullSizeContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.greenAccent,
      constraints: BoxConstraints.expand(),
      child: child,
    );
  }
}

class CenteredFullSizeContainer extends StatelessWidget {
  final Widget child;

  CenteredFullSizeContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueAccent,
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
        ],
      ),
    );
  }
}

class DataWatcher extends StatefulWidget {
  @override
  State createState() => DataWatcherState();
}

class DataWatcherState extends State<DataWatcher> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    getDataAndResetTimer();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, String?>(
      selector: (_, bProvider) => bProvider.currentBudget?.id,
      builder: (_, budgetId, __) {
        if (budgetId == null) {
          _timer?.cancel();
          _timer = null;
        } else {
          getDataAndResetTimer();
        }

        return Container();
      },
    );
  }

  Future<void> getDataAndResetTimer() async {
    _timer?.cancel();
    await getApiData();
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(
      Duration(minutes: 10),
      getDataAndResetTimer,
    );
  }

  Future<void> getApiData() async {
    try {
      await Future.wait([
        getUserData(),
        getDataForUser(),
      ]);
    } catch (e) {
      LoggingProvider.instance.logError('Error getting data: $e');
    }
  }

  Future<void> getDataForUser() async {
    final bProvider = context.read<BudgetProvider>();
    if (bProvider.currentBudget == null) {
      return;
    }

    try {
      // await bProvider.getAllUserData();
    } catch (e) {
      LoggingProvider.instance.logError('Error getting user data: $e');
    }
  }

  Future<void> getUserData() async {
    final bProvider = context.read<BudgetProvider>();
    try {
      await bProvider.getBudgets();
    } catch (e) {
      LoggingProvider.instance.logError('Error getting user data: $e');
    }
  }
}
