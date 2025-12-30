import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/expense_provider.dart';
import 'add_expense_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  void _deleteExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( 
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete the expense: ${expense.title}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("DELETE", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id!);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to the previous screen (List/Home)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildExpenseDetailRow(
                  context,
                  'Title',
                  expense.title,
                  Icons.title,
                ),
                buildExpenseDetailRow(
                  context,
                  'Amount',
                  '\$ ${expense.amount}',
                  Icons.money,
                ),
                buildExpenseDetailRow(
                  context,
                  'Category',
                  expense.category.name.toUpperCase(),
                  Icons.category,
                ),
                buildExpenseDetailRow(
                  context,
                  'Date',
                  expense.formattedDate,
                  Icons.calendar_today,
                ),
                if (expense.note != null && expense.note!.isNotEmpty)
                  buildExpenseDetailRow(
                    context,
                    'Note',
                    expense.note!,
                    Icons.notes,
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Edit Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AddExpenseScreen(expenseToEdit: expense),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('EDIT'),
                    ),
                    // Delete Button
                    ElevatedButton.icon(
                      onPressed: () => _deleteExpense(context),
                      icon: const Icon(Icons.delete),
                      label: const Text('DELETE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExpenseDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
