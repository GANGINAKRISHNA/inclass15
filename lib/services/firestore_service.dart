import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<void> addItem(Item item) async {
    await itemsCollection.add(item.toMap());
  }

  Stream<List<Item>> getItemsStream() {
    return itemsCollection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Item.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  Future<void> updateItem(Item item) async {
    await itemsCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await itemsCollection.doc(itemId).delete();
  }
}
