import 'package:flutter/material.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/ui/components/budget_header.dart';
import 'package:met_budget/ui/components/expenses/add_expense_category_form.dart';
import 'package:met_budget/ui/components/expenses/add_expense_form.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/ui/components/budgets/no_budget_selected.dart';

class ExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, budget, _) {
        final child = budget != null ? ExpensesContent() : NoBudgetSelected();

        return CenteredFullSizeContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

class _CommonMargin extends StatelessWidget {
  final Widget child;

  const _CommonMargin(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}

class ExpensesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BudgetHeader(),
        _CommonMargin(
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Exepnses',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () => openAddExpenseCategoryDialog(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: CategoryData(),
        ),
      ],
    );
  }

  Future<void> openAddExpenseCategoryDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
            body: FullSizeContainer(child: AddExpenseCategoryForm()));
      },
    );
  }
}

class CategoryData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catWidgets = categoryWidgets(context);

    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      itemCount: catWidgets.length,
      itemBuilder: (context, index) => catWidgets[index],
    );
  }

  List<Widget> categoryWidgets(BuildContext context) {
    final bp = context.watch<BudgetProvider>();

    Map<String, List<Expense>> expensesByCategory = {};

    for (final ex in bp.expenses.values) {
      final expenses = expensesByCategory[ex.categoryId] ?? [];
      expenses.add(ex);
      expensesByCategory[ex.categoryId] = expenses;
    }

    final categoriesList = bp.categories.values.toList();
    categoriesList.sort((a, b) => a.name.compareTo(b.name));

    List<Widget> categoryWidgets = [];

    for (final cat in bp.categories.values) {
      categoryWidgets.add(CategoryHeader(category: cat));
      final expenses = expensesByCategory[cat.id] ?? [];
      for (final ex in expenses) {
        categoryWidgets.add(ExpenseCard(expense: ex));
      }

      expensesByCategory.remove(cat.id);
    }

    if (expensesByCategory.keys.isNotEmpty) {
      // Get misc expenses
    }

    return categoryWidgets;
  }
}

class CategoryHeader extends StatelessWidget {
  final ExpenseCategory category;
  CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: _CommonMargin(Row(
        children: [
          Text(category.name),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => openAddExpenseDialog(context, category.id),
          ),
        ],
      )),
    );
  }

  Future<void> openAddExpenseDialog(
    BuildContext context,
    String categoryId,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddExpenseForm(
              categoryId: categoryId,
            ),
          ),
        );
      },
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Text(expense.description);
  }
}
