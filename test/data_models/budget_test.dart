import 'package:flutter_test/flutter_test.dart';

import 'package:met_budget/data_models/budget.dart';
import 'package:met_budget/utils/exceptions.dart';

void main() {
  const id = 'budgetId';
  const userId = 'userId';
  const name = 'budgetName';
  const currentFunds = 100;

  group('Budget', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final budget = Budget(
          id: id,
          userId: userId,
          name: name,
          currentFunds: currentFunds,
        );

        final json = budget.toJson();

        expect(json, {
          'id': id,
          'userId': userId,
          'name': name,
          'currentFunds': currentFunds,
        });
      });
    });

    group('newBudget', () {
      test('returns a new object', () {
        final budget = Budget.newBudget(
          userId: userId,
          name: name,
        );

        expect(budget.id, isNotNull);
        expect(budget.userId, userId);
        expect(budget.name, name);
        expect(budget.currentFunds, 0);
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final json = {
          'id': id,
          'userId': userId,
          'name': name,
          'currentFunds': currentFunds,
        };

        final budget = Budget.fromJson(json);

        expect(budget.id, id);
        expect(budget.userId, userId);
        expect(budget.name, name);
        expect(budget.currentFunds, currentFunds);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final budget1 = Budget(
            id: id,
            userId: userId,
            name: name,
            currentFunds: currentFunds,
          );

          final budget2 = Budget.fromJson(budget1.toJson());

          expect(budget1.toJson(), budget2.toJson());
        },
      );

      test('should throw an exception any required value is missing', () {
        final validInput = {
          'id': id,
          'userId': userId,
          'name': name,
          'currentFunds': currentFunds,
        };
        var input = {};

        expect(() => Budget.fromJson(validInput), returnsNormally);

        input = {...validInput};
        input.remove('id');
        expect(
          () => Budget.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('userId');
        expect(
          () => Budget.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('userId'),
          )),
        );

        input = {...validInput};
        input.remove('name');
        expect(
          () => Budget.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('name'),
          )),
        );

        input = {...validInput};
        input.remove('currentFunds');
        expect(
          () => Budget.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.toString().contains('currentFunds'),
          )),
        );
      });

      test('should throw an exception if the argument is not a map', () {
        expect(
          () => Budget.fromJson(1),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => Budget.fromJson('1'),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => Budget.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => Budget.fromJson(null),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => Budget.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
      });
    });
  });
}
