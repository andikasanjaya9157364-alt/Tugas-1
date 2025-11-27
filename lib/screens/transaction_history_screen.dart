import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart' as my_transaction;
import '../services/firestore_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<my_transaction.Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _firestoreService.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: _transactions.isEmpty
          ? const Center(child: Text('Belum ada transaksi'))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Transaksi ${transaction.id.substring(0, 8)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd/MM/yyyy HH:mm').format(transaction.date)),
                        Text('Metode: ${transaction.paymentMethod}'),
                        Text('${transaction.items.length} item(s)'),
                      ],
                    ),
                    trailing: Text(
                      'Rp ${transaction.total.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Show transaction details
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Detail Transaksi ${transaction.id.substring(0, 8)}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: transaction.items.map((item) {
                              return Text('${item.product.name} x ${item.quantity} = Rp ${item.total.toStringAsFixed(0)}');
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}