import 'package:flutter/cupertino.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/data_models/reconciliation.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';

class BudgetProvider extends ChangeNotifier {
  String? _currentBudget;

  Map<String, Budget> _budgets = {};
  Map<String, ExpenseCategory> _categories = {};
  Map<String, Expense> _expenses = {};
  List<DepositTransaction> _deposits = [];
  List<WithdrawalTransaction> _withdrawals = [];
  List<Reconciliation> _reconciliations = [];

  Budget? get currentBudget => _budgets[_currentBudget ?? ''];

  Map<String, Budget> get budgets => _budgets;
  Map<String, ExpenseCategory> get categories => _categories;
  Map<String, Expense> get expenses => _expenses;
  List<DepositTransaction> get deposits => _deposits;
  List<WithdrawalTransaction> get withdrawals => _withdrawals;
  List<Reconciliation> get reconciliations => _reconciliations;

  Future<void> init() async {}

  // perform an inline sort of deposits
  void sortDeposits() {
    _deposits.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // perform an inline sort of reconciliations
  void sortReconciliation() {
    _reconciliations.sort((a, b) => b.date.compareTo(a.date));
  }

  // perform an inline sort of withdrawals
  void sortWithdrawals() {
    _withdrawals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> selectBudget(String? budgetId) async {
    final budget = _budgets[budgetId ?? ''];

    _currentBudget = budget?.id;

    // TODO Persist data
  }
}
