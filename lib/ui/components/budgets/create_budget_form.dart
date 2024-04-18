import 'package:flutter/material.dart';
import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:provider/provider.dart';

class CreateBudgetForm extends StatefulWidget {
  @override
  CreateBudgetFormState createState() => CreateBudgetFormState();
}

class CreateBudgetFormState extends State<CreateBudgetForm> {
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
                labelText: 'Budget Name',
              ),
            ),
          ),
          BasicBigTextButton(
            disabled: _nameController.text.isEmpty,
            text: 'Add Budget',
            onPressed: () async {
              msgProvider.setLoadingScreenData(
                LoadingScreenData(message: 'Saving New Budget'),
              );

              try {
                final budget = Budget.newBudget(
                  name: _nameController.text.trim(),
                );
                await bp.addBudget(budget);

                msgProvider.showSuccessSnackbar('Budget Created');

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                msgProvider.showErrorSnackbar('Creating Budget Failed: $e');
              }

              msgProvider.clearLoadingScreen();
            },
          ),
        ],
      ),
    );
  }
}
