import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/budgets/no_budget_selected.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, budget, _) {
        final child = budget != null ? Text('Budget!') : NoBudgetSelected();

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
