import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/type_checker.dart';

class WithdrawalTransaction {
  final String id;
  final String budgetId;
  final String expenseId;
  final String payee;
  final String description;
  final DateTime dateTime;
  final num amount;

  WithdrawalTransaction({
    required this.id,
    required this.budgetId,
    required this.expenseId,
    required this.payee,
    required this.description,
    required this.dateTime,
    required this.amount,
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
