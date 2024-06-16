import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  String category;

  @HiveField(1)
  String description;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  bool isCredit;

  @HiveField(5)
  String key;

  Transaction(
      {required this.category,
      required this.description,
      required this.amount,
      required this.date,
      required this.isCredit,
      required this.key});
}