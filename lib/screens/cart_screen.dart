import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import '../models/transaction.dart';
import '../widgets/food_icon.dart';
import 'package:uuid/uuid.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          leading: item.product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    item.product.imageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return FoodIcon(foodName: item.product.name, size: 50);
                                    },
                                  ),
                                )
                              : FoodIcon(foodName: item.product.name, size: 50),
                          title: Text(item.product.name),
                          subtitle: Text('Rp ${item.product.price.toStringAsFixed(0)} x ${item.quantity} = Rp ${item.total.toStringAsFixed(0)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cartProvider.updateQuantity(item.product.id, item.quantity - 1);
                                  } else {
                                    cartProvider.removeItem(item.product.id);
                                  }
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cartProvider.updateQuantity(item.product.id, item.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: Rp ${cartProvider.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: items.isEmpty ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentScreen()),
                          );
                        },
                        child: const Text('Bayar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}