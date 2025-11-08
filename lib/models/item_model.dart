import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String? id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final DateTime createdAt;

  Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  /// Convert Item → Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "quantity": quantity,
      "price": price,
      "category": category,
      "createdAt": createdAt,
    };
  }

  /// Convert Firestore → Item
  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      id: id,
      name: map["name"],
      quantity: map["quantity"],
      price: map["price"].toDouble(),
      category: map["category"],
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }
}
