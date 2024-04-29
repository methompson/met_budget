import 'package:flutter_test/flutter_test.dart';
import 'package:met_budget/data_models/deposit_transaction.dart';

void main() {
  const id = 'transactionId';
  const budgetId = 'budgetId';
  const payor = 'my job';
  const description = 'My description';
  const dateTimeStr = '2024-04-15T12:00:00.000Z';
  const amount = 100.00;

  final dateTime = DateTime.parse(dateTimeStr);

  final validDeposit = {
    'id': id,
    'budgetId': budgetId,
    'payor': payor,
    'description': description,
    'dateTime': dateTimeStr,
    'amount': amount,
  };

  group('DepositTransaction', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final dep = DepositTransaction(
          id: id,
          budgetId: budgetId,
          payor: payor,
          description: description,
          dateTime: dateTime,
          amount: amount,
        );

        expect(dep.toJson(), validDeposit);
      });
    });

    group('newDeposit', () {
      test('returns a new object', () {
        final dep = DepositTransaction.newDeposit(
          budgetId: budgetId,
          payor: payor,
          description: description,
          amount: amount,
        );

        final now = DateTime.now();
        final diff = now.difference(dep.dateTime).inSeconds;

        expect(dep.id, isNotNull);
        expect(dep.budgetId, budgetId);
        expect(dep.description, description);
        expect(diff, lessThan(1));
        expect(dep.amount, amount);
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final dep = DepositTransaction.fromJson(validDeposit);

        expect(dep.toJson(), validDeposit);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final dep1 = DepositTransaction.fromJson(validDeposit);
          final dep2 = DepositTransaction.fromJson(dep1.toJson());

          expect(dep1.toJson(), dep2.toJson());
        },
      );

      test('should throw an exception any required value is missing', () {
        var input = {...validDeposit};

        expect(() => DepositTransaction.fromJson(input), returnsNormally);

        input = {...validDeposit}..remove('id');
        expect(() => DepositTransaction.fromJson(input), throwsException);
        input = {...validDeposit}..remove('budgetId');
        expect(() => DepositTransaction.fromJson(input), throwsException);
        input = {...validDeposit}..remove('description');
        expect(() => DepositTransaction.fromJson(input), throwsException);
        input = {...validDeposit}..remove('dateTime');
        expect(() => DepositTransaction.fromJson(input), throwsException);
        input = {...validDeposit}..remove('amount');
        expect(() => DepositTransaction.fromJson(input), throwsException);
      });

      test('should throw an exception if the argument is not a map', () {
        expect(() => DepositTransaction.fromJson(''), throwsException);
        expect(() => DepositTransaction.fromJson(1), throwsException);
        expect(() => DepositTransaction.fromJson(true), throwsException);
        expect(() => DepositTransaction.fromJson(null), throwsException);
        expect(() => DepositTransaction.fromJson([]), throwsException);
      });
    });
  });
}
