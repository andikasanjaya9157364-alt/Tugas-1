import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _firestoreService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
              _loadProducts(); // Reload products after adding
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Belum ada produk'))
             : RefreshIndicator(
                 onRefresh: _loadProducts,
                 child: ListView.builder(
                   itemCount: _products.length,
                   itemBuilder: (context, index) {
                     final product = _products[index];
                     return Card(
                       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                       child: ListTile(
                         leading: product.imageUrl != null
                             ? ClipRRect(
                                 borderRadius: BorderRadius.circular(8.0),
                                 child: Image.asset(
                                   product.imageUrl!,
                                   width: 60,
                                   height: 60,
                                   fit: BoxFit.cover,
                                   errorBuilder: (context, error, stackTrace) {
                                     return Container(
                                       width: 60,
                                       height: 60,
                                       color: Colors.grey[300],
                                       child: const Icon(Icons.image, color: Colors.grey),
                                     );
                                   },
                                 ),
                               )
                             : Container(
                                 width: 60,
                                 height: 60,
                                 color: Colors.grey[300],
                                 child: const Icon(Icons.image, color: Colors.grey),
                               ),
                         title: Text(product.name),
                         subtitle: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Rp ${product.price.toStringAsFixed(0)}'),
                             Text('Stok: ${product.stock}', style: const TextStyle(fontSize: 12)),
                           ],
                         ),
                         trailing: IconButton(
                           icon: const Icon(Icons.add_shopping_cart),
                           onPressed: () {
                             context.read<CartProvider>().addItem(product);
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('${product.name} ditambahkan ke keranjang')),
                             );
                           },
                         ),
                         onTap: () {
                           // Show product details
                           showDialog(
                             context: context,
                             builder: (context) => AlertDialog(
                               title: Text(product.name),
                               content: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   if (product.imageUrl != null)
                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(8.0),
                                       child: Image.asset(
                                         product.imageUrl!,
                                         height: 150,
                                         fit: BoxFit.cover,
                                         errorBuilder: (context, error, stackTrace) {
                                           return Container(
                                             height: 150,
                                             color: Colors.grey[300],
                                             child: const Icon(Icons.image, color: Colors.grey, size: 50),
                                           );
                                         },
                                       ),
                                     ),
                                   const SizedBox(height: 16),
                                   Text('Harga: Rp ${product.price.toStringAsFixed(0)}'),
                                   Text('Stok: ${product.stock}'),
                                   if (product.description != null) ...[
                                     const SizedBox(height: 8),
                                     Text(product.description!),
                                   ],
                                 ],
                               ),
                               actions: [
                                 TextButton(
                                   onPressed: () => Navigator.pop(context),
                                   child: const Text('Tutup'),
                                 ),
                                 ElevatedButton(
                                   onPressed: () {
                                     Navigator.pop(context);
                                     context.read<CartProvider>().addItem(product);
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(content: Text('${product.name} ditambahkan ke keranjang')),
                                     );
                                   },
                                   child: const Text('Tambah ke Keranjang'),
                                 ),
                               ],
                             ),
                           );
                         },
                       ),
                     );
                   },
                 ),
               ),
    );
  }
}