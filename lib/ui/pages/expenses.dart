import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/ui/components/budgets/no_budget_selected.dart';
import 'package:met_budget/ui/components/budget_header.dart';
import 'package:met_budget/ui/components/expenses/add_expense_category_form.dart';
import 'package:met_budget/ui/components/expenses/add_expense_form.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:met_budget/utils/day_and_date_utils.dart';
import 'package:met_budget/global_state/budget_provider.dart';

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

class ExpensesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BudgetHeader(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
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
      builder: (context) => Scaffold(
        body: FullSizeContainer(child: AddExpenseCategoryForm()),
      ),
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
        categoryWidgets.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ExpenseCard(expense: ex),
        ));
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Text(category.name),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => openAddExpenseDialog(context, category.id),
            ),
          ],
        ),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                onTap: () => openEditExpenseDialog(context, expense),
                readOnly: true,
                controller: TextEditingController(text: expense.description),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.delete),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                onTap: () => openEditExpenseDialog(context, expense),
                readOnly: true,
                controller: TextEditingController(
                    text: '\$${expense.amount.toString()}'),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  expenseTargetDescription(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String expenseTargetDescription() {
    final target = expense.expenseTarget;
    if (target is WeeklyExpenseTarget) {
      return 'Weekly, every ${getDisplayDayOfWeek(target.dayOfWeek)}';
    }

    if (target is MonthlyExpenseTarget) {
      return 'Monthly, by the ${getDisplayDayOfMonth(target.dayOfMonth)}';
    }

    if (target is DatedExpenseTarget) {
      return 'By ${DateFormat("MM/dd/yyyy").format(target.date)}';
    }

    return 'Unknown Target Type';
  }

  Future<void> openEditExpenseDialog(
    BuildContext context,
    Expense expense,
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
              categoryId: expense.categoryId,
              expense: expense,
            ),
          ),
        );
      },
    );
  }
}
