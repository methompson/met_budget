import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/global_state/authentication_provider.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = context.read<AuthenticationProvider>();

      if (authModel.isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });

    return Container();
  }
}
