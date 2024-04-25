import 'package:flutter/widgets.dart';
import 'package:met_budget/global_state/config_provider.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/api/budget_api.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/data_models/reconciliation.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';

class DebugButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _APITests(),
        _ProviderTest(),
        _DisableDebugMode(),
      ],
    );
  }
}

class _DebugButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function() onPressed;

  _DebugButton({
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

class _APITests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DebugButton(
      buttonText: 'All APIs Tests',
      onPressed: () async {
        final msgProvider = context.read<MessagingProvider>();
        final lp = context.read<LoggingProvider>();

        try {
          final budget = await testBudgetAPI();
          final category = await testCategoryAPI(budget);
          final expense = await testExpenseAPI(budget, category);
          final deposit = await testDepositAPI(budget);
          final withdrawal = await testWithdrawalAPI(budget, expense);
          final recon = await testReconciliationAPI(budget);

          await cleanup(
            budget: budget,
            category: category,
            expense: expense,
            deposit: deposit,
            withdrawal: withdrawal,
            recon: recon,
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
    );

    final addedBudget = await api.addBudget(newBudget);

    var budgets = await api.getBudgets();

    assert(budgets.isNotEmpty);

    final budgetToUpdate = Budget.fromJson({
      ...addedBudget.toJson(),
      'name': 'Updated test budget',
    });

    final updatedBudget = await api.updateBudget(budgetToUpdate);

    assert(updatedBudget.oldBudget.name == addedBudget.name);
    assert(updatedBudget.budget.name == budgetToUpdate.name);

    budgets = await api.getBudgets();

    assert(budgets.isNotEmpty);
    assert(budgets.first.name == budgetToUpdate.name);

    return updatedBudget.budget;
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

    final updatedCat = await api.updateCategory(catToUpdate);

    assert(updatedCat.oldCategory.name == addedCat.name);
    assert(updatedCat.category.name == catToUpdate.name);

    categories = await api.getCategories(budget.id);

    assert(categories.isNotEmpty);
    assert(categories.first.name == catToUpdate.name);

    return updatedCat.category;
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

    final updatedExpense = await api.updateExpense(expenseToUpdate);

    assert(updatedExpense.oldExpense.description == addedExpense.description);
    assert(updatedExpense.expense.description == expenseToUpdate.description);

    expenses = await api.getExpenses(budget.id);

    assert(expenses.isNotEmpty);
    assert(expenses.first.description == expenseToUpdate.description);

    return expenseToUpdate;
  }

  Future<DepositTransaction> testDepositAPI(Budget budget) async {
    final api = BudgetAPI();

    final deposit = DepositTransaction.newDeposit(
      budgetId: budget.id,
      description: 'Test Deposit',
      amount: 100,
    );

    final addedDeposit = await api.addDeposit(deposit);

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    var deposits = await api.getDeposits(budget.id, startDate, endDate);

    assert(deposits.isNotEmpty);
    assert(deposits.first.amount == deposit.amount);

    final depositToUpdate = DepositTransaction.fromJson({
      ...addedDeposit.deposit.toJson(),
      'description': 'Updated test deposit',
    });

    final updatedDeposit = await api.updateDeposit(depositToUpdate);

    assert(updatedDeposit.oldDeposit.description ==
        addedDeposit.deposit.description);
    assert(updatedDeposit.deposit.description == depositToUpdate.description);

    deposits = await api.getDeposits(budget.id, startDate, endDate);

    assert(deposits.isNotEmpty);
    assert(deposits.first.description == depositToUpdate.description);

    return updatedDeposit.deposit;
  }

  Future<WithdrawalTransaction> testWithdrawalAPI(
    Budget budget,
    Expense expense,
  ) async {
    final api = BudgetAPI();

    final withdrawal = WithdrawalTransaction.newWithdrawal(
      budgetId: budget.id,
      expenseId: expense.id,
      description: 'Test withdrawal',
      amount: 100,
    );

    final addedWithdrawal = await api.addWithdrawal(withdrawal);

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0);

    var withdrawals = await api.getWithdrawals(budget.id, startDate, endDate);

    assert(withdrawals.isNotEmpty);
    assert(withdrawals.first.amount == withdrawal.amount);

    final withdrawalToUpdate = WithdrawalTransaction.fromJson({
      ...addedWithdrawal.withdrawal.toJson(),
      'description': 'Updated test withdrawal',
    });

    final updatedWithdrawal = await api.updateWithdrawal(withdrawalToUpdate);

    assert(updatedWithdrawal.oldWithdrawal.description ==
        addedWithdrawal.withdrawal.description);
    assert(updatedWithdrawal.withdrawal.description ==
        withdrawalToUpdate.description);

    withdrawals = await api.getWithdrawals(budget.id, startDate, endDate);

    assert(withdrawals.isNotEmpty);
    assert(withdrawals.first.description == withdrawalToUpdate.description);

    return updatedWithdrawal.withdrawal;
  }

  Future<Reconciliation> testReconciliationAPI(Budget budget) async {
    final api = BudgetAPI();

    final recon = Reconciliation.newReconciliation(
      budgetId: budget.id,
      balance: 100,
    );

    final addedRecon = await api.addReconciliation(recon);

    var recons = await api.getReconciliations(budget.id);

    assert(recons.isNotEmpty);
    assert(recons.first.balance == recon.balance);

    return addedRecon;
  }

  Future<void> cleanup({
    required Budget budget,
    required ExpenseCategory category,
    required Expense expense,
    required DepositTransaction deposit,
    required WithdrawalTransaction withdrawal,
    required Reconciliation recon,
  }) async {
    final api = BudgetAPI();

    await Future.wait([
      api.deleteCategory(category.id),
      api.deleteExpense(expense.id),
      api.deleteDeposit(deposit.id),
      api.deleteWithdrawal(withdrawal.id),
      api.deleteReconciliation(recon.id),
    ]);

    await api.deleteBudget(budget.id);
  }
}

class _ProviderTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DebugButton(
      buttonText: 'All Providers Tests',
      onPressed: () async {
        final bp = context.read<BudgetProvider>();
        final msgProvider = context.read<MessagingProvider>();
        final lp = context.read<LoggingProvider>();

        await bp.clearCache();

        await testBudget(bp);
        await testCategory(bp);
        await testExpense(bp);
        await testDeposit(bp);
        await testWithdrawal(bp);
        await testReconciliation(bp);

        await bp.clearCache();
        final budgets = await bp.getBudgets();
        await bp.selectBudget(budgets.first.id);

        await Future.wait([
          bp.getCategories(),
          bp.getExpenses(),
          bp.getDeposits(),
          bp.getWithdrawals(),
          bp.getReconciliations(),
        ]);

        assert(bp.budgets.values.length == 1);
        assert(bp.categories.values.length == 1);
        assert(bp.expenses.values.length == 1);
        assert(bp.deposits.values.length == 1);
        assert(bp.withdrawals.values.length == 1);
        assert(bp.reconciliations.values.length == 1);

        await cleanup(bp);

        try {
          msgProvider.showSuccessSnackbar('All Provider Tests Passed');
        } catch (e, st) {
          msgProvider.showErrorSnackbar(e.toString());
          lp.logError(st.toString());
        }
      },
    );
  }

  Future<void> testBudget(BudgetProvider bp) async {
    final newBudget = Budget.newBudget(
      name: 'Test Budget',
    );

    final addedBudget = await bp.addBudget(newBudget);
    assert(bp.budgets.values.isNotEmpty);

    final budgetToUpdate = Budget.fromJson({
      ...addedBudget.toJson(),
      'name': 'Updated test budget',
    });

    final updateResponse = await bp.updateBudget(budgetToUpdate);
    assert(updateResponse.budget.name == budgetToUpdate.name);

    assert(bp.budgets[addedBudget.id]?.name == budgetToUpdate.name);

    await bp.selectBudget(addedBudget.id);
  }

  Future<void> testCategory(BudgetProvider bp) async {
    final budget = bp.currentBudget;

    if (budget == null) {
      throw Exception('No budget selected');
    }

    final newCat = ExpenseCategory.newCategory(
      budgetId: budget.id,
      name: 'Test Category',
    );

    final addedCat = await bp.addCategory(newCat);

    assert(bp.categories.values.isNotEmpty);

    final catToUpdate = ExpenseCategory.fromJson({
      ...addedCat.toJson(),
      'name': 'Updated test category',
    });

    final updateResponse = await bp.updateCategory(catToUpdate);
    assert(updateResponse.category.name == catToUpdate.name);
  }

  Future<void> testExpense(BudgetProvider bp) async {
    final budget = bp.currentBudget;

    if (budget == null) {
      throw Exception('No budget selected');
    }

    final category = bp.categories.values.first;

    final target = WeeklyExpenseTarget(dayOfWeek: 1);
    final newExpense = Expense.newExpense(
      budgetId: budget.id,
      categoryId: category.id,
      description: 'Expense',
      amount: 1,
      expenseTarget: target,
    );

    final addedExpense = await bp.addExpense(newExpense);
    assert(bp.expenses.values.isNotEmpty);

    final expenseToUpdate = Expense.fromJson({
      ...addedExpense.toJson(),
      'description': 'Updated test expense',
    });

    final updateResponse = await bp.updateExpense(expenseToUpdate);
    assert(updateResponse.expense.description == expenseToUpdate.description);
  }

  Future<void> testDeposit(BudgetProvider bp) async {
    final budget = bp.currentBudget;

    if (budget == null) {
      throw Exception('No budget selected');
    }

    final deposit = DepositTransaction.newDeposit(
      budgetId: budget.id,
      description: 'Test Deposit',
      amount: 100,
    );

    final addedDeposit = await bp.addDeposit(deposit);

    final depositToUpdate = DepositTransaction.fromJson({
      ...addedDeposit.deposit.toJson(),
      'description': 'Updated test deposit',
    });

    final updateResponse = await bp.updateDeposit(depositToUpdate);
    assert(updateResponse.deposit.description == depositToUpdate.description);
  }

  Future<void> testWithdrawal(BudgetProvider bp) async {
    final budget = bp.currentBudget;

    if (budget == null) {
      throw Exception('No budget selected');
    }

    final expense = bp.expenses.values.first;

    final withdrawal = WithdrawalTransaction.newWithdrawal(
      budgetId: budget.id,
      expenseId: expense.id,
      description: 'Test withdrawal',
      amount: 100,
    );

    final addedWithdrawal = await bp.addWithdrawal(withdrawal);

    final withdrawalToUpdate = WithdrawalTransaction.fromJson({
      ...addedWithdrawal.withdrawal.toJson(),
      'description': 'Updated test withdrawal',
    });

    final updateResponse = await bp.updateWithdrawal(withdrawalToUpdate);
    assert(updateResponse.withdrawal.description ==
        withdrawalToUpdate.description);
  }

  Future<void> testReconciliation(BudgetProvider bp) async {
    final budget = bp.currentBudget;

    if (budget == null) {
      throw Exception('No budget selected');
    }

    final recon = Reconciliation.newReconciliation(
      budgetId: budget.id,
      balance: 100,
    );

    await bp.addReconciliation(recon);

    assert(bp.reconciliations.values.isNotEmpty);
  }

  Future<void> cleanup(BudgetProvider bp) async {
    final reconciliation = bp.reconciliations.values.first;
    final withdrawal = bp.withdrawals.values.first;
    final deposit = bp.deposits.values.first;
    final expense = bp.expenses.values.first;
    final category = bp.categories.values.first;
    final budget = bp.budgets.values.first;

    await Future.wait([
      bp.deleteReconciliation(reconciliation),
      bp.deleteWithdrawal(withdrawal),
      bp.deleteDeposit(deposit),
      bp.deleteExpense(expense),
      bp.deleteCategory(category),
    ]);

    await bp.deleteBudget(budget);

    await bp.clearCache();
  }
}

class _DisableDebugMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DebugButton(
      buttonText: 'Disable Debug Mode',
      onPressed: () {
        ConfigProvider.instance.setConfig('debugMode', false);
      },
    );
  }
}
