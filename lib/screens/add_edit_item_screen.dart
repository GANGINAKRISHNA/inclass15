import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController qtyCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController categoryCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.item?.name ?? "");
    qtyCtrl = TextEditingController(text: widget.item?.quantity.toString() ?? "");
    priceCtrl = TextEditingController(text: widget.item?.price.toString() ?? "");
    categoryCtrl = TextEditingController(text: widget.item?.category ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? "Add Item" : "Edit Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Item Name")),
              TextFormField(controller: qtyCtrl, decoration: const InputDecoration(labelText: "Quantity")),
              TextFormField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Price")),
              TextFormField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category")),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  final item = Item(
                    id: widget.item?.id,
                    name: nameCtrl.text,
                    quantity: int.parse(qtyCtrl.text),
                    price: double.parse(priceCtrl.text),
                    category: categoryCtrl.text,
                    createdAt: DateTime.now(),
                  );

                  widget.item == null
                      ? FirestoreService().addItem(item)
                      : FirestoreService().updateItem(item);

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),

              if (widget.item != null)
                TextButton(
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    FirestoreService().deleteItem(widget.item!.id!);
                    Navigator.pop(context);
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
