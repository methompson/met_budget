import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:met_budget/data_models/budget_transaction.dart';
import 'package:met_budget/utils/type_checker.dart';

class WithdrawalTransaction extends BudgetTransaction {
  final String expenseId;
  final String payee;

  WithdrawalTransaction({
    required super.id,
    required super.budgetId,
    required this.expenseId,
    required this.payee,
    required super.description,
    required super.dateTime,
    required super.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'expenseId': expenseId,
      'payee': payee,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
    };
  }

  factory WithdrawalTransaction.newWithdrawal({
    required String budgetId,
    required String expenseId,
    required String payee,
    required String description,
    required num amount,
    DateTime? date,
  }) {
    return WithdrawalTransaction(
      id: Uuid().v4(),
      budgetId: budgetId,
      expenseId: expenseId,
      payee: payee,
      description: description,
      dateTime: date ?? DateTime.now(),
      amount: amount,
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
    final payee = isTypeError<String>(
      json['payee'],
      message: '$errMsg payee',
    );
    final description = isTypeError<String>(
      json['description'],
      message: '$errMsg description',
    );
    final dateTime = isTypeError<String>(
      json['dateTime'],
      message: '$errMsg dateTime',
    );

    final amount = isTypeError<num>(
      json['amount'],
      message: '$errMsg amount',
    );

    return WithdrawalTransaction(
      id: id,
      budgetId: budgetId,
      expenseId: expenseId,
      payee: payee,
      description: description,
      dateTime: DateTime.parse(dateTime),
      amount: amount,
    );
  }

  static List<WithdrawalTransaction> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<WithdrawalTransaction> output = [];

    for (final p in rawList) {
      output.add(WithdrawalTransaction.fromJson(p));
    }

    return output;
  }
}
