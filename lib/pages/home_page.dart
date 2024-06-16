import 'package:cipherschools_flutter_assignment/pages/seeAll_transactions_page.dart';
import 'package:cipherschools_flutter_assignment/providers/user_provider.dart';
import 'package:cipherschools_flutter_assignment/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String range = "Today";

  Future<List<Transaction>> getTransactions() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    final box = await Hive.openBox<Transaction>('transactions');

    return box.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          const MainContainer(),
          const SizedBox(
            height: 5,
          ),
          MyTabBar(onChange: (String value) {
            setState(() {
              range = value;
            });
          }),
          const SizedBox(
            height: 5,
          ),
          const TextWithSeeAllButton(),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Expanded(
                // height: height * 0.4,
                child: TransactionListWidget(
                  range: range,
                ),
              ))
        ],
      ),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  final String range;

  const TransactionListWidget({Key? key, required this.range})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        List<Transaction> transactions = transactionProvider.transactions;

        // Filter transactions based on the specified range
        List<Transaction> filteredTransactions =
            _filterTransactions(transactions);

        if (filteredTransactions.isEmpty && range == "Today") {
          return const Center(
            child: Text(
              "No transactions made Today.",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          );
        } else if (filteredTransactions.isEmpty && range == "Week") {
          return const Center(
            child: Text(
              "No transactions made this week.",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          );
        } else if (filteredTransactions.isEmpty && range == "Month") {
          return const Center(
            child: Text(
              "No transactions made this month.",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          );
        } else if (filteredTransactions.isEmpty && range == "Year") {
          return const Center(
            child: Text(
              "No transactions made this year.",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          );
        }
        // Group transactions by date
        Map<String, List<Transaction>> groupedTransactions = {};

        for (Transaction transaction in filteredTransactions) {
          String dateKey = _getDateHeader(transaction.date);
          if (!groupedTransactions.containsKey(dateKey)) {
            groupedTransactions[dateKey] = [];
          }
          groupedTransactions[dateKey]!.add(transaction);
        }

        List<String> dateKeys = groupedTransactions.keys.toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: dateKeys.length,
          itemBuilder: (context, index) {
            String dateKey = dateKeys[index];
            List<Transaction> dateTransactions = groupedTransactions[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(dateKey),
                ...dateTransactions.map((transaction) => TransactionItem(
                      index: transactions.indexOf(transaction),
                      transaction: transaction,
                    )),
              ],
            );
          },
        );
      },
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    DateTime now = DateTime.now();
    if (range == "Today") {
      return transactions
          .where((transaction) =>
              transaction.date.year == now.year &&
              transaction.date.month == now.month &&
              transaction.date.day == now.day)
          .toList();
    } else if (range == "Week") {
      DateTime startOfWeek = now.subtract(const Duration(days: 6));
      print(startOfWeek);
      return transactions
          .where(
              (transaction) => transaction.date.isAfter(startOfWeek.toLocal()))
          .toList();
    } else if (range == "Month") {
      return transactions
          .where((transaction) =>
              transaction.date.year == now.year &&
              transaction.date.month == now.month)
          .toList();
    } else if (range == "Year") {
      return transactions
          .where((transaction) => transaction.date.year == now.year)
          .toList();
    } else {
      // Default to returning all transactions
      return transactions;
    }
  }

  Widget _buildDateHeader(String dateKey) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        dateKey,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getDateHeader(DateTime transactionDate) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (range == "Today" &&
        transactionDate.year == today.year &&
        transactionDate.month == today.month &&
        transactionDate.day == today.day) {
      return 'Today';
    } else if (range == "Week" &&
        transactionDate.isAfter(today.subtract(const Duration(days: 6)))) {
      return DateFormat.EEEE().format(transactionDate);
    } else if (range == "Month" &&
        transactionDate.year == today.year &&
        transactionDate.month == today.month) {
      return DateFormat('d MMM').format(transactionDate);
    } else if (range == "Year" && transactionDate.year == today.year) {
      return DateFormat('MMMM').format(transactionDate);
    } else {
      return DateFormat('MMMM d, yyyy').format(transactionDate);
    }
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.index,
  }) : super(key: key);

  Widget _buildTypeContainer(Color color, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: SvgPicture.asset(assetPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget typeContainer;

    switch (transaction.category) {
      case "Shopping":
        typeContainer = _buildTypeContainer(
            Colors.orange.shade100, 'assets/icons/ic_shopping_bag.svg');
        break;
      case "Travel":
        typeContainer = _buildTypeContainer(
            Colors.blue.shade100, 'assets/icons/ic_travel.svg');
        break;
      case "Subscription":
        typeContainer = _buildTypeContainer(
            Colors.purple.shade100, 'assets/icons/ic_subscription.svg');
        break;
      case "Food":
        typeContainer = _buildTypeContainer(
            Colors.red.shade100, 'assets/icons/ic_food.svg');
        break;
      default:
        typeContainer = Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: const Icon(
            Icons.money_rounded,
            color: Colors.green,
          ),
        ); // Default container or handle unknown categories
    }

    return Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
      return Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showDeleteTransactionAlert(context, transactionProvider);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showDeleteTransactionAlert(context, transactionProvider);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    typeContainer,
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.category,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(transaction.description)
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.isCredit
                        ? '+₹${transaction.amount.toStringAsFixed(0)}'
                        : '-₹${transaction.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                        color: transaction.isCredit ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(DateFormat('hh:mm a').format(transaction.date))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> showDeleteTransactionAlert(
      BuildContext context, TransactionProvider transactionProvider) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange.shade100,
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Do not delete
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                transactionProvider.deleteTransaction(index);
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class TextWithSeeAllButton extends StatelessWidget {
  const TextWithSeeAllButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SeeAllTransactionsPage()));
            },
            splashColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple.shade100),
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<TransactionProvider>(
        builder: (context, trasactionProvider, child) {
      double expenses = trasactionProvider.expensesInMonth();
      double income = trasactionProvider.incomeInMonth();

      return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const TopNavigation(),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Account Balance',
              style: TextStyle(color: ColorConstants.fontColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '₹${(income - expenses).toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(3),
                  height: 80,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 48,
                          width: 48,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SvgPicture.asset(
                            'assets/icons/ic_income.svg',
                            width: 20,
                            height: 20,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Income',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('₹${income.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.white))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(3),
                  height: 80,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 48,
                          width: 48,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SvgPicture.asset(
                            'assets/icons/ic_expense.svg',
                            width: 20,
                            height: 20,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expenses',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text('₹${expenses.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.white))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

class MyTabBar extends StatefulWidget {
  Function onChange;
  MyTabBar({
    super.key,
    required this.onChange,
  });

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  String range = "Today";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            widget.onChange("Today");
            setState(() {
              range = "Today";
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: range == "Today"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.shade100)
                : const BoxDecoration(),
            child: Text(
              'Today',
              style: TextStyle(
                  color: range == "Today" ? Colors.orange : Colors.black),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            widget.onChange("Week");
            setState(() {
              range = "Week";
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: range == "Week"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.shade100)
                : const BoxDecoration(),
            child: Text(
              'Week',
              style: TextStyle(
                  color: range == "Week" ? Colors.orange : Colors.black),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            widget.onChange("Month");
            setState(() {
              range = "Month";
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: range == "Month"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.shade100)
                : const BoxDecoration(),
            child: Text(
              'Month',
              style: TextStyle(
                  color: range == "Month" ? Colors.orange : Colors.black),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.onChange("Year");
            setState(() {
              range = "Year";
            });
          },
          splashColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: range == "Year"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.shade100)
                : const BoxDecoration(),
            child: Text(
              'Year',
              style: TextStyle(
                  color: range == "Year" ? Colors.orange : Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class TopNavigation extends StatefulWidget {
  const TopNavigation({super.key});

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
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
    return Consumer2<TransactionProvider, UserProvider>(
        builder: (context, transactionProvider, userProvider, child) {
      return Container(
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorConstants.primary, width: 1)),
              child: Container(
                  child: ClipOval(
                child: Image(
                  image: NetworkImage(userProvider.userInfo.purl.toString()),
                ),
              )),
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
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: ColorConstants.primary,
                  size: 32,
                ))
          ],
        ),
      );
    });
  }
}