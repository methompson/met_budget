import 'package:flutter/material.dart';
import 'package:met_budget/ui/components/buttons.dart';

class AddDepositForm extends StatelessWidget {
  Widget get addDeposittButton => BasicBigTextButton(
        text: 'Add Deposit',
        allMargin: 10,
        topPadding: 10,
        bottomPadding: 10,
        onPressed: () {},
      );

  Widget get editDepositButton => BasicBigTextButton(
        text: 'Edit Deposit',
        allMargin: 10,
        topPadding: 10,
        bottomPadding: 10,
        onPressed: () {},
      );

  @override
  Widget build(BuildContext context) {
    const horizontalMargin = 20.0;
    const verticalMargin = 10.0;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date'),
            ),
            addDeposittButton,
            BasicBigTextButton(
              text: 'Cancel',
              allMargin: 10,
              topPadding: 10,
              bottomPadding: 10,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
