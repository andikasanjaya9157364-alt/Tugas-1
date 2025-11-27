import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/transaction.dart' as my_transaction;
import '../models/cart_item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Products
  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).set(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  // Transactions
  Future<void> addTransaction(my_transaction.Transaction transaction) async {
    await _firestore.collection('transactions').doc(transaction.id).set(transaction.toMap());
  }

  Future<List<my_transaction.Transaction>> getTransactions() async {
    QuerySnapshot snapshot = await _firestore.collection('transactions').orderBy('date', descending: true).get();
    List<my_transaction.Transaction> transactions = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // For simplicity, we'll assume products are fetched separately
      // In a real app, you might store product details in transaction or fetch them
      List<CartItem> items = []; // Placeholder
      transactions.add(my_transaction.Transaction.fromMap(data, items));
    }
    return transactions;
  }
}