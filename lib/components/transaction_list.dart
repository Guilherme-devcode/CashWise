import 'package:cashwise/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;
  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Nenhuma transação Cadastrada',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tr = transactions[index];
              return Card(
                elevation: 5,
                shadowColor: Color.fromRGBO(143, 148, 251, .3),
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromRGBO(71, 75, 156, 0.781),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                          'R\$${tr.value.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? TextButton.icon(
                          onPressed: () => onRemove(tr.id),
                          icon: const Icon(Icons.delete),
                          label: const Text('Excluir'),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).errorColor),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => onRemove(tr.id),
                        ),
                ),
              );
            },
          );
  }
}
