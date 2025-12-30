import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/expense_provider.dart';
import '../widgets/expense_card.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  String? _selectedCategoryFilter;
  String _sortBy = 'date'; // 'date' or 'amount'
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial load of all expenses
    Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    provider.applyFilterSortSearch(
      category: _selectedCategoryFilter,
      sortBy: _sortBy,
      searchTitle: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
      ),
      body: Column(
        children: [
          // Filter, Sort, and Search Bar (Phase 5)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Title',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // Filters and Sort Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Filter by Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        initialValue: _selectedCategoryFilter,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Categories')),
                          ...ExpenseCategory.values.map((e) => DropdownMenuItem(
                            value: e.name,
                            child: Text(e.name.toUpperCase()),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryFilter = value;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort By
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Sort By',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        initialValue: _sortBy,
                        items: const [
                          DropdownMenuItem(value: 'date', child: Text('Date')),
                          DropdownMenuItem(value: 'amount', child: Text('Amount')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                            _applyFilters();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expenses List
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                final expenses = provider.filteredExpenses;

                if (expenses.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ExpenseCard(expense: expense);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
