import 'package:flutter_test/flutter_test.dart';
import 'package:met_budget/data_models/withdrawal_transaction.dart';

void main() {
  const id = 'transactionId';
  const budgetId = 'budgetId';
  const expenseId = 'expenseId';
  const payee = 'Italian Restaurant';
  const description = 'My description';
  const dateTimeStr = '2024-04-15T12:00:00.000Z';
  const amount = 100.00;

  final dateTime = DateTime.parse(dateTimeStr);

  final validWithdrawal = {
    'id': id,
    'budgetId': budgetId,
    'expenseId': expenseId,
    'payee': payee,
    'description': description,
    'dateTime': dateTimeStr,
    'amount': amount,
  };

  group('WithdrawalTransaction', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final wd = WithdrawalTransaction(
          id: id,
          budgetId: budgetId,
          expenseId: expenseId,
          payee: payee,
          description: description,
          dateTime: dateTime,
          amount: amount,
        );

        expect(wd.toJson(), validWithdrawal);
      });
    });

    group('newWithdrawal', () {
      test('returns a new object', () {
        final wd = WithdrawalTransaction.newWithdrawal(
          budgetId: budgetId,
          expenseId: expenseId,
          payee: payee,
          description: description,
          amount: amount,
        );

        final now = DateTime.now();
        final diff = now.difference(wd.dateTime).inSeconds;

        expect(wd.id, isNotNull);
        expect(wd.budgetId, budgetId);
        expect(wd.expenseId, expenseId);
        expect(wd.description, description);
        expect(wd.amount, amount);
        expect(diff, lessThan(1));
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final wd = WithdrawalTransaction.fromJson(validWithdrawal);

        expect(wd.toJson(), validWithdrawal);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final wd1 = WithdrawalTransaction.fromJson(validWithdrawal);
          final wd2 = WithdrawalTransaction.fromJson(wd1.toJson());

          expect(wd1.toJson(), wd2.toJson());
        },
      );

      test('should throw an exception any required value is missing', () {
        var input = {...validWithdrawal};
        expect(() => WithdrawalTransaction.fromJson(input), returnsNormally);

        input = {...validWithdrawal}..remove('id');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
        input = {...validWithdrawal}..remove('budgetId');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
        input = {...validWithdrawal}..remove('expenseId');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
        input = {...validWithdrawal}..remove('description');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
        input = {...validWithdrawal}..remove('dateTime');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
        input = {...validWithdrawal}..remove('amount');
        expect(() => WithdrawalTransaction.fromJson(input), throwsException);
      });

      test('should throw an exception if the argument is not a map', () {
        expect(() => WithdrawalTransaction.fromJson(''), throwsException);
        expect(() => WithdrawalTransaction.fromJson(1), throwsException);
        expect(() => WithdrawalTransaction.fromJson(true), throwsException);
        expect(() => WithdrawalTransaction.fromJson(null), throwsException);
        expect(() => WithdrawalTransaction.fromJson([]), throwsException);
      });
    });
  });
}
