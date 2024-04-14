import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
// import 'package:met_budget/global_state/vice_bank_provider.dart';

import 'package:met_budget/ui/components/buttons.dart';

import 'package:met_budget/global_state/authentication_provider.dart';

class LoginFields extends StatefulWidget {
  LoginFields({super.key});

  @override
  State<LoginFields> createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Image.asset(
            'assets/images/budget_logo_1024_transparent.png',
            fit: BoxFit.contain,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: _emailController,
            // placeholder: 'Email',
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: BasicBigTextButton(
            onPressed: loginUser,
            text: 'Login',
          ),
        ),
      ],
    );
  }

  loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final authProvider = context.read<AuthenticationProvider>();
    final msgProvider = context.read<MessagingProvider>();

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Logging in...'),
    );

    try {
      // Authenticate the user
      await authProvider.logUserIn(email, password);

      msgProvider.setLoadingScreenData(
        LoadingScreenData(message: 'Getting user data...'),
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      await authProvider.signOut();
      msgProvider.showErrorSnackbar(
        'Error logging in: $e',
      );
    }

    msgProvider.clearLoadingScreen();
  }
}
