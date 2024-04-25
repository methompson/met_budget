import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:met_budget/ui/pages/budget.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:met_budget/ui/pages/expenses.dart';
import 'package:met_budget/ui/pages/reports.dart';
import 'package:met_budget/ui/pages/login.dart';
import 'package:met_budget/ui/pages/logging.dart';
import 'package:met_budget/ui/pages/start.dart';
import 'package:met_budget/ui/pages/settings.dart';

import 'package:met_budget/ui/components/messenger.dart';
import 'package:met_budget/ui/components/page_container.dart';

import 'package:met_budget/global_state/authentication_provider.dart';

final router = GoRouter(
  redirect: (context, goRouterState) {
    final authProvider = context.read<AuthenticationProvider>();

    if (goRouterState.path != '/login' && authProvider.isAuthenticated) {
      return null;
    }

    return '/login';
  },
  initialLocation: '/',
  routes: [
    // All Routes that need loading screens and snackbars
    ShellRoute(
      builder: (_, __, child) => Messenger(child),
      routes: [
        GoRoute(
          name: 'start',
          path: '/',
          builder: (_, __) => StartPage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (_, __) => LoginPage(),
        ),
        GoRoute(
          name: 'logging',
          path: '/settings/logging',
          builder: (_, __) => LoggingPage(),
        ),
        // Authentication Aware Routes & Menu Routes
        StatefulShellRoute.indexedStack(
          builder: (_, routerState, navigationShell) {
            return NavContainer(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'budget',
                  path: '/home',
                  builder: (_, __) => Stack(
                    children: [
                      DataWatcher(),
                      BudgetPage(),
                    ],
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'expenses',
                  path: '/expenses',
                  builder: (_, __) => ExpensesPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'reports',
                  path: '/reports',
                  builder: (_, __) => ReportsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'settings',
                  path: '/settings',
                  builder: (_, __) => SettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
