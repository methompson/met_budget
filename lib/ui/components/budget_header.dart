import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/global_state/budget_provider.dart';

class BudgetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bProvider = context.watch<BudgetProvider>();

    final budget = bProvider.currentBudget;

    if (budget == null) {
      return Container();
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        title: Text(
          budget.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: Text(
          'Current Funds: \$${budget.currentFunds.toStringAsFixed(2)}',
        ),
      ),
    );
  }
}
