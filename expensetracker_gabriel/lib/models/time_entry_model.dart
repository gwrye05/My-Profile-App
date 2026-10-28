class Expense {
  final String id;

  final String title;

  final double amount;

  final String categoryId;

  final DateTime date;

  final String notes;

  Expense({
    required this.id,

    required this.title,

    required this.amount,

    required this.categoryId,

    required this.date,

    required this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,

      title: json['title'] as String,

      amount: (json['amount'] as num).toDouble(),

      categoryId: json['categoryId'] as String,

      date: DateTime.parse(json['date'] as String),

      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'title': title,

      'amount': amount,

      'categoryId': categoryId,

      'date': date.toIso8601String(),

      'notes': notes,
    };
  }
}
