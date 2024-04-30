import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';
import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/form_utils.dart';
import 'package:provider/provider.dart';

class AddDepositForm extends StatefulWidget {
  @override
  AddDepositFormState createState() => AddDepositFormState();
}

class AddDepositFormState extends State<AddDepositForm> {
  final _amountController = TextEditingController();
  final _payorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  final _hiddenFieldFocusNode = FocusNode();

  int _currentAmount = 0;

  DateTime? _selectedDate;

  bool get _isValid {
    return _currentAmount > 0 &&
        _payorController.text.isNotEmpty &&
        _selectedDate != null;
  }

  String get _dollarAmount {
    final text = '\$${(_currentAmount / 100).toStringAsFixed(2)}';

    return text;
  }

  Widget get addDepositButton => BasicBigTextButton(
        text: 'Add Deposit',
        disabled: !_isValid,
        allMargin: 10,
        topPadding: 10,
        bottomPadding: 10,
        onPressed: () {
          _addDeposit();
        },
      );

  Widget get editDepositButton => BasicBigTextButton(
        text: 'Edit Deposit',
        disabled: !_isValid,
        allMargin: 10,
        topPadding: 10,
        bottomPadding: 10,
        onPressed: () {},
      );

  @override
  void initState() {
    super.initState();

    _hiddenFieldFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final barColor = _hiddenFieldFocusNode.hasFocus
        ? Colors.green
        : Theme.of(context).colorScheme.onSurface;

    final barThickness = _hiddenFieldFocusNode.hasFocus ? 3.0 : 0.5;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: GestureDetector(
              onTap: () {
                _hiddenFieldFocusNode.requestFocus();
                setState(() {});
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    _dollarAmount,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.green),
                  )),
            ),
          ),
          FieldMargin(
            vertical: 0,
            Divider(
              thickness: barThickness,
              color: barColor,
            ),
          ),
          Offstage(
            offstage: true,
            child: TextField(
              controller: _amountController,
              focusNode: _hiddenFieldFocusNode,
              onChanged: (value) {
                final exp = RegExp(r'[^0-9]');
                final match = exp.allMatches(value);

                if (match.isNotEmpty) {
                  _amountController.text = '$_currentAmount';
                  return;
                }

                final parsedAmount = value.isNotEmpty ? int.tryParse(value) : 0;

                if (parsedAmount != null) {
                  setState(() {
                    _currentAmount = parsedAmount;
                  });
                } else {
                  _amountController.text = '$_currentAmount';
                }
              },
            ),
          ),
          FieldMargin(TextField(
            controller: _payorController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Payor',
            ),
          )),
          FieldMargin(TextField(
            controller: _descriptionController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Description',
            ),
          )),
          FieldMargin(TextField(
            readOnly: true,
            controller: _dateController,
            onChanged: (_) => setState(() {}),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                firstDate: DateTime(1980),
                lastDate: DateTime(2200),
              );
              final dateStr =
                  date != null ? DateFormat("MM/dd/yyyy").format(date) : '';

              setState(() {
                _selectedDate = date;

                _dateController.text = dateStr;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Date',
            ),
          )),
          addDepositButton,
          BasicBigTextButton(
            text: 'Cancel',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            onPressed: () => closeModal,
          ),
        ],
      ),
    );
  }

  Future<void> _addDeposit() async {
    final bp = context.read<BudgetProvider>();
    final msgProvider = context.read<MessagingProvider>();

    final payor = _payorController.text;
    final description = _descriptionController.text;
    final date = _selectedDate;
    final amount = _currentAmount / 100;

    if (payor.isEmpty || date == null || amount <= 0) {
      return;
    }

    final budgetId = bp.currentBudget?.id;

    if (budgetId == null) {
      msgProvider.showErrorSnackbar('No budget selected');
      return;
    }

    final deposit = DepositTransaction.newDeposit(
      budgetId: budgetId,
      payor: payor,
      description: description,
      amount: amount,
    );

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Depoist...'),
    );

    try {
      await bp.addDeposit(deposit);

      msgProvider.showSuccessSnackbar('Deposit added');

      closeModal();
    } catch (e) {
      msgProvider.showErrorSnackbar('Failed to add deposit');
      return;
    }
    msgProvider.clearLoadingScreen();
  }

  void closeModal() {
    Navigator.pop(context);
  }
}
