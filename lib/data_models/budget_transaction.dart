class BudgetTransaction {
  final String id;
  final String budgetId;
  final String description;
  final DateTime dateTime;
  final num amount;

  BudgetTransaction({
    required this.id,
    required this.budgetId,
    required this.description,
    required this.dateTime,
    required this.amount,
  });
}
