import 'package:flutter/widgets.dart';
import 'package:met_budget/api/budget_api.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';

import 'package:met_budget/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class DebugButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function() onPressed;

  DebugButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BasicTextButton(
      onPressed: onPressed,
      text: buttonText,
      topMargin: 10,
      bottomMargin: 10,
    );
  }
}

class DebugButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _APITests(),
      ],
    );
  }
}

class _APITests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'All APIs Tests',
      onPressed: () async {
        final msgProvider = context.read<MessagingProvider>();
        final lp = context.read<LoggingProvider>();

        try {
          final budget = await testBudgetAPI();
          final category = await testCategoryAPI(budget);
          final expense = await testExpenseAPI(budget, category);

          await cleanup(
            budget: budget,
            category: category,
            expense: expense,
          );

          msgProvider.showSuccessSnackbar('All API Tests Passed');
        } catch (e, st) {
          msgProvider.showErrorSnackbar(e.toString());
          lp.logError(st.toString());
        }
      },
    );
  }

  Future<Budget> testBudgetAPI() async {
    final api = BudgetAPI();

    final newBudget = Budget.newBudget(
      name: 'Test Budget',
      userId: 'testUserId',
    );

    final addedBudget = await api.addBudget(newBudget);

    var budgets = await api.getBudgets();

    assert(budgets.isNotEmpty);

    final budgetToUpdate = Budget.fromJson({
      ...addedBudget.toJson(),
      'name': 'Updated test budget',
    });

    final oldBudget = await api.updateBudget(budgetToUpdate);

    budgets = await api.getBudgets();

    assert(budgets.isNotEmpty);
    assert(oldBudget.name == addedBudget.name);
    assert(budgets.first.name == budgetToUpdate.name);

    return budgetToUpdate;
  }

  Future<ExpenseCategory> testCategoryAPI(Budget budget) async {
    final api = BudgetAPI();

    final newCat = ExpenseCategory.newCategory(
      budgetId: budget.id,
      name: 'Test Category',
    );

    final addedCat = await api.addCategory(newCat);

    var categories = await api.getCategories(budget.id);

    assert(categories.isNotEmpty);

    final catToUpdate = ExpenseCategory.fromJson({
      ...addedCat.toJson(),
      'name': 'Updated test category',
    });

    final oldCat = await api.updateCategory(catToUpdate);

    categories = await api.getCategories(budget.id);

    assert(categories.isNotEmpty);
    assert(oldCat.name == addedCat.name);
    assert(categories.first.name == catToUpdate.name);

    return oldCat;
  }

  Future<Expense> testExpenseAPI(
    Budget budget,
    ExpenseCategory category,
  ) async {
    final api = BudgetAPI();

    final target = WeeklyExpenseTarget(dayOfWeek: 1);
    final newExpense = Expense.newExpense(
      budgetId: budget.id,
      categoryId: category.id,
      description: 'Expense',
      amount: 1,
      expenseTarget: target,
    );

    final addedExpense = await api.addExpense(newExpense);

    var expenses = await api.getExpenses(budget.id);

    assert(expenses.isNotEmpty);

    final expenseToUpdate = Expense.fromJson({
      ...addedExpense.toJson(),
      'description': 'Updated test expense',
    });

    final oldExpense = await api.updateExpense(expenseToUpdate);

    expenses = await api.getExpenses(budget.id);

    assert(expenses.isNotEmpty);
    assert(oldExpense.description == addedExpense.description);
    assert(expenses.first.description == expenseToUpdate.description);

    return expenseToUpdate;
  }

  Future<void> cleanup({
    required Budget budget,
    required ExpenseCategory category,
    required Expense expense,
  }) async {
    final api = BudgetAPI();

    Future.wait([
      api.deleteBudget(budget.id),
      api.deleteCategory(category.id),
      api.deleteExpense(expense.id),
    ]);
  }
}
