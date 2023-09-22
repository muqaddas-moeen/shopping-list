import 'package:flutter/material.dart';
import 'package:shopping_list/data/list.dart';
import 'package:shopping_list/screens/add_new_list.dart';
import 'package:shopping_list/widgets/add_new_list_widget.dart';

class ShoppingListScreen extends StatelessWidget {
  ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool content = false;

    if (availableItem.isNotEmpty) {
      content = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddNewList(
                            id: '',
                          )));
                },
                child: const Text('Add New List')),
            const SizedBox(
              height: 30,
            ),
            if (content)
              for (final item in availableItem)
                ListItem(
                  title: item.title,
                  id: item.id,
                ),
            if (!content)
              const Center(
                  child: Text(
                'No list added now',
                style: TextStyle(fontSize: 20),
              ))
          ],
        ),
      ),
    );
  }
}
