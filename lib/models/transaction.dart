import 'cart_item.dart';

class Transaction {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String paymentMethod;

  Transaction({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, List<CartItem> items) {
    return Transaction(
      id: map['id'],
      items: items,
      total: map['total'],
      date: DateTime.parse(map['date']),
      paymentMethod: map['paymentMethod'],
    );
  }
}