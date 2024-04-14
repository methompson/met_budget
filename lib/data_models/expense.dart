class Expense {
  final String id;
  final String budgetId;
  final String categoryId;
  final String description;
  final num amount;
  final ExpenseTarget expenseTarget;

  Expense({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.expenseTarget,
  });
}

enum ExpenseTargetType {
  weekly,
  monthly,
  dated,
}

class ExpenseTarget {}

class WeeklyExpenseTarget extends ExpenseTarget {
  final int dayOfWeek;

  WeeklyExpenseTarget({
    required this.dayOfWeek,
  });
}

class MonthlyExpenseTarget extends ExpenseTarget {
  final int dayOfMonth;

  MonthlyExpenseTarget({
    required this.dayOfMonth,
  });
}

class DatedExpenseTarget extends ExpenseTarget {
  final DateTime date;

  DatedExpenseTarget({
    required this.date,
  });
}
