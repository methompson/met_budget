import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';

class ExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, value, _) {
        return Center(
          child: Text('Expenses Page'),
        );
      },
    );
  }
}
