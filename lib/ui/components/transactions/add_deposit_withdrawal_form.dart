import 'package:flutter/material.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/ui/components/transactions/add_deposit_form.dart';
import 'package:met_budget/ui/components/transactions/add_withdrawal_form.dart';
import 'package:provider/provider.dart';

class AddDepositWithdrawalForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bp = context.read<BudgetProvider>();

    return bp.currentBudget == null
        ? Center(
            child: Text('No budget selected'),
          )
        : DepositWithdrawalTabView();
  }
}

class DepositWithdrawalTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Transaction'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Withdrawal'),
              Tab(text: 'Deposit'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddWithdrawalForm(),
            AddDepositForm(),
          ],
        ),
      ),
    );
  }
}
