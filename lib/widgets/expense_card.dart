import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../screens/expense_detail_screen.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(expense.category),
          child: Icon(_getCategoryIcon(expense.category), color: Colors.white),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${expense.category.name.toUpperCase()} - ${expense.formattedDate}',                       //   expense catogary , formatted date 
        ),
        trailing: Text(
          '\$${expense.amount}',
          // NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(expense.amount),                      dropped 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onTap: () {
          // Navigate to Expense Details Screen
          Navigator.of(context).push(                                                                  // not clear syntax
            MaterialPageRoute(
              builder: (context) => ExpenseDetailScreen(expense: expense),
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.red;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.bills:
        return Colors.green;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.fastfood;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.bills:
        return Icons.receipt;
      case ExpenseCategory.other:
        return Icons.category;
    }
  }
}
