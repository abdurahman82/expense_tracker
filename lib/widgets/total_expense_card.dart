import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense_provider.dart';

class TotalExpenseForMonth extends StatelessWidget {
  const TotalExpenseForMonth({super.key});

  @override
  Widget build(BuildContext context) {
    // We "watch" the provider so this widget rebuilds when expenses change
    final totalMonthlyExpense = context.watch<ExpenseProvider>().totalMonthlyExpense;

    // Removed 'const' from Padding because totalMonthlyExpense is a variable
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Total Expenses This Month',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '\$$totalMonthlyExpense',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Summary for ${DateFormat('MMMM yyyy').format(DateTime.now())}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}