import 'package:flutter/foundation.dart';
import '../database/db_helper.dart';
import 'expense.dart';

class ExpenseProvider extends ChangeNotifier { 
  final DBHelper _dbHelper = DBHelper();
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];

  ExpenseProvider() {
    // Load all expenses when the provider is initialized
    loadExpenses();
  }

  // Load all expenses from the database
  Future<void> loadExpenses() async {
    expenses = await _dbHelper.getExpenses();
    filteredExpenses = List.from(expenses); //  filtered list with all expenses
    notifyListeners();
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.createExpense(expense);
    await loadExpenses(); 
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    await loadExpenses(); 
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    await loadExpenses(); 
  }

  //                                                          --- Dashboard/Home Screen Logic ---

  //                                                        Get total expenses for the current month

  double get totalMonthlyExpense {
  final now = DateTime.now();
  double total = 0.0; 

  // 2. Loop through every individual expense in the private list                                      fixed  
  for (var e in expenses) {
    if (e.date.year == now.year && e.date.month == now.month) {  
      total = total + e.amount; 
    }
  }

  return total; 
}

  // Get a list of recent expenses (e.g., top 5)
  List<Expense> get recentExpenses {
    // Since getExpenses already sorts by date DESC, we just take the first few
    return expenses.take(5).toList();
  }

Map<ExpenseCategory, double> get monthlySummaryByCategory {                                                    // edited 
  final now = DateTime.now();
  final Map<ExpenseCategory, double> summary = {};             // empty map

  for (var e in expenses) {
    if (e.date.year == now.year && e.date.month == now.month) {

      if (summary[e.category] == null) {
        summary[e.category] = 0;
      }
      summary[e.category] = summary[e.category]! + e.amount;
    }
  }
  return summary; 
  }

  // --- Filtering, Sorting, and Search Logic (Phase 5) ---

  void applyFilterSortSearch({
  String? category,
  String? sortBy, // 'date' or 'amount'                                                            added 
  String? searchTitle,
}) {
  List<Expense> results = [];   //  list for result

  // 2. FILTERING: Loop through every expense
  for (var expense in expenses) {
    
    // Check A: Does it match the category? 
    // (If category is null, we count everything as a match)
    bool matchesCategory = (category == null || expense.category.name == category);

    // Check B: Does it match the search title?
    // (If search is empty, we count everything as a match)
    bool matchesSearch = true; 
    if (searchTitle != null ) {
      matchesSearch = expense.title.toLowerCase().contains(searchTitle.toLowerCase());
    }

    // If it passes BOTH checks, add it to our results list
    if (matchesCategory && matchesSearch) {
      results.add(expense);
    }
  }

  // 3. SORTING: Arrange the results list
  if (sortBy == 'amount') {
    // Sort by price (Highest first)
    results.sort((a, b) => b.amount.compareTo(a.amount));
  } else {
    // Sort by date (Newest first)
    results.sort((a, b) => b.date.compareTo(a.date));
  }

  // 4. UPDATE: Save the results to the filtered list and tell the UI to refresh
  filteredExpenses = results;
  notifyListeners();
  }
}
