import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/total_expense_card.dart';
import '../widgets/monthly_chart.dart';
import 'add_expense_screen.dart';
import 'expenses_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);        //                                       not clear 
    final recentExpenses = expenseProvider.recentExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExpensesListScreen(),
                ),
              );
            },
            tooltip: 'View All Expenses',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // 1. Total Expenses for the Current Month

              const TotalExpenseForMonth(),

            // 2. List of Recent Expenses
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                'Recent Expenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (recentExpenses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),                                        
                  child: Text('No recent expenses. Add one now!'),
                ),
              )
            else
              for (var e in recentExpenses) 
                ExpenseCard(expense: e ), 
            
            //   3 Pie Chart                             <<<<<
            const Padding( 
              padding: EdgeInsets.all(16.0),
              child: MonthlyChart(),
            ),
          ],                                                                      // end of list in colums 
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
        tooltip: 'Add New Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
