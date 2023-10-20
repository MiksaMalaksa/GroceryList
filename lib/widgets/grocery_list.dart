import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/Data/categories.dart';
import 'package:shopping_list/models/category.dart';
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

  @override
  void initState() {
    super.initState();
    _displayGroceries();
  }

  void _displayGroceries() async {
    final url = Uri.https(
        "firststeps-9d8d1-default-rtdb.firebaseio.com", "shoping-list.json");
    final response = await http.get(url);
    final Map<String, dynamic> mappedData =
        json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in mappedData.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value["category"])
          .value;
      _loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category));
    }

    setState(() {
      groceryItems = _loadedItems;
    });
  }

  void _toAddScreen() async {
    await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));
    _displayGroceries();
  }

  void _deleteItem(int index) {
    final saveInfo = groceryItems[index];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Item ${groceryItems[index].name} was deleted"),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Cancel",
          onPressed: () {
            setState(() {
              groceryItems.insert(index, saveInfo);
            });
          }),
    ));

    setState(() {
      groceryItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center();

    if (!groceryItems.isEmpty) {
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
