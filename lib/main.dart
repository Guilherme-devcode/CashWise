import 'package:cashwise/components/chart.dart';
import 'package:cashwise/components/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: LoginScreen(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Color.fromRGBO(143, 148, 251, .9),
          secondary: Color.fromRGBO(71, 75, 156, 0.781),
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(143, 148, 251, .9),
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  ChartType _chartType = ChartType.bar;
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where(
      (tr) {
        return tr.date.isAfter(DateTime.now().subtract(
          Duration(days: 7),
        ));
      },
    ).toList();
  }

  _addTransaction(String title, double value, DateTime? date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date!,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Despesas',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
        ),
      ),
      actions: <Widget>[
        ToggleButtons(
          color: Colors.white,
          selectedColor: Color.fromARGB(255, 199, 104, 216),
          children: <Widget>[
            Icon(Icons.bar_chart),
            Icon(Icons.insert_chart_outlined_outlined),
            Icon(Icons.show_chart),
          ],
          isSelected: <bool>[
            _chartType == ChartType.sideBar,
            _chartType == ChartType.bar,
            _chartType == ChartType.line,
          ],
          onPressed: (int index) {
            setState(() {
              switch (index) {
                case 0:
                  _chartType = ChartType.sideBar;
                  break;
                case 1:
                  _chartType = ChartType.bar;
                  break;
                case 2:
                  _chartType = ChartType.line;
                  break;
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
        if (isLandScape)
          IconButton(
              icon: Icon(_showChart
                  ? Icons.list
                  : Icons.insert_chart_outlined_outlined),
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              }),
      ],
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dy < 0) {
            _openTransactionFormModal(context);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_showChart || !isLandScape)
                Container(
                    height: availableHeight * (isLandScape ? 0.8 : 0.3),
                    child: Chart(_recentTransactions, _chartType)),
              if (!_showChart || !isLandScape)
                Container(
                    height: availableHeight * (isLandScape ? 1 : 0.7),
                    child: TransactionList(_transactions, _deleteTransaction)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
