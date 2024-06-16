import 'package:cipherschools_flutter_assignment/providers/transaction_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalysisPage extends StatelessWidget {
  AnalysisPage({super.key});

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        double expenses = transactionProvider.expensesInMonth();
        double income = transactionProvider.incomeInMonth();
        return Scaffold(
            body: Stack(children: [
          Container(
            height: height * 0.4,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade100,
                  Colors.white
                ], // Adjust colors as needed
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Month-wise analysis",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              DropdownButton<String>(
                value: months[transactionProvider.selectedMonth -
                    1], // Set the default selected month
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    transactionProvider
                        .onSelectedMonthChange(months.indexOf(newValue) + 1);
                  }
                },
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Flexible(
                  child: Container(
                padding:
                    const EdgeInsets.only(top: 80, bottom: 80, right: 20, left: 20),
                child: BarGraphWidget(
                  income: income,
                  expense: expenses,
                  savings: income - expenses,
                ),
              ))
            ],
          ),
        ]));
      },
    );
  }
}

class BarGraphWidget extends StatelessWidget {
  final double income;
  final double expense;
  final double savings;

  const BarGraphWidget({
    super.key,
    required this.income,
    required this.expense,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeries(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  List<charts.Series<BarChartData, String>> _createSeries() {
    final data = [
      BarChartData(
          'Income', int.parse(income.toStringAsFixed(0)), Colors.green),
      BarChartData(
          'Expenses', int.parse(expense.toStringAsFixed(0)), Colors.red),
      BarChartData(
          'Savings', int.parse(savings.toStringAsFixed(0)), Colors.blue),
    ];

    return [
      charts.Series<BarChartData, String>(
        id: 'BarChart',
        domainFn: (BarChartData sales, _) => sales.category,
        measureFn: (BarChartData sales, _) => sales.value,
        colorFn: (BarChartData sales, _) =>
            charts.ColorUtil.fromDartColor(sales.color),
        data: data,
      ),
    ];
  }
}

class BarChartData {
  final String category;
  final int value;
  final Color color;

  BarChartData(this.category, this.value, this.color);
}