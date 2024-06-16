import 'package:cipherschools_flutter_assignment/pages/home_page.dart';
import 'package:flutter/material.dart';

class SeeAllTransactionsPage extends StatefulWidget {
  const SeeAllTransactionsPage({super.key});

  @override
  State<SeeAllTransactionsPage> createState() => _SeeAllTransactionsPageState();
}

class _SeeAllTransactionsPageState extends State<SeeAllTransactionsPage> {
  String range = "Today";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTabBar(onChange: (value) {
              setState(() {
                range = value;
              });
            }),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
                // height: height * 0.7,
                child: TransactionListWidget(range: range))
          ],
        ),
      ),
    );
  }
}