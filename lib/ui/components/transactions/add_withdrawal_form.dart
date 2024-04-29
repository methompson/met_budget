import 'package:flutter/material.dart';

class AddWithdrawalForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        ElevatedButton(
          onPressed: () {},
          child: Text('Submit'),
        ),
      ],
    );
  }
}
