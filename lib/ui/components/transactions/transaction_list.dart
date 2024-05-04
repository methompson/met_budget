import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:met_budget/data_models/budget_transaction.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:provider/provider.dart';

typedef TransactionsList = ({
  List<WithdrawalTransaction> withdrawals,
  List<DepositTransaction> deposits,
});

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, TransactionsList>(
      selector: (_, budgetProvider) => (
        withdrawals: budgetProvider.withdrawalsList,
        deposits: budgetProvider.depositsList,
      ),
      builder: (context, transactions, _) {
        final List<BudgetTransaction> transactionList = [];

        transactionList.addAll(transactions.withdrawals);
        transactionList.addAll(transactions.deposits);

        transactionList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        return ListView.builder(
          itemCount: transactionList.length,
          itemBuilder: (context, index) {
            final transaction = transactionList[index];

            if (transaction is WithdrawalTransaction) {
              return WithdrawalCard(withdrawal: transaction);
            }

            if (transaction is DepositTransaction) {
              return DepositCard(deposit: transaction);
            }

            return Container();
          },
        );
      },
    );
  }
}

class WithdrawalCard extends StatelessWidget {
  final WithdrawalTransaction withdrawal;

  WithdrawalCard({required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(withdrawal.payee),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(withdrawal.dateTime)),
      trailing: Text('-\$${withdrawal.amount.toStringAsFixed(2)}'),
    );
  }
}

class DepositCard extends StatelessWidget {
  final DepositTransaction deposit;

  DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(deposit.payor),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(deposit.dateTime)),
      trailing: Text('\$${deposit.amount.toStringAsFixed(2)}'),
    );
  }
}
