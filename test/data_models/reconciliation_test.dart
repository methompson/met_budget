import 'package:flutter_test/flutter_test.dart';
import 'package:met_budget/data_models/reconciliation.dart';

void main() {
  const id = 'transactionId';
  const budgetId = 'budgetId';
  const dateStr = '2024-04-15';
  const balance = 100.00;

  final date = DateTime.parse(dateStr);

  final validReconciliation = {
    'id': id,
    'budgetId': budgetId,
    'date': dateStr,
    'balance': balance,
  };

  group('Reconciliation', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final rec = Reconciliation(
          id: id,
          budgetId: budgetId,
          date: date,
          balance: balance,
        );

        expect(rec.toJson(), validReconciliation);
      });
    });

    group('newReconciliation', () {
      test('returns a new object', () {
        final rec = Reconciliation.newReconciliation(
          budgetId: budgetId,
          balance: balance,
        );

        final now = DateTime.now();
        final diff = now.difference(rec.date).inSeconds;

        expect(rec.id, isNotNull);
        expect(rec.budgetId, budgetId);
        expect(diff, lessThan(1));
        expect(rec.balance, balance);
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final rec = Reconciliation.fromJson(validReconciliation);

        expect(rec.toJson(), validReconciliation);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final rec1 = Reconciliation.fromJson(validReconciliation);
          final rec2 = Reconciliation.fromJson(rec1.toJson());

          expect(rec1.toJson(), rec2.toJson());
        },
      );

      test('should throw an exception any required value is missing', () {
        var input = {...validReconciliation};
        expect(() => Reconciliation.fromJson(input), returnsNormally);

        input = {...validReconciliation}..remove('id');
        expect(() => Reconciliation.fromJson(input), throwsException);
        input = {...validReconciliation}..remove('budgetId');
        expect(() => Reconciliation.fromJson(input), throwsException);
        input = {...validReconciliation}..remove('date');
        expect(() => Reconciliation.fromJson(input), throwsException);
        input = {...validReconciliation}..remove('balance');
        expect(() => Reconciliation.fromJson(input), throwsException);
      });

      test('should throw an exception if the argument is not a map', () {
        expect(() => Reconciliation.fromJson(''), throwsException);
        expect(() => Reconciliation.fromJson(1), throwsException);
        expect(() => Reconciliation.fromJson(true), throwsException);
        expect(() => Reconciliation.fromJson(null), throwsException);
        expect(() => Reconciliation.fromJson([]), throwsException);
      });
    });
  });
}
