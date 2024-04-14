import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/global_state/config_provider.dart';
import 'package:met_budget/ui/components/copyright_bar.dart';
import 'package:met_budget/ui/components/login/debug_section.dart';
import 'package:met_budget/ui/components/login/login_fields.dart';
import 'package:met_budget/ui/components/messenger.dart';
import 'package:met_budget/ui/components/page_container.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ConfigProvider, bool>(
      selector: (_, config) => config.getConfig('debugMode').boolean,
      builder: (context, debugMode, child) {
        return PageContainer(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: LoginFields(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (debugMode) LoginDebugSection(),
                CopyrightBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Messenger(Login());
  }
}
