import 'package:met_budget/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class WithdrawalTransaction {
  final String id;
  final String budgetId;
  final String expenseId;

  final String description;
  final DateTime dateTime;

  WithdrawalTransaction({
    required this.id,
    required this.budgetId,
    required this.expenseId,
    required this.description,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'expenseId': expenseId,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory WithdrawalTransaction.newWithdrawal({
    required String budgetId,
    required String expenseId,
    required String description,
  }) {
    return WithdrawalTransaction(
      id: Uuid().v4(),
      budgetId: budgetId,
      expenseId: expenseId,
      description: description,
      dateTime: DateTime.now(),
    );
  }

  factory WithdrawalTransaction.fromJson(dynamic input) {
    const errMsg = 'WithdrawalTransaction.fromJson Failed:';

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
    final expenseId = isTypeError<String>(
      json['expenseId'],
      message: '$errMsg expenseId',
    );
    final description = isTypeError<String>(
      json['description'],
      message: '$errMsg description',
    );
    final dateTime = isTypeError<String>(
      json['dateTime'],
      message: '$errMsg dateTime',
    );

    return WithdrawalTransaction(
      id: id,
      budgetId: budgetId,
      expenseId: expenseId,
      description: description,
      dateTime: DateTime.parse(dateTime),
    );
  }
}
