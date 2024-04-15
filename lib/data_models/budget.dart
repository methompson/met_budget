import 'package:uuid/uuid.dart';

import 'package:met_budget/utils/type_checker.dart';

class Budget {
  final String id;
  final String userId;
  final String name;
  final num currentFunds;

  Budget({
    required this.id,
    required this.userId,
    required this.name,
    required this.currentFunds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'currentFunds': currentFunds,
    };
  }

  factory Budget.newBudget({
    required String userId,
    required String name,
  }) {
    return Budget(
      id: Uuid().v4(),
      userId: userId,
      name: name,
      currentFunds: 0,
    );
  }

  factory Budget.fromJson(dynamic input) {
    const errMsg = 'Budget.fromJson Failed:';

    final json = isTypeError<Map>(
      input,
      message: '$errMsg root',
    );

    final id = isTypeError<String>(
      json['id'],
      message: '$errMsg id',
    );
    final userId = isTypeError<String>(
      json['userId'],
      message: '$errMsg userId',
    );
    final name = isTypeError<String>(
      json['name'],
      message: '$errMsg name',
    );
    final currentFunds = isTypeError<num>(
      json['currentFunds'],
      message: '$errMsg currentFunds',
    );

    return Budget(
      id: id,
      userId: userId,
      name: name,
      currentFunds: currentFunds,
    );
  }
}
