import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final _groceryItems = <GroceryItem>[];

  void _toAddScreen() async {
    final newItem = await Navigator.push<GroceryItem>(
        context, MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _deleteItem(int index) {
    final saveInfo = _groceryItems[index];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Item ${_groceryItems[index].name} was deleted"),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Cancel",
          onPressed: () {
            setState(() {
              _groceryItems.insert(index, saveInfo);
            });
          }),
    ));

    setState(() {
      _groceryItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
   Widget content = const Center(); 

   if(!_groceryItems.isEmpty){
    content =  ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(_groceryItems[index]),
              onDismissed: (direction) => _deleteItem(index),
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                title: Text(
                  _groceryItems[index].name,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration:
                      BoxDecoration(color: _groceryItems[index].category.color),
                ),
                trailing: Text(
                  "${_groceryItems[index].quantity}",
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
