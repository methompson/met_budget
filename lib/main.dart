import 'package:flutter/material.dart';
import 'package:met_budget/firebase_options.dart';
import 'package:met_budget/ui/router.dart';
import 'package:met_budget/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:met_budget/ui/components/bootstrapper.dart';
import 'package:met_budget/global_state/authentication_provider.dart';
import 'package:met_budget/global_state/config_provider.dart';
import 'package:met_budget/global_state/data_provider.dart';
import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';

void main() {
  runApp(ProvidersContainer());
}

class ProvidersContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MessagingProvider.instance),
        ChangeNotifierProvider.value(value: ConfigProvider.instance),
        ChangeNotifierProvider.value(value: LoggingProvider.instance),
        ChangeNotifierProvider.value(value: DataProvider.instance),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: _BootStrap(),
    );
  }
}

class _BootStrap extends StatelessWidget {
  @override
  build(BuildContext context) {
    return BootStrapper(
      app: TheApp(),
      initFunction: initializeApp,
    );
  }

  Future<void> initializeApp(BuildContext context) async {
    final authProvider = context.read<AuthenticationProvider>();

    await DataProvider.instance.init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final currentUser = FirebaseAuth.instance.currentUser;

    authProvider.setAuthentication(currentUser);

    await ConfigProvider.instance.init();

    await LoggingProvider.instance.init();

    if (currentUser != null) {
      // init the budget here
    }
  }
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: snackbarMessengerKey,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
