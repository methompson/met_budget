import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/global_state/budget_provider.dart';

class CategoryExpansionListItem {
  final ExpenseCategory category;
  bool isExpanded = false;

  CategoryExpansionListItem(this.category);
}

class BudgetList extends StatefulWidget {
  @override
  State<BudgetList> createState() => BudgetListState();
}

class BudgetListState extends State<BudgetList> {
  List<CategoryExpansionListItem> categories = [];

  @override
  void initState() {
    super.initState();

    final bp = context.read<BudgetProvider>();

    categories = bp.categories.values.map((e) {
      return CategoryExpansionListItem(e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            categories[panelIndex].isExpanded = isExpanded;
          });
        },
        children: categories.map((e) {
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text(e.category.name),
              );
            },
            body: CategoriesList(e.category),
            isExpanded: e.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  final ExpenseCategory category;

  CategoriesList(this.category);

  @override
  Widget build(BuildContext context) {
    final bp = context.read<BudgetProvider>();
    final expenses = bp.expensesList
        .where(
          (expense) => expense.categoryId == category.id,
        )
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseItem(expense);
      },
    );
  }
}

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  ExpenseItem(this.expense);

  @override
  Widget build(BuildContext context) {
    final bp = context.read<BudgetProvider>();
    final transactions = bp.currentPeriodWithdrawalsList
        .where(
          (transaction) => transaction.expenseId == expense.id,
        )
        .toList();

    final totalWithdrawals = transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    final progress = totalWithdrawals / expense.amount;
    final color = progress > 1 ? Colors.deepOrange : Colors.green;
    final backgroundColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200];

    final remaining = expense.amount - totalWithdrawals;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(expense.description),
              Text('\$${totalWithdrawals.toStringAsFixed(2)}'),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: backgroundColor,
              minHeight: 10,
            ),
          ),
          Text('\$${remaining.toStringAsFixed(2)} Reamining'),
        ],
      ),
    );
  }
}
