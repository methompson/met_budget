import 'package:flutter_test/flutter_test.dart';

import 'package:met_budget/data_models/expense_category.dart';

import 'package:met_budget/utils/exceptions.dart';

void main() {
  group('Category', () {
    const id = 'categoryId';
    const budgetId = 'budgetId';
    const name = 'categoryName';

    group('toJson', () {
      test('should return a map with expected data', () {
        final cat = ExpenseCategory(
          id: id,
          budgetId: budgetId,
          name: name,
        );

        expect(cat.toJson(), {
          'id': id,
          'budgetId': budgetId,
          'name': name,
        });
      });
    });

    group('newCategory', () {
      test('returns a new object', () {
        final cat = ExpenseCategory.newCategory(
          budgetId: budgetId,
          name: name,
        );

        expect(cat.id, isNotNull);
        expect(cat.budgetId, budgetId);
        expect(cat.name, name);
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final json = {
          'id': id,
          'budgetId': budgetId,
          'name': name,
        };

        final cat = ExpenseCategory.fromJson(json);

        expect(cat.id, id);
        expect(cat.budgetId, budgetId);
        expect(cat.name, name);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final cat1 = ExpenseCategory(
            id: id,
            budgetId: budgetId,
            name: name,
          );
          final cat2 = ExpenseCategory.fromJson(cat1.toJson());

          expect(cat1.toJson(), cat2.toJson());
        },
      );

      test('should throw an exception any required value is missing', () {
        final validInput = {
          'id': id,
          'budgetId': budgetId,
          'name': name,
        };
        var input = {};

        expect(() => ExpenseCategory.fromJson(validInput), returnsNormally);

        input = {...validInput};
        input.remove('id');
        expect(
          () => ExpenseCategory.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('budgetId');
        expect(
          () => ExpenseCategory.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('budgetId'),
          )),
        );

        input = {...validInput};
        input.remove('name');
        expect(
          () => ExpenseCategory.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('name'),
          )),
        );
      });

      test('should throw an exception if the argument is not a map', () {
        expect(
          () => ExpenseCategory.fromJson(1),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => ExpenseCategory.fromJson('1'),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => ExpenseCategory.fromJson(true),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => ExpenseCategory.fromJson(null),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
        expect(
          () => ExpenseCategory.fromJson([]),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('root'),
          )),
        );
      });
    });
  });
}
