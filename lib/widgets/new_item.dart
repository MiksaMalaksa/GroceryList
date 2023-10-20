import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  int quantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;

  void _onSubmitted() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: name,
          quantity: quantity,
          category: selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Your Groceries",
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text("Name")),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return "Name must be grater than 1 character";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    name = newValue!;
                  },
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number,
                      initialValue: quantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Quantity must be grater than 0";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        quantity = int.tryParse(newValue!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Choose category!";
                          }
                          return null;
                        },
                        value: selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.value.title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))
                        ],
                        onChanged: ((value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        })),
                  )
                ]),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text("Reset")),
                    ElevatedButton(
                        onPressed: _onSubmitted, child: const Text("Submit"))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
