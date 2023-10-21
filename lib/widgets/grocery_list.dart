import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/Data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  var groceryItems = <GroceryItem>[];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _displayGroceries();
  }

  void _displayGroceries() async {
    try {
      final url = Uri.https(
          "firststeps-9d8d1-default-rtdb.firebaseio.com", "shoping-list.json");
      final response = await http.get(url);

      final Map<String, dynamic> mappedData =
          json.decode(response.body) ?? <String, dynamic>{};
      final List<GroceryItem> loadedItems = [];
      for (final item in mappedData.entries) {
        final category = categories.entries
            .firstWhere(
                (element) => element.value.title == item.value["category"])
            .value;
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category));
      }

      setState(() {
        groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Something critical has occured..try later!";
      });
    }
  }

  void _toAddScreen() async {
    final newItem = await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      groceryItems.add(newItem);
    });
  }

  void _deleteItem(int index) async {
    final saveItem = groceryItems[index];
    final url = Uri.https("firststeps-9d8d1-default-rtdb.firebaseio.com",
        "shoping-list/${groceryItems[index].id}.json");
    setState(() {
      groceryItems.removeAt(index);
    });

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Deleting can not be complete, something went wrong",
      )));
      setState(() {
        groceryItems.insert(index, saveItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text(
      "No items yet",
      style: TextStyle(color: Colors.white, fontSize: 16),
    ));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(groceryItems[index]),
              onDismissed: (direction) => _deleteItem(index),
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                title: Text(
                  groceryItems[index].name,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration:
                      BoxDecoration(color: groceryItems[index].category.color),
                ),
                trailing: Text(
                  "${groceryItems[index].quantity}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          });
    }

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Groceries",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => _toAddScreen(), icon: const Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}
