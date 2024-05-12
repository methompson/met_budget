import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/data_models/messaging_data.dart';
import 'package:met_budget/global_state/budget_provider.dart';
import 'package:met_budget/global_state/messaging_provider.dart';
import 'package:met_budget/ui/components/buttons.dart';
import 'package:met_budget/ui/components/form_utils.dart';
import 'package:met_budget/ui/components/page_container.dart';
import 'package:met_budget/utils/day_and_date_utils.dart';

List<int> createDayOfMonthList() {
  final List<int> dayOfMonth = [];
  for (var i = 1; i <= 31; i++) {
    dayOfMonth.add(i);
  }

  return dayOfMonth;
}

final List<String> dropdownValues = [
  'Monthly',
  'Weekly',
  'Dated',
];

final List<int> dayOfMonth = createDayOfMonthList();

class AddExpenseForm extends StatelessWidget {
  final String categoryId;
  final Expense? expense;

  AddExpenseForm({
    required this.categoryId,
    this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return CenteredFullSizeContainer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AddExpenseFormContent(
                categoryId: categoryId,
                expense: expense,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonMargin extends StatelessWidget {
  final Widget child;

  const _CommonMargin(this.child);

  @override
  Widget build(BuildContext context) {
    return FieldMargin(child);
  }
}

class AddExpenseFormContent extends StatefulWidget {
  final String categoryId;
  final Expense? expense;

  AddExpenseFormContent({
    required this.categoryId,
    this.expense,
  });

  @override
  AddExpenseFormContentState createState() => AddExpenseFormContentState();
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
  void initState() {
    super.initState();
    final ex = widget.expense;

    if (ex != null) {
      _descriptionController.text = ex.description;
      _amountController.text = ex.amount.toString();

      final target = ex.expenseTarget;
      if (target is MonthlyExpenseTarget) {
        _expenseTargetController.text = 'Monthly';
        _monthlyExpenseController.text = target.dayOfMonth.toString();
        monthlyValue = target.dayOfMonth;
      } else if (target is WeeklyExpenseTarget) {
        _expenseTargetController.text = 'Weekly';
        _weeklyExpenseController.text = dayOfWeek[target.dayOfWeek - 1];
        weeklyValue = target.dayOfWeek;
      } else if (target is DatedExpenseTarget) {
        _expenseTargetController.text = 'Dated';
        _datedExpenseController.text =
            DateFormat("MM/dd/yyyy").format(target.date);
        _selectedDate = target.date;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.expense == null ? 'Add Expense' : 'Edit Expense';
    final buttonStr = widget.expense == null ? 'Add Expense' : 'Edit Expense';

    return Column(
      children: [
        _CommonMargin(
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        _CommonMargin(
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
        _CommonMargin(
          DropdownMenu<String>(
            requestFocusOnTap: false,
            initialSelection: null,
            controller: _expenseTargetController,
            label: Text('Select Expense Type'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: dropdownValues
                .map((val) => DropdownMenuEntry<String>(value: val, label: val))
                .toList(),
            onSelected: (val) {
              setState(() {});
            },
          ),
        ),
        if (_expenseTargetController.text == 'Monthly')
          monthlyExpenseTargetUi(),
        if (_expenseTargetController.text == 'Weekly') weeklyExpenseTargetUi(),
        if (_expenseTargetController.text == 'Dated') datedExpenseTargetUi(),
        _CommonMargin(
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            controller: _amountController,
            decoration: InputDecoration(
              prefix: Text('\$'),
              border: OutlineInputBorder(),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'Amount',
            ),
          ),
        ),
        _CommonMargin(BasicBigTextButton(
          disabled: !_isFormValid,
          text: buttonStr,
          onPressed: () => saveExpense(context),
        )),
        _CommonMargin(BasicBigTextButton(
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
    return _CommonMargin(DropdownMenu<int>(
      initialSelection: null,
      controller: _monthlyExpenseController,
      label: Text('Day of Month'),
      expandedInsets: EdgeInsets.all(0),
      dropdownMenuEntries: menuEntries,
      onSelected: (val) => setState(() {
        monthlyValue = val;
      }),
    ));
  }

  Widget weeklyExpenseTargetUi() {
    return _CommonMargin(DropdownMenu<String>(
      initialSelection: null,
      controller: _weeklyExpenseController,
      label: Text('Day of Week'),
      expandedInsets: EdgeInsets.all(0),
      dropdownMenuEntries: dayOfWeek
          .map((val) => DropdownMenuEntry<String>(value: val, label: val))
          .toList(),
      onSelected: (val) => setState(() {
        if (val == null) {
          weeklyValue = null;
          return;
        }

        weeklyValue = dayOfWeek.indexOf(val) % 7;
      }),
    ));
  }

  Widget datedExpenseTargetUi() {
    return _CommonMargin(TextField(
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

  Future<void> saveExpense(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();

    final oldExpense = widget.expense;

    final loadingTxt =
        oldExpense == null ? 'Saving New Expense' : 'Updating Expense';
    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: loadingTxt),
    );

    try {
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

      if (oldExpense != null) {
        await editExpense(context, oldExpense, expenseTarget);
      } else {
        await addExpense(context, expenseTarget);
      }

      closeModal();
    } catch (e) {
      msgProvider.showErrorSnackbar('Creating Expense Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }

  Future<void> addExpense(
    BuildContext context,
    ExpenseTarget expenseTarget,
  ) async {
    final bp = context.read<BudgetProvider>();

    final budgetId = bp.currentBudget?.id;

    if (budgetId == null) {
      throw Exception('No Budget Selected');
    }

    final expense = Expense.newExpense(
      budgetId: budgetId,
      categoryId: widget.categoryId,
      description: _descriptionController.text,
      amount: num.parse(_amountController.text),
      expenseTarget: expenseTarget,
    );

    await bp.addExpense(expense);
  }

  Future<void> editExpense(
    BuildContext context,
    Expense oldExpense,
    ExpenseTarget expenseTarget,
  ) async {
    final expense = Expense.fromJson({
      ...oldExpense.toJson(),
      'description': _descriptionController.text,
      'amount': num.parse(_amountController.text),
      'expenseTarget': expenseTarget.toJson(),
    });

    final bp = context.read<BudgetProvider>();
    await bp.updateExpense(expense);
  }

  void closeModal() {
    Navigator.pop(context);
  }
}
