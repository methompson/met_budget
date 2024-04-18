import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:provider/provider.dart';

List<int> createDayOfMonthList() {
  final List<int> dayOfMonth = [];
  for (var i = 1; i <= 31; i++) {
    dayOfMonth.add(i);
  }

  return dayOfMonth;
}

String getDisplayDayOfMonth(int value) {
  final int lastDigit = value % 10;

  if (lastDigit == 1) {
    return '${value}st';
  } else if (lastDigit == 2) {
    return '${value}nd';
  } else if (lastDigit == 3) {
    return '${value}rd';
  }

  return '${value}th';
}

final List<String> dropdownValues = [
  'Monthly',
  'Weekly',
  'Dated',
];

final List<String> dayOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

final List<int> dayOfMonth = createDayOfMonthList();

class AddExpenseForm extends StatelessWidget {
  final String categoryId;

  AddExpenseForm({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return CenteredFullSizeContainer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AddExpenseFormContent(categoryId: categoryId),
            ),
          ),
        ],
      ),
    );
  }
}

class AddExpenseFormContent extends StatefulWidget {
  final String categoryId;

  AddExpenseFormContent({required this.categoryId});

  @override
  AddExpenseFormContentState createState() => AddExpenseFormContentState();
}

class CommonMargin extends StatelessWidget {
  final Widget child;

  const CommonMargin(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: child,
    );
  }
}

class AddExpenseFormContentState extends State<AddExpenseFormContent> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  final _expenseTargetController = TextEditingController();
  final _weeklyExpenseController = TextEditingController();
  final _monthlyExpenseController = TextEditingController();
  final _datedExpenseController = TextEditingController();

  int? monthlyValue;
  int? weeklyValue;
  DateTime? _selectedDate;

  bool get _isFormValid {
    final commonValid = _descriptionController.text.isNotEmpty &&
        _amountController.text.isNotEmpty;

    if (!commonValid) {
      return false;
    }

    if (_expenseTargetController.text == 'Monthly') {
      return _monthlyExpenseController.text.isNotEmpty;
    } else if (_expenseTargetController.text == 'Weekly') {
      return _weeklyExpenseController.text.isNotEmpty;
    } else if (_expenseTargetController.text == 'Dated') {
      return _datedExpenseController.text.isNotEmpty;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Add an Expense'),
        CommonMargin(
          TextField(
            onChanged: (_) => setState(() {}),
            controller: _descriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Description',
            ),
          ),
        ),
        CommonMargin(
          DropdownMenu<String>(
            initialSelection: null,
            controller: _expenseTargetController,
            label: Text('Select Expense Type'),
            expandedInsets: EdgeInsets.all(0),
            dropdownMenuEntries: dropdownValues
                .map((val) => DropdownMenuEntry<String>(value: val, label: val))
                .toList(),
            // dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            // focusColor: Theme.of(context).scaffoldBackgroundColor,
            onSelected: (val) {
              setState(() {});
            },
          ),
        ),
        if (_expenseTargetController.text == 'Monthly')
          monthlyExpenseTargetUi(),
        if (_expenseTargetController.text == 'Weekly') weeklyExpenseTargetUi(),
        if (_expenseTargetController.text == 'Dated') datedExpenseTargetUi(),
        CommonMargin(
          TextField(
            onChanged: (_) => setState(() {}),
            controller: _amountController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Amount',
            ),
          ),
        ),
        CommonMargin(BasicBigTextButton(
          disabled: !_isFormValid,
          text: 'Add Expense',
          onPressed: () => addExpense(context),
        )),
        CommonMargin(BasicBigTextButton(
          text: 'Cancel',
          onPressed: () => closeModal(),
        )),
      ],
    );
  }

  Widget monthlyExpenseTargetUi() {
    final menuEntries = dayOfMonth
        .map((val) => DropdownMenuEntry<int>(
            value: val, label: getDisplayDayOfMonth(val)))
        .toList();
    return CommonMargin(DropdownMenu<int>(
      initialSelection: null,
      controller: _monthlyExpenseController,
      label: Text('Day of Month'),
      expandedInsets: EdgeInsets.all(0),
      dropdownMenuEntries: menuEntries,
      // dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      // focusColor: Theme.of(context).scaffoldBackgroundColor,
      onSelected: (val) => setState(() {
        monthlyValue = val;
      }),
    ));
  }

  Widget weeklyExpenseTargetUi() {
    return CommonMargin(DropdownMenu<String>(
      initialSelection: null,
      controller: _weeklyExpenseController,
      label: Text('Day of Week'),
      expandedInsets: EdgeInsets.all(0),
      dropdownMenuEntries: dayOfWeek
          .map((val) => DropdownMenuEntry<String>(value: val, label: val))
          .toList(),
      // dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      // focusColor: Theme.of(context).scaffoldBackgroundColor,
      onSelected: (val) => setState(() {
        if (val == null) {
          weeklyValue = null;
          return;
        }

        weeklyValue = (dayOfWeek.indexOf(val) + 1) % 7;
      }),
    ));
  }

  Widget datedExpenseTargetUi() {
    return CommonMargin(TextField(
      readOnly: true,
      controller: _datedExpenseController,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1980),
          lastDate: DateTime(2200),
        );

        final dateStr =
            date != null ? DateFormat("MM/dd/yyyy").format(date) : '';

        _selectedDate = date;

        _datedExpenseController.text = dateStr;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelText: 'Date',
      ),
    ));
  }

  Future<void> addExpense(BuildContext context) async {
    final bp = context.read<BudgetProvider>();
    final msgProvider = context.read<MessagingProvider>();

    final budgetId = bp.currentBudget?.id;

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Saving New Expense'),
    );

    try {
      if (budgetId == null) {
        throw Exception('No Budget Selected');
      }

      final ExpenseTarget expenseTarget;

      if (_expenseTargetController.text == 'Monthly') {
        final mv = monthlyValue;
        if (mv == null) {
          throw Exception('No Day of Month Selected');
        }
        expenseTarget = MonthlyExpenseTarget(
          dayOfMonth: mv,
        );
      } else if (_expenseTargetController.text == 'Weekly') {
        final wv = weeklyValue;
        if (wv == null) {
          throw Exception('No Day of Week Selected');
        }

        expenseTarget = WeeklyExpenseTarget(
          dayOfWeek: wv,
        );
      } else if (_expenseTargetController.text == 'Dated') {
        final sd = _selectedDate;
        if (sd == null) {
          throw Exception('No Date Selected');
        }

        expenseTarget = DatedExpenseTarget(date: sd);
      } else {
        throw Exception('Invalid Expense Target');
      }

      final expense = Expense.newExpense(
        budgetId: budgetId,
        categoryId: widget.categoryId,
        description: _descriptionController.text,
        amount: num.parse(_amountController.text),
        expenseTarget: expenseTarget,
      );

      await bp.addExpense(expense);

      msgProvider.showSuccessSnackbar('Expense Created');
      closeModal();
    } catch (e) {
      msgProvider.showErrorSnackbar('Creating Expense Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }

  void closeModal() {
    Navigator.pop(context);
  }
}
