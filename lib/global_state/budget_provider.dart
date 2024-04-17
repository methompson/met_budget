import 'package:flutter/cupertino.dart';
import 'package:met_budget/api/budget_api.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/data_models/reconciliation.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';
import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/utils/list_to_map.dart';

class BudgetProvider extends ChangeNotifier {
  Map<String, Budget> _budgets = {};
  Map<String, ExpenseCategory> _categories = {};
  Map<String, Expense> _expenses = {};
  List<DepositTransaction> _deposits = [];
  List<WithdrawalTransaction> _withdrawals = [];
  List<Reconciliation> _reconciliations = [];

  String? _currentBudget;
  Budget? get currentBudget => _budgets[_currentBudget ?? ''];

  Map<String, Budget> get budgets => _budgets;
  Map<String, ExpenseCategory> get categories => _categories;
  Map<String, Expense> get expenses => _expenses;
  List<DepositTransaction> get deposits => _deposits;
  List<WithdrawalTransaction> get withdrawals => _withdrawals;
  List<Reconciliation> get reconciliations => _reconciliations;

  BudgetAPI? _budgetAPI;
  @visibleForTesting
  BudgetAPI? get budgetAPI => _budgetAPI;
  @visibleForTesting
  set budgetAPI(BudgetAPI? value) {
    _budgetAPI = value;
  }

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

  Future<void> getBudgets() async {
    final api = _budgetAPI ?? BudgetAPI();
    final budgets = await api.getBudgets();

    _budgets = listToMap(budgets, (b) => b.id);

    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newBudget = await api.addBudget(budget);

    _budgets[newBudget.id] = newBudget;

    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateBudget(budget);

    _budgets[response.budget.id] = response.budget;

    notifyListeners();
  }

  Future<void> deleteBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    await api.deleteBudget(budget.id);
    _budgets.remove(budget.id);

    notifyListeners();
  }

  Future<void> getCategories() async {
    final api = _budgetAPI ?? BudgetAPI();
    final categories = await api.getCategories(_currentBudget ?? '');

    _categories = listToMap(categories, (c) => c.id);

    notifyListeners();
  }

  Future<void> addCategory(ExpenseCategory category) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newCategory = await api.addCategory(category);

    _categories[newCategory.id] = newCategory;

    notifyListeners();
  }

  Future<void> updateCategory(ExpenseCategory category) async {}
  Future<void> deleteCategory(ExpenseCategory category) async {}

  Future<void> getExpenses() async {
    final api = _budgetAPI ?? BudgetAPI();
    final expenses = await api.getExpenses(_currentBudget ?? '');

    _expenses = listToMap(expenses, (e) => e.id);

    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newExpense = await api.addExpense(expense);

    _expenses[newExpense.id] = newExpense;

    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {}
  Future<void> deleteExpense(Expense expense) async {}

  Future<void> getDeposits({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();

    DateTime st, et;

    if (startTime != null && endTime != null) {
      st = startTime;
      et = endTime;
    } else {
      final now = DateTime.now();
      st = DateTime(now.year, now.month, 1);
      et = DateTime(now.year, now.month + 1, 0);
    }

    _deposits = await api.getDeposits(cb, st, et);
    sortDeposits();

    notifyListeners();
  }

  Future<void> addDeposit(DepositTransaction deposit) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addDeposit(deposit);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _deposits.add(response.deposit);
    sortDeposits();

    notifyListeners();
  }

  Future<void> updateDeposit(DepositTransaction deposit) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateDeposit(deposit);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _deposits.removeWhere((el) => el.id == response.deposit.id);
    _deposits.add(response.deposit);
    sortDeposits();

    notifyListeners();
  }

  Future<void> deleteDeposit(DepositTransaction deposit) async {}

  Future<void> getWithdrawals({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();

    DateTime st, et;

    if (startTime != null && endTime != null) {
      st = startTime;
      et = endTime;
    } else {
      final now = DateTime.now();
      st = DateTime(now.year, now.month, 1);
      et = DateTime(now.year, now.month + 1, 0);
    }

    _withdrawals = await api.getWithdrawals(cb, st, et);
    sortWithdrawals();

    notifyListeners();
  }

  Future<void> addWithdrawal(WithdrawalTransaction withdrawal) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addWithdrawal(withdrawal);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _withdrawals.add(response.withdrawal);
    sortWithdrawals();

    notifyListeners();
  }

  Future<void> updateWithdrawal(WithdrawalTransaction withdrawal) async {}
  Future<void> deleteWithdrawal(WithdrawalTransaction withdrawal) async {}

  Future<void> getReconciliations() async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();

    _reconciliations = await api.getReconciliations(cb);
    sortReconciliation();

    notifyListeners();
  }

  Future<void> addReconciliation(Reconciliation reconciliation) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      return;
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addReconciliation(reconciliation);

    final updatedBudget = cb.updateFunds(reconciliation.balance);
    _budgets[cb.id] = updatedBudget;

    _reconciliations.add(response);
    sortReconciliation();

    notifyListeners();
  }

  Future<void> updateReconciliation(Reconciliation reconciliation) async {}
}
