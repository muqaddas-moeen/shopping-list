import 'package:flutter/material.dart';
import 'package:shopping_list/data/list.dart';
import 'package:shopping_list/models/list_model.dart';
import 'package:shopping_list/screens/add_new_list.dart';
import 'package:shopping_list/widgets/add_new_list_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingListScreen extends StatefulWidget {
  ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ListModel> listOfShopping = [];
  bool content = false;
  var isLoading = true;
  var _error;

  void loadItems() async {
    final url = Uri.https('shopping-list-43315-default-rtdb.firebaseio.com',
        'shopping-list.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'There is some problem fetching data. Please try again';
        });
      }

      if (response.body == 'null') {
        isLoading = false;
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<ListModel> loadedItems = [];
      for (final list in listData.entries) {
        loadedItems.add(ListModel(
            id: list.key,
            title: list.value['title'],
            detail: list.value['detail']));
      }

      setState(() {
        listOfShopping = loadedItems;
        isLoading = false;
      });

      print(response.body);
      print(listOfShopping[0].title);
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void addNewList() async {
    final newNote = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddNewList(
              id: '',
            )));

    print('The response data = $newNote');
    if (newNote == null) {
      return;
    }
    setState(() {
      listOfShopping.add(newNote);
    });
  }

  void removeItem(ListModel item) async {
    final index = listOfShopping.indexOf(item);

    setState(() {
      listOfShopping.remove(item);
    });

    final url = Uri.https('shopping-list-43315-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      listOfShopping.insert(index, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text(
      'No list added now',
      style: TextStyle(fontSize: 15, color: Colors.grey),
    ));

    if (listOfShopping.isNotEmpty) {
      content = ListView.builder(
        itemCount: listOfShopping.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            removeItem(listOfShopping[index]);
            // setState(() {
            //   listOfShopping.removeAt(index);
            // });
          },
          key: Key(listOfShopping[index].id),
          child: ListItem(
            title: listOfShopping[index].title,
            id: listOfShopping[index].id,
          ),
        ),
      );
    }

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      content = const Center(
          child: Text(
        'There is some problem in the server. Please try again later',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: addNewList, child: const Text('Add New Note')),
            const SizedBox(
              height: 30,
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Notes here...',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
