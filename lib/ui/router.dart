import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/ui/pages/login.dart';
import 'package:met_budget/ui/pages/test.dart';

// Pages
// import 'package:met_budget/ui/pages/logging.dart';
// import 'package:met_budget/ui/pages/start.dart';
// import 'package:met_budget/ui/pages/home.dart';
// import 'package:met_budget/ui/pages/login.dart';
// import 'package:met_budget/ui/pages/deposits.dart';
// import 'package:met_budget/ui/pages/settings.dart';
// import 'package:met_budget/ui/pages/withdrawals.dart';

import 'package:met_budget/ui/components/messenger.dart';
// import 'package:met_budget/ui/components/page_container.dart';

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
          builder: (_, __) => TestPage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (_, __) => LoginPage(),
        ),
        // GoRoute(
        //   name: 'logging',
        //   path: '/settings/logging',
        //   builder: (_, __) => LoggingPage(),
        // ),
        // // Authentication Aware Routes & Menu Routes
        // StatefulShellRoute.indexedStack(
        //   builder: (_, routerState, navigationShell) {
        //     return NavContainer(
        //       navigationShell: navigationShell,
        //     );
        //   },
        //   branches: [
        //     StatefulShellBranch(
        //       routes: [
        //         GoRoute(
        //           name: 'home',
        //           path: '/home',
        //           builder: (_, __) => Stack(
        //             children: [
        //               DataWatcher(),
        //               HomePage(),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //     StatefulShellBranch(
        //       routes: [
        //         GoRoute(
        //           name: 'deposits',
        //           path: '/deposits',
        //           builder: (_, __) => DepositsPage(),
        //         ),
        //       ],
        //     ),
        //     StatefulShellBranch(
        //       routes: [
        //         GoRoute(
        //           name: 'withdrawals',
        //           path: '/withdrawals',
        //           builder: (_, __) => WithdrawalsPage(),
        //         ),
        //       ],
        //     ),
        //     StatefulShellBranch(
        //       routes: [
        //         GoRoute(
        //           name: 'settings',
        //           path: '/settings',
        //           builder: (_, __) => SettingsPage(),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);
