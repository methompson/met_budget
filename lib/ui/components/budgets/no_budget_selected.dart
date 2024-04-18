import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/budgets/budget_selection.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/page_container.dart';

class NoBudgetSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ThemeColors(),
        Text(
          'No Budget Selected',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SelectBudget(inModal: false),
      ],
    );
  }
}

class SelectABudgetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      text: 'Select a Budget',
      topMargin: 10,
      allPadding: 15,
      onPressed: () => openSelectBudgetDialog(context),
    );
  }

  void openSelectBudgetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      // isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(body: FullSizeContainer(child: SelectBudget()));
        // return CreateUserForm();
      },
    );
  }
}
