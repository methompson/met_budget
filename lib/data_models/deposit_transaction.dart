import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/type_checker.dart';

class DepositTransaction {
  final String id;
  final String budgetId;
  final String payor;
  final String description;
  final DateTime dateTime;
  final num amount;

  DepositTransaction({
    required this.id,
    required this.budgetId,
    required this.payor,
    required this.description,
    required this.dateTime,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'payor': payor,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
    };
  }

  factory DepositTransaction.newDeposit({
    required String budgetId,
    required String payor,
    required String description,
    required num amount,
  }) {
    return DepositTransaction(
      id: Uuid().v4(),
      budgetId: budgetId,
      payor: payor,
      description: description,
      dateTime: DateTime.now(),
      amount: amount,
    );
  }

  factory DepositTransaction.fromJson(dynamic input) {
    const errMsg = 'DepositTransaction.fromJson Failed:';

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
    final description = isTypeError<String>(
      json['description'],
      message: '$errMsg description',
    );
    final payor = isTypeError<String>(
      json['payor'],
      message: '$errMsg payor',
    );
    final dateTime = isTypeError<String>(
      json['dateTime'],
      message: '$errMsg dateTime',
    );
    final amount = isTypeError<num>(
      json['amount'],
      message: '$errMsg amount',
    );

    return DepositTransaction(
      id: id,
      budgetId: budgetId,
      payor: payor,
      description: description,
      dateTime: DateTime.parse(dateTime),
      amount: amount,
    );
  }

  static List<DepositTransaction> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<DepositTransaction> output = [];

    for (final p in rawList) {
      output.add(DepositTransaction.fromJson(p));
    }

    return output;
  }
}
