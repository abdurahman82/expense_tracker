import 'package:intl/intl.dart';

// Define the categories for the dropdown
enum ExpenseCategory {
  food,
  transport,
  bills,
  other;

// to convert string to enum                      

  static ExpenseCategory fromString(String value) {           
    for (var category in ExpenseCategory.values) {
      if (category.name == value) return category;
    }
    return ExpenseCategory.other;
    }
}


class Expense {
  final int? id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? note;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });


  String get formattedDate {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  // Convert an Expense object into a Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name, // Store enum as string
      'date': formattedDate, // Store date as string (YYYY-MM-DD)
      'note': note,
    };
  }

  // Convert a Map (from SQLite) into an Expense object                      

  static Expense  fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,                                                  // why ?
      title: map['title'] as String,
      amount: map['amount'] as double,
      category: ExpenseCategory.fromString(map['category'] as String),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
    );
  }
}
