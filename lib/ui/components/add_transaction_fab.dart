import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:met_budget/ui/components/transactions/add_deposit_withdrawal_form.dart';

class AddTransactionFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showTransactionDialog(context);
      },
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }

  void showTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Scaffold(
        body: FullSizeContainer(
          child: AddDepositWithdrawalForm(),
        ),
      ),
    );
  }
}
