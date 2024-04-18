import 'package:flutter/material.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, budget, _) {
        return Center(
          child: Text('Transactions Page'),
        );
      },
    );
  }
}
