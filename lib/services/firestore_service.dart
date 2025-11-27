import '../models/product.dart';
import '../models/transaction.dart' as my_transaction;
import '../models/cart_item.dart';

class FirestoreService {
  // In-memory storage for demo purposes
  static final List<Product> _products = [];
  static final List<my_transaction.Transaction> _transactions = [];

  // Products
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_products);
  }

  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _products.add(product);
  }

  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    }
  }

  Future<void> deleteProduct(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _products.removeWhere((p) => p.id == productId);
  }

  // Transactions
  Future<void> addTransaction(my_transaction.Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _transactions.add(transaction);
  }

  Future<List<my_transaction.Transaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // For demo purposes, return transactions with their items
    return List.from(_transactions)..sort((a, b) => b.date.compareTo(a.date));
  }

  // Add some sample data
  Future<void> initializeSampleData() async {
    if (_products.isEmpty) {
      _products.addAll([
        Product(
          id: '1',
          name: 'Nasi Goreng',
          price: 15000,
          description: 'Nasi goreng spesial dengan telur dan ayam',
          imageUrl: 'assets/images/nasi_goreng.jpg',
          stock: 50,
        ),
        Product(
          id: '2',
          name: 'Ayam Bakar',
          price: 20000,
          description: 'Ayam bakar madu dengan sambal',
          imageUrl: 'assets/images/ayam_bakar.jpg',
          stock: 30,
        ),
        Product(
          id: '3',
          name: 'Es Teh Manis',
          price: 5000,
          description: 'Es teh manis dingin',
          imageUrl: 'assets/images/es_teh.jpg',
          stock: 100,
        ),
        Product(
          id: '4',
          name: 'Bakso',
          price: 12000,
          description: 'Bakso urat dengan mie',
          imageUrl: 'assets/images/bakso.jpg',
          stock: 40,
        ),
        Product(
          id: '5',
          name: 'Jus Jeruk',
          price: 8000,
          description: 'Jus jeruk segar',
          imageUrl: 'assets/images/jus_jeruk.jpg',
          stock: 60,
        ),
      ]);
    }
  }
}