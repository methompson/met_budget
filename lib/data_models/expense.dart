import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/8601_date.dart';
import 'package:met_budget/utils/exceptions.dart';
import 'package:met_budget/utils/type_checker.dart';

enum ExpenseTargetType {
  weekly,
  monthly,
  dated,
}

ExpenseTargetType expenseTargetTypeFromString(String type) {
  switch (type) {
    case 'weekly':
      return ExpenseTargetType.weekly;
    case 'monthly':
      return ExpenseTargetType.monthly;
    case 'dated':
      return ExpenseTargetType.dated;
    default:
      throw InvalidInputException('Invalid expense target type: $type');
  }
}

String expenseTargetTypeToString(ExpenseTargetType type) {
  switch (type) {
    case ExpenseTargetType.weekly:
      return 'weekly';
    case ExpenseTargetType.monthly:
      return 'monthly';
    case ExpenseTargetType.dated:
      return 'dated';
  }
}

abstract class ExpenseTarget {
  Map<String, dynamic> toJson();

  ExpenseTargetType get expenseTargetType;

  static fromJson(dynamic input) {
    const errMsg = 'ExpenseTarget.fromJson Failed:';

    final json = isTypeError<Map>(input, message: '$errMsg expenseTarget');

    final type = isTypeError<String>(
      json['type'],
      message: '$errMsg type',
    );

    final ett = expenseTargetTypeFromString(type);

    switch (ett) {
      case ExpenseTargetType.weekly:
        return WeeklyExpenseTarget.fromJson(json);
      case ExpenseTargetType.monthly:
        return MonthlyExpenseTarget.fromJson(json);
      case ExpenseTargetType.dated:
        return DatedExpenseTarget.fromJson(json);
    }
  }
}

class WeeklyExpenseTarget extends ExpenseTarget {
  final int dayOfWeek;

  @override
  ExpenseTargetType get expenseTargetType => ExpenseTargetType.weekly;

  WeeklyExpenseTarget({
    required this.dayOfWeek,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': expenseTargetTypeToString(ExpenseTargetType.weekly),
      'data': {
        'dayOfWeek': dayOfWeek,
      },
    };
  }

  factory WeeklyExpenseTarget.fromJson(dynamic input) {
    final json = isTypeError<Map>(
      input,
      message: 'WeeklyExpenseTarget.fromJson Failed: root',
    );

    final data = isTypeError<Map>(
      json['data'],
      message: 'WeeklyExpenseTarget.fromJson Failed: data',
    );

    const errMsg = 'ExpenseTarget.fromJson Failed:';
    final dayOfWeek = isTypeError<num>(
      data['dayOfWeek'],
      message: '$errMsg dayOfWeek',
    );

    if (dayOfWeek < 1 || dayOfWeek > 7) {
      throw InvalidInputException('Invalid dayOfWeek: $dayOfWeek');
    }

    return WeeklyExpenseTarget(dayOfWeek: dayOfWeek.toInt());
  }
}

// Day of month refers to the same day of the month every month
// If day of month is -1, it refers to the last day of the month
class MonthlyExpenseTarget extends ExpenseTarget {
  final int dayOfMonth;

  @override
  ExpenseTargetType get expenseTargetType => ExpenseTargetType.monthly;

  MonthlyExpenseTarget({
    required this.dayOfMonth,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': expenseTargetTypeToString(ExpenseTargetType.monthly),
      'data': {
        'dayOfMonth': dayOfMonth,
      },
    };
  }

  factory MonthlyExpenseTarget.fromJson(dynamic input) {
    const errMsg = 'ExpenseTarget.fromJson Failed:';
    final json = isTypeError<Map>(
      input,
      message: 'WeeklyExpenseTarget.fromJson Failed: root',
    );

    final data = isTypeError<Map>(
      json['data'],
      message: 'WeeklyExpenseTarget.fromJson Failed: data',
    );

    final dayOfMonth = isTypeError<num>(
      data['dayOfMonth'],
      message: '$errMsg dayOfMonth',
    );

    if (dayOfMonth < -1 || dayOfMonth == 0 || dayOfMonth > 31) {
      throw InvalidInputException('Invalid dayOfMonth: $dayOfMonth');
    }

    return MonthlyExpenseTarget(dayOfMonth: dayOfMonth.toInt());
  }
}

class DatedExpenseTarget extends ExpenseTarget {
  final DateTime date;

  @override
  ExpenseTargetType get expenseTargetType => ExpenseTargetType.dated;

  DatedExpenseTarget({
    required this.date,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': expenseTargetTypeToString(ExpenseTargetType.dated),
      'data': {
        'date': toISO8601Date(date),
      },
    };
  }

  factory DatedExpenseTarget.fromJson(dynamic input) {
    const errMsg = 'ExpenseTarget.fromJson Failed:';

    final json = isTypeError<Map>(
      input,
      message: 'WeeklyExpenseTarget.fromJson Failed: root',
    );

    final data = isTypeError<Map>(
      json['data'],
      message: 'WeeklyExpenseTarget.fromJson Failed: data',
    );

    final dateStr = isTypeError<String>(
      data['date'],
      message: '$errMsg date',
    );

    final date = DateTime.parse(dateStr);

    return DatedExpenseTarget(date: date);
  }
}

class Expense {
  final String id;
  final String budgetId;
  final String categoryId;
  final String description;
  final num amount;
  final ExpenseTarget expenseTarget;

  Expense({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.expenseTarget,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'categoryId': categoryId,
      'description': description,
      'amount': amount,
      'expenseTarget': expenseTarget.toJson(),
    };
  }

  factory Expense.newExpense({
    required String budgetId,
    required String categoryId,
    required String description,
    required num amount,
    required ExpenseTarget expenseTarget,
  }) {
    return Expense(
      id: Uuid().v4(),
      budgetId: budgetId,
      categoryId: categoryId,
      description: description,
      amount: amount,
      expenseTarget: expenseTarget,
    );
  }

  factory Expense.fromJson(dynamic input) {
    const errMsg = 'Expense.fromJson Failed:';

    final json = isTypeError<Map>(
      input,
      message: '$errMsg root',
    );

    final id = isTypeError<String>(
      json['id'],
      message: '$errMsg id',
    );

    final budgetId = isTypeError<String>(
      json['budgetId'],
      message: '$errMsg budgetId',
    );

    final categoryId = isTypeError<String>(
      json['categoryId'],
      message: '$errMsg categoryId',
    );

    final description = isTypeError<String>(
      json['description'],
      message: '$errMsg description',
    );

    final amount = isTypeError<num>(
      json['amount'],
      message: '$errMsg amount',
    );

    final expenseTarget = ExpenseTarget.fromJson(json['expenseTarget']);

    return Expense(
      id: id,
      budgetId: budgetId,
      categoryId: categoryId,
      description: description,
      amount: amount,
      expenseTarget: expenseTarget,
    );
  }

  static List<Expense> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<Expense> output = [];

    for (final p in rawList) {
      output.add(Expense.fromJson(p));
    }

    return output;
  }
}
