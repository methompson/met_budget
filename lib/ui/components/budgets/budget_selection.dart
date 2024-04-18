import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/budgets/create_budget_form.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:provider/provider.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/global_state/budget_provider.dart';

class SelectBudget extends StatelessWidget {
  final bool inModal;
  SelectBudget({
    this.inModal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<BudgetProvider, Budget?>(
      selector: (_, budgetProvider) => budgetProvider.currentBudget,
      builder: (context, currentBudget, _) {
        return Selector<BudgetProvider, List<Budget>>(
          selector: (_, budgetProvider) => budgetProvider.budgetsList,
          builder: (context, budgetList, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (budgetList.isEmpty)
                  Text('No budgets Available')
                else
                  BudgetsList(inModal: inModal),
                BasicBigTextButton(
                  text: 'Add a New Budget',
                  topMargin: 20,
                  allPadding: 10,
                  onPressed: () {
                    openCreateBudgetDialog(context);
                  },
                ),
                if (currentBudget != null)
                  BasicBigTextButton(
                    text: 'Deselect Budget',
                    topMargin: 20,
                    allPadding: 10,
                    onPressed: () {
                      context.read<BudgetProvider>().selectBudget(null);
                      if (inModal) {
                        Navigator.pop(context);
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void openCreateBudgetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(body: CreateBudgetForm());
      },
    );
  }
}

class BudgetsList extends StatelessWidget {
  final bool inModal;

  BudgetsList({
    this.inModal = true,
  });

  @override
  Widget build(BuildContext context) {
    final bpProvider = context.read<BudgetProvider>();
    final budgets = bpProvider.budgetsList;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'Select a Budget',
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];

            return Card(
              child: ListTile(
                title: Text(budget.name),
                subtitle: Text('\$${budget.currentFunds.toStringAsFixed(2)}'),
                onTap: () {
                  bpProvider.selectBudget(budget.id);
                  if (inModal) {
                    Navigator.pop(context);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
