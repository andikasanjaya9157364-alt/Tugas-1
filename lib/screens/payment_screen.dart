import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../models/transaction.dart';
import '../services/firestore_service.dart';
import '../widgets/food_icon.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Cash';
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _processPayment() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final items = cartProvider.items;
    final total = cartProvider.total;

    final transaction = Transaction(
      id: const Uuid().v4(),
      items: items,
      total: total,
      date: DateTime.now(),
      paymentMethod: _paymentMethod,
    );

    await _firestoreService.addTransaction(transaction);
    cartProvider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pembayaran berhasil! Total: Rp ${total.toStringAsFixed(0)}'),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Widget _buildPaymentOption(String icon, String title, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _paymentMethod == value
                      ? Theme.of(context).primaryColor
                      : Colors.black87,
                ),
              ),
            ),
            if (_paymentMethod == value)
              Icon(Icons.check_circle,
                  color: Theme.of(context).primaryColor, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;
    final total = cartProvider.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan Pembayaran
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.receipt_long,
                                color: Theme.of(context).primaryColor,
                                size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Ringkasan Pembayaran',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text('Periksa pesanan Anda',
                                    style: TextStyle(
                                        fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Pembayaran',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            Text('Rp ${total.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Detail Pesanan',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).cardColor
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (item.product.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  item.product.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      FoodIcon(
                                          foodName: item.product.name,
                                          size: 50),
                                ),
                              )
                            else
                              FoodIcon(
                                  foodName: item.product.name, size: 50),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  Text(
                                    '${item.quantity} x Rp ${item.product.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${item.total.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text('Metode Pembayaran',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).cardColor
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      _buildPaymentOption('💰', 'Tunai', 'Cash'),
                      const Divider(),
                      _buildPaymentOption('🏦', 'Transfer Bank', 'Transfer'),
                      const Divider(),
                      _buildPaymentOption('📱', 'Dana', 'Dana'),
                      const Divider(),
                      _buildPaymentOption('🟢', 'GoPay', 'GoPay'),
                      const Divider(),
                      _buildPaymentOption('🟣', 'OVO', 'OVO'),
                      const Divider(),
                      _buildPaymentOption('🔴', 'LinkAja', 'LinkAja'),
                      const Divider(),
                      _buildPaymentOption('📊', 'QRIS', 'QRIS'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Konfirmasi Pembayaran',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Pembayaran akan diproses secara aman',
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
