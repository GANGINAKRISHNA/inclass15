import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/firestore_service.dart';
import 'add_edit_item_screen.dart';

class InventoryHomePage extends StatelessWidget {
  const InventoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory Home")),
      body: StreamBuilder<List<Item>>(
        stream: FirestoreService().getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading items"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No inventory items yet"));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text("Qty: ${item.quantity}   |   \$${item.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => FirestoreService().deleteItem(item.id!),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditItemScreen(item: item),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditItemScreen()),
        ),
      ),
    );
  }
}
