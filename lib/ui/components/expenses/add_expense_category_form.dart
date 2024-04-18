import 'package:flutter/material.dart';
import 'package:met_budget/data_models/expense_category.dart';
import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:provider/provider.dart';

class AddExpenseCategoryForm extends StatefulWidget {
  @override
  AddExpenseCategoryFormState createState() => AddExpenseCategoryFormState();
}

class AddExpenseCategoryFormState extends State<AddExpenseCategoryForm> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bp = context.read<BudgetProvider>();
    final msgProvider = context.read<MessagingProvider>();

    return CenteredFullSizeContainer(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Expense Category Name',
              ),
            ),
          ),
          BasicBigTextButton(
            disabled: _nameController.text.isEmpty,
            text: 'Add Expense Category',
            onPressed: () async {
              msgProvider.setLoadingScreenData(
                LoadingScreenData(message: 'Saving New Expense Category'),
              );

              try {
                final currentBudget = bp.currentBudget;

                if (currentBudget == null) {
                  throw Exception('No Budget Selected');
                }

                final eCategory = ExpenseCategory.newCategory(
                  budgetId: currentBudget.id,
                  name: _nameController.text.trim(),
                );
                await bp.addCategory(eCategory);

                msgProvider.showSuccessSnackbar('Expense Category Created');

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                msgProvider
                    .showErrorSnackbar('Creating Expense Category Failed: $e');
              }

              msgProvider.clearLoadingScreen();
            },
          ),
        ],
      ),
    );
  }
}
