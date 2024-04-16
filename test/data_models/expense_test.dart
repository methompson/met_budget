import 'package:flutter_test/flutter_test.dart';

import 'package:met_budget/data_models/expense.dart';
import 'package:met_budget/utils/exceptions.dart';

void main() {
  group('ExpenseTarget Tests', () {
    group('expenseTargetTypeFromString', () {
      test('should return the correct enum value', () {
        expect(expenseTargetTypeFromString('weekly'), ExpenseTargetType.weekly);
        expect(
            expenseTargetTypeFromString('monthly'), ExpenseTargetType.monthly);
        expect(expenseTargetTypeFromString('dated'), ExpenseTargetType.dated);
      });

      test('should throw an exception for an invalid input', () {
        expect(() => expenseTargetTypeFromString('invalid'),
            throwsA(isA<InvalidInputException>()));
      });
    });

    group('ExpenseTarget', () {
      group('fromJson', () {
        test('returns a WeeklyExpenseTarget', () {
          final json = {
            'type': 'weekly',
            'data': {
              'dayOfWeek': 1,
            },
          };

          final target = ExpenseTarget.fromJson(json);

          expect(target, isA<WeeklyExpenseTarget>());
        });

        test('returns a MonthlyExpenseTarget', () {
          final json = {
            'type': 'monthly',
            'data': {
              'dayOfMonth': 1,
            },
          };

          final target = ExpenseTarget.fromJson(json);

          expect(target, isA<MonthlyExpenseTarget>());
        });

        test('returns a DatedExpenseTarget', () {
          final json = {
            'type': 'dated',
            'data': {
              'date': '2024-04-15',
            },
          };

          final target = ExpenseTarget.fromJson(json);

          expect(target, isA<DatedExpenseTarget>());
        });

        test('throws an error if the input is not a map', () {
          expect(
            () => ExpenseTarget.fromJson('1'),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => ExpenseTarget.fromJson(1),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => ExpenseTarget.fromJson(true),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => ExpenseTarget.fromJson(null),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => ExpenseTarget.fromJson([]),
            throwsA(isA<TypeCheckException>()),
          );
        });

        test('throws an error if type is not a string', () {
          final json = {
            'type': 1,
            'data': {
              'dayOfWeek': 1,
            },
          };

          expect(
            () => ExpenseTarget.fromJson(json),
            throwsA(isA<TypeCheckException>()),
          );
        });

        test('throws an error if type is not valid', () {
          final json = {
            'type': 'invalid',
            'data': {
              'dayOfWeek': 1,
            },
          };

          expect(
            () => ExpenseTarget.fromJson(json),
            throwsA(isA<InvalidInputException>()),
          );
        });

        test('throws an error if data is invalid', () {
          final json = {
            'type': 'weekly',
            'data': {
              'dayOfWeek': 8,
            },
          };

          expect(
            () => ExpenseTarget.fromJson(json),
            throwsA(isA<InvalidInputException>()),
          );
        });
      });
    });

    group('WeeklyExpenseTarget', () {
      group('toJson', () {
        test('should return a map with expected data', () {
          final target = WeeklyExpenseTarget(
            dayOfWeek: 1,
          );

          expect(target.toJson(), {
            'type': 'weekly',
            'data': {
              'dayOfWeek': 1,
            },
          });
        });
      });

      group('fromJson', () {
        test('should return a valid object', () {
          final json = {
            'type': 'weekly',
            'data': {
              'dayOfWeek': 1,
            },
          };

          final target = WeeklyExpenseTarget.fromJson(json);

          expect(target.dayOfWeek, 1);
        });

        test(
          'toJson can be piped into fromJson and return an object with duplicate values',
          () {
            final target1 = WeeklyExpenseTarget(
              dayOfWeek: 1,
            );

            final target2 = WeeklyExpenseTarget.fromJson(target1.toJson());

            expect(target1.toJson(), target2.toJson());
          },
        );

        test('throws an error if values are missing or invalid', () {
          final validData = {
            'dayOfWeek': 1,
          };
          final validInput = {
            'type': 'weekly',
            'data': validData,
          };

          var data = {};
          var input = {};

          expect(
            () => WeeklyExpenseTarget.fromJson(validInput),
            returnsNormally,
          );

          data = {...validData};
          data.remove('dayOfWeek');
          input = {...validInput, 'data': data};
          expect(
            () => WeeklyExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) =>
                  e is TypeCheckException && e.toString().contains('dayOfWeek'),
            )),
          );

          data = {...validData};
          data['dayOfWeek'] = 8;
          input = {...validInput, 'data': data};
          expect(
            () => WeeklyExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) =>
                  e is InvalidInputException &&
                  e.toString().contains('dayOfWeek'),
            )),
          );
        });

        test('throws an error if the input is not a map', () {
          expect(
            () => WeeklyExpenseTarget.fromJson('1'),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => WeeklyExpenseTarget.fromJson(1),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => WeeklyExpenseTarget.fromJson(true),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => WeeklyExpenseTarget.fromJson(null),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => WeeklyExpenseTarget.fromJson([]),
            throwsA(isA<TypeCheckException>()),
          );
        });
      });
    });

    group('MonthlyExpenseTarget', () {
      group('toJson', () {
        test('should return a map with expected data', () {
          final met = MonthlyExpenseTarget(dayOfMonth: 1);

          expect(met.toJson(), {
            'type': 'monthly',
            'data': {
              'dayOfMonth': 1,
            },
          });
        });
      });

      group('fromJson', () {
        test('should return a valid object', () {
          final json = {
            'type': 'monthly',
            'data': {
              'dayOfMonth': 1,
            },
          };

          final met = MonthlyExpenseTarget.fromJson(json);

          expect(met.dayOfMonth, 1);
        });

        test(
          'toJson can be piped into fromJson and return an object with duplicate values',
          () {
            final target1 = MonthlyExpenseTarget(dayOfMonth: 1);
            final target2 = MonthlyExpenseTarget.fromJson(target1.toJson());

            expect(target1.toJson(), target2.toJson());
          },
        );

        test('throws an error if values are missing or invalid', () {
          final validData = {
            'dayOfMonth': 1,
          };
          final validInput = {
            'type': 'monthly',
            'data': validData,
          };

          var data = {};
          var input = {};

          expect(
            () => MonthlyExpenseTarget.fromJson(validInput),
            returnsNormally,
          );

          data = {...validData};
          data.remove('dayOfMonth');
          input = {...validInput, 'data': data};
          expect(
            () => MonthlyExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) =>
                  e is TypeCheckException &&
                  e.toString().contains('dayOfMonth'),
            )),
          );

          data = {...validData};
          data['dayOfMonth'] = 0;
          input = {...validInput, 'data': data};
          expect(
            () => MonthlyExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) =>
                  e is InvalidInputException &&
                  e.toString().contains('dayOfMonth'),
            )),
          );
        });

        test('throws an error if the input is not a map', () {
          expect(
            () => MonthlyExpenseTarget.fromJson('1'),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => MonthlyExpenseTarget.fromJson(1),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => MonthlyExpenseTarget.fromJson(true),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => MonthlyExpenseTarget.fromJson(null),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => MonthlyExpenseTarget.fromJson([]),
            throwsA(isA<TypeCheckException>()),
          );
        });
      });
    });

    group('DatedExpenseTarget', () {
      group('toJson', () {
        test('should return a map with expected data', () {
          final det = DatedExpenseTarget(date: DateTime.parse('2024-04-15'));

          expect(det.toJson(), {
            'type': 'dated',
            'data': {
              'date': '2024-04-15',
            },
          });
        });
      });

      group('fromJson', () {
        test('should return a valid object', () {
          final json = {
            'type': 'dated',
            'data': {
              'date': '2024-04-15',
            },
          };

          final det = DatedExpenseTarget.fromJson(json);

          expect(det.date, DateTime.parse('2024-04-15'));
        });

        test(
          'toJson can be piped into fromJson and return an object with duplicate values',
          () {
            final target1 =
                DatedExpenseTarget(date: DateTime.parse('2024-04-15'));
            final target2 = DatedExpenseTarget.fromJson(target1.toJson());

            expect(target1.toJson(), target2.toJson());
          },
        );

        test('throws an error if values are missing or invalid', () {
          final validData = {
            'date': '2024-04-15',
          };
          final validInput = {
            'type': 'dated',
            'data': validData,
          };

          var data = {};
          var input = {};

          expect(
            () => DatedExpenseTarget.fromJson(validInput),
            returnsNormally,
          );

          data = {...validData};
          data.remove('date');
          input = {...validInput, 'data': data};
          expect(
            () => DatedExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) => e is TypeCheckException && e.toString().contains('date'),
            )),
          );

          data = {...validData};
          data['date'] = 'invalid';
          input = {...validInput, 'data': data};
          expect(
            () => DatedExpenseTarget.fromJson(input),
            throwsA(predicate(
              (e) => e is FormatException,
            )),
          );
        });

        test('throws an error if the input is not a map', () {
          expect(
            () => DatedExpenseTarget.fromJson('1'),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => DatedExpenseTarget.fromJson(1),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => DatedExpenseTarget.fromJson(true),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => DatedExpenseTarget.fromJson(null),
            throwsA(isA<TypeCheckException>()),
          );
          expect(
            () => DatedExpenseTarget.fromJson([]),
            throwsA(isA<TypeCheckException>()),
          );
        });
      });
    });
  });

  group('Expense', () {
    group('toJson', () {
      test('should return a map with expected data', () {
        final target = WeeklyExpenseTarget(dayOfWeek: 1);
        final expense = Expense(
          id: '1',
          budgetId: '1',
          categoryId: '1',
          description: 'description',
          amount: 1,
          expenseTarget: target,
        );

        expect(expense.toJson(), {
          'id': '1',
          'budgetId': '1',
          'categoryId': '1',
          'description': 'description',
          'amount': 1,
          'expenseTarget': target.toJson(),
        });
      });
    });

    group('fromJson', () {
      test('should return a valid object', () {
        final target = WeeklyExpenseTarget(dayOfWeek: 1);
        final json = {
          'id': '1',
          'budgetId': '1',
          'categoryId': '1',
          'description': 'description',
          'amount': 1,
          'expenseTarget': target.toJson(),
        };

        final expense = Expense.fromJson(json);

        expect(expense.id, json['id']);
        expect(expense.budgetId, json['budgetId']);
        expect(expense.categoryId, json['categoryId']);
        expect(expense.description, json['description']);
        expect(expense.amount, json['amount']);
        expect(expense.expenseTarget.toJson(), json['expenseTarget']);
      });

      test(
        'toJson can be piped into fromJson and return an object with duplicate values',
        () {
          final expense1 = Expense(
            id: '1',
            budgetId: '1',
            categoryId: '1',
            description: 'description',
            amount: 1,
            expenseTarget: WeeklyExpenseTarget(dayOfWeek: 1),
          );

          final expense2 = Expense.fromJson(expense1.toJson());

          expect(expense1.toJson(), expense2.toJson());
        },
      );

      test('throws an error if values are missing', () {
        final validInput = {
          'id': '1',
          'budgetId': '1',
          'categoryId': '1',
          'description': 'description',
          'amount': 1,
          'expenseTarget': WeeklyExpenseTarget(dayOfWeek: 1).toJson(),
        };

        var input = {};

        expect(
          () => Expense.fromJson(validInput),
          returnsNormally,
        );

        input = {...validInput};
        input.remove('id');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('id'),
          )),
        );

        input = {...validInput};
        input.remove('budgetId');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('budgetId'),
          )),
        );

        input = {...validInput};
        input.remove('categoryId');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException && e.toString().contains('categoryId'),
          )),
        );

        input = {...validInput};
        input.remove('description');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException && e.toString().contains('description'),
          )),
        );

        input = {...validInput};
        input.remove('amount');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) => e is TypeCheckException && e.toString().contains('amount'),
          )),
        );

        input = {...validInput};
        input.remove('expenseTarget');
        expect(
          () => Expense.fromJson(input),
          throwsA(predicate(
            (e) =>
                e is TypeCheckException &&
                e.toString().contains('expenseTarget'),
          )),
        );
      });
    });
  });
}
