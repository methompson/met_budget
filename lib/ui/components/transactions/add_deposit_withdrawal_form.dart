import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/transactions/add_deposit_form.dart';
import 'package:met_budget/ui/components/transactions/add_withdrawal_form.dart';

class AddDepositWithdrawalForm extends StatelessWidget {
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
