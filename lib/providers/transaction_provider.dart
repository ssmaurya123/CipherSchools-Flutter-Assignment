import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  late Box<Transaction> _transactionBox;
  bool _isLoading = true;
  int selectedMonth = DateTime.now().month;

  TransactionProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    final appDocumentDirectory =
        await Hive.openBox<Transaction>('transactions');
    _transactionBox = appDocumentDirectory;
    notifyListeners();
    _isLoading = false;
  }

  List<Transaction> get transactions => _transactionBox.values.toList();
  bool get isLoading => _isLoading;

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.add(transaction);
    notifyListeners();
  }

  Future<void> deleteTransaction(int index) async {
    await _transactionBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> onSelectedMonthChange(int month) async {
    selectedMonth = month;
    notifyListeners();
  }

  double expensesInMonth() {
    return transactions
        .where((transaction) =>
            transaction.date.month == selectedMonth && !transaction.isCredit)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double incomeInMonth() {
    return transactions
        .where((transaction) =>
            transaction.date.month == selectedMonth && transaction.isCredit)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }
}