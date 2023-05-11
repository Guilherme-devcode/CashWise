import 'package:cashwise/components/chart_bar.dart';
import 'package:cashwise/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartType {
  sideBar,
  bar,
  line,
}

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final ChartType _chartType;

  Chart(this.recentTransactions, this._chartType);

  List<Map<String, dynamic>> get groupTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if (sameYear && sameDay && sameMonth) {
          totalSum += recentTransactions[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupTransaction.fold(
      0.0,
      (sum, tr) {
        return sum + tr['value'];
      },
    );
  }

  String? formatLabel(dynamic value) {
    final dayOfWeek = DateFormat.E().format(value);
    return dayOfWeek.substring(
        0, 3); // retorna as três primeiras letras do dia da semana abreviado
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Color.fromRGBO(143, 148, 251, .3),
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (_chartType == ChartType.sideBar)
              Container(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Despesas da semana'),
                  series: <BarSeries<Transaction, String>>[
                    BarSeries<Transaction, String>(
                      dataSource: recentTransactions,
                      xValueMapper: (Transaction sales, _) =>
                          formatLabel(sales.date),
                      yValueMapper: (Transaction sales, _) => sales.value,
                      gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, .9),
                            Color.fromRGBO(143, 148, 251, .6),
                          ],
                          stops: [
                            0.2,
                            0.8
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    )
                  ],
                ),
              ),
            if (_chartType == ChartType.line)
              Container(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Despesas da semana'),
                  series: <LineSeries<Transaction, String>>[
                    LineSeries<Transaction, String>(
                      dataSource: recentTransactions,
                      xValueMapper: (Transaction sales, _) =>
                          formatLabel(sales.date),
                      yValueMapper: (Transaction sales, _) => sales.value,
                      color: Color.fromRGBO(143, 148, 251, .9),
                    )
                  ],
                ),
              ),
            if (_chartType == ChartType.bar)
              Container(
                child: SfCartesianChart(
                  isTransposed: true,
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Despesas da semana'),
                  series: <BarSeries<Transaction, String>>[
                    BarSeries<Transaction, String>(
                      dataSource: recentTransactions,
                      xValueMapper: (Transaction sales, _) =>
                          formatLabel(sales.date),
                      yValueMapper: (Transaction sales, _) => sales.value,
                      gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, .9),
                            Color.fromRGBO(143, 148, 251, .6),
                          ],
                          stops: [
                            0.2,
                            0.8
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
