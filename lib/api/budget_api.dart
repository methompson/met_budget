import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:met_budget/api/api_common.dart';
import 'package:met_budget/api/auth_utils.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/data_models/reconciliation.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';
import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/utils/8601_date.dart';
import 'package:met_budget/utils/type_checker.dart';

typedef AddDepositResponse = ({
  DepositTransaction deposit,
  num currentFunds,
});

typedef AddWithdrawalResponse = ({
  WithdrawalTransaction withdrawal,
  num currentFunds,
});

class BudgetAPI extends APICommon {
  Future<List<Budget>> getBudgets() async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/budgets',
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final budgetsList = isTypeError<List>(bodyJson['budgets']);

    final List<Budget> budgets = [];
    final errors = <dynamic>[];

    for (final b in budgetsList) {
      try {
        final budget = Budget.fromJson(b);
        budgets.add(budget);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing budgets: $errors',
      );
    }

    return budgets;
  }

  Future<Budget> addBudget(Budget newBudget) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addBudget');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'budget': newBudget.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedBudget = Budget.fromJson(bodyJson['budget']);

    return addedBudget;
  }

  Future<Budget> updateBudget(Budget updatedBudget) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateBudget');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'budget': updatedBudget.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldBudget = Budget.fromJson(bodyJson['oldBudget']);

    return oldBudget;
  }

  Future<Budget> deleteBudget(String budgetId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteBudget');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'budgetId': budgetId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldBudget = Budget.fromJson(bodyJson['budget']);

    return oldBudget;
  }

  Future<List<ExpenseCategory>> getCategories(String budgetId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/categories',
      {'budgetId': budgetId},
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final categoriesList = isTypeError<List>(bodyJson['categories']);

    final List<ExpenseCategory> categories = [];
    final errors = <dynamic>[];

    for (final c in categoriesList) {
      try {
        final cat = ExpenseCategory.fromJson(c);
        categories.add(cat);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing categories: $errors',
      );
    }

    return categories;
  }

  Future<ExpenseCategory> addCategory(ExpenseCategory newCategory) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addCategory');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'category': newCategory.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedCat = ExpenseCategory.fromJson(bodyJson['category']);

    return addedCat;
  }

  Future<ExpenseCategory> updateCategory(
    ExpenseCategory updatedCategory,
  ) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateCategory');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'category': updatedCategory.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldCategory = ExpenseCategory.fromJson(bodyJson['oldCategory']);

    return oldCategory;
  }

  Future<ExpenseCategory> deleteCategory(String categoryId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteCategory');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'categoryId': categoryId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldCategory = ExpenseCategory.fromJson(bodyJson['category']);

    return oldCategory;
  }

  Future<List<Expense>> getExpenses(String budgetId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/expenses',
      {'budgetId': budgetId},
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final expensesList = isTypeError<List>(bodyJson['expenses']);

    final List<Expense> expenses = [];
    final errors = <dynamic>[];

    for (final e in expensesList) {
      try {
        final exp = Expense.fromJson(e);
        expenses.add(exp);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing categories: $errors',
      );
    }

    return expenses;
  }

  Future<Expense> addExpense(Expense newExpense) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addExpense');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'expense': newExpense.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedExpense = Expense.fromJson(bodyJson['expense']);

    return addedExpense;
  }

  Future<Expense> updateExpense(Expense updatedExpense) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateExpense');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'expense': updatedExpense.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldExpense = Expense.fromJson(bodyJson['oldExpense']);

    return oldExpense;
  }

  Future<Expense> deleteExpense(String expenseId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteExpense');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'expenseId': expenseId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldExpense = Expense.fromJson(bodyJson['expense']);

    return oldExpense;
  }

  Future<List<DepositTransaction>> getDeposits(
    String budgetId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/deposits',
      {
        'budgetId': budgetId,
        'startDate': toISO8601Date(startDate),
        'endDate': toISO8601Date(endDate),
      },
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final depositsList = isTypeError<List>(bodyJson['deposits']);

    final List<DepositTransaction> deposits = [];
    final errors = <dynamic>[];

    for (final d in depositsList) {
      try {
        final deposit = DepositTransaction.fromJson(d);
        deposits.add(deposit);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing deposits: $errors',
      );
    }

    return deposits;
  }

  Future<AddDepositResponse> addDeposit(DepositTransaction newDeposit) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addDeposit');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'deposit': newDeposit.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedDeposit = DepositTransaction.fromJson(bodyJson['deposit']);
    final currentFunds = isTypeError<num>(bodyJson['currentFunds']);

    return (
      deposit: addedDeposit,
      currentFunds: currentFunds,
    );
  }

  Future<void> updateDeposit() async {}
  Future<void> deleteDeposit() async {}

  Future<List<WithdrawalTransaction>> getWithdrawals(
    String budgetId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/withdrawals',
      {
        'budgetId': budgetId,
        'startDate': toISO8601Date(startDate),
        'endDate': toISO8601Date(endDate),
      },
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final withdrawalsList = isTypeError<List>(bodyJson['withdrawals']);

    final List<WithdrawalTransaction> withdrawals = [];
    final errors = <dynamic>[];

    for (final w in withdrawalsList) {
      try {
        final withdrawal = WithdrawalTransaction.fromJson(w);
        withdrawals.add(withdrawal);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing withdrawals: $errors',
      );
    }

    return withdrawals;
  }

  Future<AddWithdrawalResponse> addWithdrawal(
    WithdrawalTransaction newWithdrawal,
  ) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addWithdrawal');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'withdrawal': newWithdrawal.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedWith = WithdrawalTransaction.fromJson(bodyJson['withdrawal']);
    final currentFunds = isTypeError<num>(bodyJson['currentFunds']);

    return (
      withdrawal: addedWith,
      currentFunds: currentFunds,
    );
  }

  Future<void> updateWithdrawal() async {}
  Future<void> deleteWithdrawal() async {}

  Future<List<Reconciliation>> getReconciliations() async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/reconciliations',
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final reconciliationsList = isTypeError<List>(bodyJson['reconciliations']);

    final List<Reconciliation> reconciliations = [];
    final errors = <dynamic>[];

    for (final r in reconciliationsList) {
      try {
        final reconciliation = Reconciliation.fromJson(r);
        reconciliations.add(reconciliation);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing reconciliations: $errors',
      );
    }

    return reconciliations;
  }

  Future<Reconciliation> addReconciliation(Reconciliation newRecon) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addReconciliation');

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'reconciliation': newRecon.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedRecon = Reconciliation.fromJson(bodyJson['reconciliation']);

    return addedRecon;
  }

  Future<void> deleteReconciliation() async {}
}
