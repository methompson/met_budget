import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/type_checker.dart';

class ExpenseCategory {
  final String id;
  final String budgetId;
  final String name;

  ExpenseCategory({
    required this.id,
    required this.budgetId,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'name': name,
    };
  }

  factory ExpenseCategory.newCategory({
    required String budgetId,
    required String name,
  }) {
    return ExpenseCategory(
      id: Uuid().v4(),
      budgetId: budgetId,
      name: name,
    );
  }

  factory ExpenseCategory.fromJson(dynamic input) {
    const errMsg = 'Category.fromJson Failed:';

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
    final name = isTypeError<String>(
      json['name'],
      message: '$errMsg name',
    );

    return ExpenseCategory(
      id: id,
      budgetId: budgetId,
      name: name,
    );
  }
}
