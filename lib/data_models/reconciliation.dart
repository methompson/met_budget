import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/8601_date.dart';
import 'package:met_budget/utils/type_checker.dart';

class Reconciliation {
  final String id;
  final String budgetId;
  final DateTime date;
  final num balance;

  Reconciliation({
    required this.id,
    required this.budgetId,
    required this.date,
    required this.balance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'date': toISO8601Date(date),
      'balance': balance,
    };
  }

  factory Reconciliation.newReconciliation({
    required String budgetId,
    required num balance,
  }) {
    return Reconciliation(
      id: Uuid().v4(),
      budgetId: budgetId,
      date: DateTime.now(),
      balance: balance,
    );
  }

  factory Reconciliation.fromJson(dynamic input) {
    const errMsg = 'Reconciliation.fromJson Failed:';

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
    final date = isTypeError<String>(
      json['date'],
      message: '$errMsg date',
    );
    final balance = isTypeError<num>(
      json['balance'],
      message: '$errMsg balance',
    );

    return Reconciliation(
      id: id,
      budgetId: budgetId,
      date: DateTime.parse(date),
      balance: balance,
    );
  }

  static List<Reconciliation> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<Reconciliation> output = [];

    for (final p in rawList) {
      output.add(Reconciliation.fromJson(p));
    }

    return output;
  }
}
