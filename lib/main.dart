import 'package:flutter/material.dart';
import 'package:cipherschools_flutter_assignment/firebase_options.dart';
import 'package:cipherschools_flutter_assignment/pages/analysis_page.dart';
import 'package:cipherschools_flutter_assignment/pages/home_page.dart';
import 'package:cipherschools_flutter_assignment/pages/new_expense.dart';
import 'package:cipherschools_flutter_assignment/pages/profile_page.dart';
import 'package:cipherschools_flutter_assignment/pages/seeAll_transactions_page.dart';
import 'package:cipherschools_flutter_assignment/pages/starting_page.dart';
import 'package:cipherschools_flutter_assignment/providers/user_provider.dart';
import 'package:cipherschools_flutter_assignment/utils/color_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cipherschools_flutter_assignment/pages/new_income.dart';

import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'models/transaction.dart';
import 'providers/transaction_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return const MyHomePage();
          } else {
            return const StartingScreen();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedIndex = 0;
  var heart = false;
  var isExpanded = false;
  final List<Widget> _contentShown = [
    const Home(),
    const SeeAllTransactionsPage(),
    AnalysisPage(),
    const ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Consumer2<UserProvider, TransactionProvider>(
          builder: (context, userProvider, transactionProvider, child) {
            if (userProvider.isLoading || transactionProvider.isLoading) {
              return const Center(
                child: SpinKitWave(
                  color: Colors.orange,
                ),
              );
            }
            return _contentShown.elementAt(_selectedIndex);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? 120.0 : 0,
            width: isExpanded ? 120.0 : 0,
            child: OverflowBox(
              maxWidth: double.infinity,
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewExpensePage()),
                        );
                        setState(() {
                          isExpanded = false;
                        });
                      },
                      child: const Text(
                        'New Expense',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewIncomePage()),
                        );
                        setState(() {
                          isExpanded = false;
                        });
                      },
                      child: const Text(
                        'New Income',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Icon(
              isExpanded ? Icons.close : Icons.add,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StylishBottomBar(
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_filled),
            selectedColor: ColorConstants.primary,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(CupertinoIcons.arrow_right_arrow_left_circle_fill),
            selectedColor: ColorConstants.primary,
            title: const Text('Transaction'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.pie_chart),
            selectedColor: ColorConstants.primary,
            title: const Text('Budget'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person),
            selectedColor: ColorConstants.primary,
            title: const Text('Profile'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != _selectedIndex) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
