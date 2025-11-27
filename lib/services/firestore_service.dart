import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/transaction.dart' as my_transaction;
import '../models/cart_item.dart';

class FirestoreService {
  FirebaseFirestore? _firestore;
  bool _useFirebase = false;

  // In-memory storage for fallback
  static final List<Product> _products = [];
  static final List<my_transaction.Transaction> _transactions = [];

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      if (Firebase.apps.isEmpty) {
        // Firebase not initialized, skip
        _useFirebase = false;
        return;
      }
      _firestore = FirebaseFirestore.instance;
      _useFirebase = true;
    } catch (e) {
      print('Firebase not available, using in-memory storage: $e');
      _useFirebase = false;
    }
  }

  // Collection references
  CollectionReference? get _productsCollection => _useFirebase ? _firestore?.collection('products') : null;
  CollectionReference? get _transactionsCollection => _useFirebase ? _firestore?.collection('transactions') : null;

  // Products
  Future<List<Product>> getProducts() async {
    if (_useFirebase && _productsCollection != null) {
      try {
        final snapshot = await _productsCollection!.get();
        return snapshot.docs.map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>)).toList();
      } catch (e) {
        print('Error getting products from Firebase, falling back to in-memory: $e');
        return List.from(_products);
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 100));
      return List.from(_products);
    }
  }

  Future<void> addProduct(Product product) async {
    if (_useFirebase && _productsCollection != null) {
      try {
        await _productsCollection!.doc(product.id).set(product.toMap());
      } catch (e) {
        print('Error adding product to Firebase, falling back to in-memory: $e');
        _products.add(product);
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 50));
      _products.add(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    if (_useFirebase && _productsCollection != null) {
      try {
        await _productsCollection!.doc(product.id).update(product.toMap());
      } catch (e) {
        print('Error updating product in Firebase, falling back to in-memory: $e');
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index >= 0) {
          _products[index] = product;
        }
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 50));
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index >= 0) {
        _products[index] = product;
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    if (_useFirebase && _productsCollection != null) {
      try {
        await _productsCollection!.doc(productId).delete();
      } catch (e) {
        print('Error deleting product from Firebase, falling back to in-memory: $e');
        _products.removeWhere((p) => p.id == productId);
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 50));
      _products.removeWhere((p) => p.id == productId);
    }
  }

  // Transactions
  Future<void> addTransaction(my_transaction.Transaction transaction) async {
    if (_useFirebase && _transactionsCollection != null) {
      try {
        await _transactionsCollection!.doc(transaction.id).set(transaction.toMap());
      } catch (e) {
        print('Error adding transaction to Firebase, falling back to in-memory: $e');
        _transactions.add(transaction);
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 50));
      _transactions.add(transaction);
    }
  }

  Future<List<my_transaction.Transaction>> getTransactions() async {
    if (_useFirebase && _transactionsCollection != null) {
      try {
        final snapshot = await _transactionsCollection!.get();
        final transactions = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final items = (data['items'] as List<dynamic>? ?? [])
              .map((item) => CartItem.fromMap(item as Map<String, dynamic>, Product.fromMap(item['product'] as Map<String, dynamic>)))
              .toList();
          return my_transaction.Transaction.fromMap(data, items);
        }).toList();

        // Sort by date (newest first)
        transactions.sort((a, b) => b.date.compareTo(a.date));
        return transactions;
      } catch (e) {
        print('Error getting transactions from Firebase, falling back to in-memory: $e');
        return List.from(_transactions)..sort((a, b) => b.date.compareTo(a.date));
      }
    } else {
      // Fallback to in-memory storage
      await Future.delayed(const Duration(milliseconds: 100));
      return List.from(_transactions)..sort((a, b) => b.date.compareTo(a.date));
    }
  }

  // Add some sample data
  Future<void> initializeSampleData() async {
    try {
      // Check if products already exist
      final existingProducts = await getProducts();
      if (existingProducts.isEmpty) {
        final sampleProducts = [
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
        ];

        // Add all products
        for (final product in sampleProducts) {
          await addProduct(product);
        }
      }
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}