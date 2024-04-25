import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/ui/components/budget_header.dart';
import 'package:met_budget/ui/components/budgets/no_budget_selected.dart';
import 'package:met_budget/ui/components/page_container.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, budget, _) {
        final child = budget != null ? _BudgetContent() : NoBudgetSelected();

        return CenteredFullSizeContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

class _BudgetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BudgetHeader(),
        Text('Budget Page'),
      ],
    );
  }
}
