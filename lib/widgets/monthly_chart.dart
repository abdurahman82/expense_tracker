import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/expense_provider.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = context.watch<ExpenseProvider>().monthlySummaryByCategory;

    if (summary.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No expenses this month to display chart.'),
        ),
      );
    }

    // Prepare PieChartSectionData
    final List<PieChartSectionData> sections = [];

    summary.forEach((category, amount) {
      const double radius =  50;
      final color = _getCategoryColor(category) ;
      sections.add(
        PieChartSectionData(
          color: color,
          value: amount,
          title: '\$$amount',
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[                                                  // what
              const Text(
                'Monthly Expense Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: sections,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Align items to the left
                children: [
                  for (var category in summary.keys) ...[
                    // 1. Calculate the color just like before
                    Builder(
                      builder: (context) {
                        final color = _getCategoryColor(category);
                        
                        return _Indicator(
                          color: color,
                          text: category.name.toUpperCase(),
                        );
                      },
                    ),
                    // 2. Add manual spacing (since Row doesn't have a 'spacing' parameter)
                    const SizedBox(width: 8.0),
                  ],
                ],
              )
            ],
          ),
        ),
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

}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle ,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
