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
  Map<String, DepositTransaction> _deposits = {};
  Map<String, WithdrawalTransaction> _withdrawals = {};
  Map<String, Reconciliation> _reconciliations = {};

  String? _currentBudget;
  Budget? get currentBudget => _budgets[_currentBudget ?? ''];

  Map<String, Budget> get budgets => _budgets;
  Map<String, ExpenseCategory> get categories => _categories;
  Map<String, Expense> get expenses => _expenses;
  Map<String, DepositTransaction> get deposits => _deposits;
  Map<String, WithdrawalTransaction> get withdrawals => _withdrawals;
  Map<String, Reconciliation> get reconciliations => _reconciliations;

  List<Budget> get budgetsList {
    final list = _budgets.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  List<DepositTransaction> get depositsList {
    final list = _deposits.values.toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  List<WithdrawalTransaction> get withdrawalsList {
    final list = _withdrawals.values.toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  List<Reconciliation> get reconciliationsList {
    final list = _reconciliations.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  BudgetAPI? _budgetAPI;
  @visibleForTesting
  BudgetAPI? get budgetAPI => _budgetAPI;
  @visibleForTesting
  set budgetAPI(BudgetAPI? value) {
    _budgetAPI = value;
  }

  Future<void> clearCache() async {
    // final prefs = await SharedPreferences.getInstance();

    _currentBudget = null;
    _budgets = {};
    _categories = {};
    _expenses = {};
    _deposits = {};
    _withdrawals = {};
    _reconciliations = {};

    // await prefs.remove(viceBankUsersKey);
    // await prefs.remove(viceBankCurrentUserKey);

    notifyListeners();
  }

  Future<void> init() async {}

  Future<void> selectBudget(String? budgetId) async {
    final budget = _budgets[budgetId ?? ''];

    _currentBudget = budget?.id;

    // TODO Persist data

    if (_currentBudget == null) {
      _categories = {};
      _expenses = {};
      _deposits = {};
      _withdrawals = {};
      _reconciliations = {};
    } else {
      await getAllBudgetData();
    }

    notifyListeners();
  }

  Future<void> getAllBudgetData() async {
    await Future.wait([
      getCategories(),
      getExpenses(),
      getDeposits(),
      getWithdrawals(),
      getReconciliations(),
    ]);
  }

  Future<List<Budget>> getBudgets() async {
    final api = _budgetAPI ?? BudgetAPI();
    final budgets = await api.getBudgets();

    _budgets = listToMap(budgets, (b) => b.id);

    notifyListeners();

    return budgets;
  }

  Future<Budget> addBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newBudget = await api.addBudget(budget);

    _budgets[newBudget.id] = newBudget;

    notifyListeners();

    return newBudget;
  }

  Future<UpdateBudgetResponse> updateBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateBudget(budget);

    _budgets[response.budget.id] = response.budget;

    notifyListeners();

    return response;
  }

  Future<Budget> deleteBudget(Budget budget) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteBudget(budget.id);
    _budgets.remove(budget.id);

    notifyListeners();

    return response;
  }

  Future<List<ExpenseCategory>> getCategories() async {
    final api = _budgetAPI ?? BudgetAPI();
    final categories = await api.getCategories(_currentBudget ?? '');

    _categories = listToMap(categories, (c) => c.id);

    notifyListeners();

    return categories;
  }

  Future<ExpenseCategory> addCategory(ExpenseCategory category) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newCategory = await api.addCategory(category);

    _categories[newCategory.id] = newCategory;

    notifyListeners();

    return newCategory;
  }

  Future<UpdateExpenseCategoryResponse> updateCategory(
      ExpenseCategory category) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateCategory(category);

    _categories[response.category.id] = response.category;

    notifyListeners();

    return response;
  }

  Future<ExpenseCategory> deleteCategory(ExpenseCategory category) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteCategory(category.id);
    _categories.remove(category.id);

    notifyListeners();

    return response;
  }

  Future<List<Expense>> getExpenses() async {
    final api = _budgetAPI ?? BudgetAPI();
    final expenses = await api.getExpenses(_currentBudget ?? '');

    _expenses = listToMap(expenses, (e) => e.id);

    notifyListeners();

    return expenses;
  }

  Future<Expense> addExpense(Expense expense) async {
    final api = _budgetAPI ?? BudgetAPI();
    final newExpense = await api.addExpense(expense);

    _expenses[newExpense.id] = newExpense;

    notifyListeners();

    return newExpense;
  }

  Future<UpdateExpenseResponse> updateExpense(Expense expense) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateExpense(expense);

    _expenses[response.expense.id] = response.expense;

    notifyListeners();

    return response;
  }

  Future<Expense> deleteExpense(Expense expense) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteExpense(expense.id);
    _expenses.remove(expense.id);

    notifyListeners();

    return response;
  }

  Future<List<DepositTransaction>> getDeposits({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
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

    final depositsList = await api.getDeposits(cb, st, et);
    _deposits = listToMap(depositsList, (d) => d.id);

    notifyListeners();

    return depositsList;
  }

  Future<AddDepositResponse> addDeposit(DepositTransaction deposit) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addDeposit(deposit);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _deposits[response.deposit.id] = response.deposit;

    notifyListeners();

    return response;
  }

  Future<UpdateDepositResponse> updateDeposit(
      DepositTransaction deposit) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateDeposit(deposit);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _deposits[response.deposit.id] = response.deposit;

    notifyListeners();

    return response;
  }

  Future<DeleteDepositResponse> deleteDeposit(
      DepositTransaction deposit) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteDeposit(deposit.id);
    _deposits.remove(deposit.id);

    notifyListeners();

    return response;
  }

  Future<List<WithdrawalTransaction>> getWithdrawals({
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
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

    final wList = await api.getWithdrawals(cb, st, et);
    _withdrawals = listToMap(wList, (w) => w.id);

    notifyListeners();

    return wList;
  }

  Future<AddWithdrawalResponse> addWithdrawal(
    WithdrawalTransaction withdrawal,
  ) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addWithdrawal(withdrawal);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _withdrawals[response.withdrawal.id] = response.withdrawal;

    notifyListeners();

    return response;
  }

  Future<UpdateWithdrawalResponse> updateWithdrawal(
      WithdrawalTransaction withdrawal) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.updateWithdrawal(withdrawal);

    final updatedBudget = cb.updateFunds(response.currentFunds);
    _budgets[cb.id] = updatedBudget;

    _withdrawals[response.withdrawal.id] = response.withdrawal;

    notifyListeners();

    return response;
  }

  Future<DeleteWithdrawalResponse> deleteWithdrawal(
      WithdrawalTransaction withdrawal) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteWithdrawal(withdrawal.id);
    _withdrawals.remove(withdrawal.id);

    notifyListeners();

    return response;
  }

  Future<List<Reconciliation>> getReconciliations() async {
    final cb = _currentBudget;

    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();

    final rList = await api.getReconciliations(cb);
    _reconciliations = listToMap(rList, (r) => r.id);

    notifyListeners();

    return rList;
  }

  Future<Reconciliation> addReconciliation(
    Reconciliation reconciliation,
  ) async {
    final cb = currentBudget;
    if (cb == null) {
      LoggingProvider.instance.logError('No current budget set');
      throw Exception('No current budget set');
    }

    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.addReconciliation(reconciliation);

    final updatedBudget = cb.updateFunds(reconciliation.balance);
    _budgets[cb.id] = updatedBudget;

    _reconciliations[response.id] = response;

    notifyListeners();

    return response;
  }

  Future<DeleteReconciliationResponse> deleteReconciliation(
      Reconciliation reconciliation) async {
    final api = _budgetAPI ?? BudgetAPI();
    final response = await api.deleteReconciliation(reconciliation.id);
    _reconciliations.remove(reconciliation.id);

    notifyListeners();

    return response;
  }
}
