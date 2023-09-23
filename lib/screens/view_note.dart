import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/list_model.dart';
import 'dart:convert';

class ViewNote extends StatefulWidget {
  ViewNote({super.key, required this.id});
  String id;

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  var _error;
  String titleRecieved = '';
  String detailRecieved = '';

  void loadItems() async {
    final url = Uri.https('shopping-list-43315-default-rtdb.firebaseio.com',
        'shopping-list.json');
    print('note receive = ${widget.id}');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'There is some problem fetching data. Please try again';
        });
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      for (final list in listData.entries) {
        if (widget.id == list.key) {
          setState(() {
            titleRecieved = list.value['title'];
            detailRecieved = list.value['detail'];
          });
          break;
        }
      }

      print('note receive = ${listData}');
      print('title = ${titleRecieved}');
      print('detail = ${detailRecieved}');
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      loadItems();
    });
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            Text(
              titleRecieved,
              style: const TextStyle(fontSize: 30, color: Colors.deepPurple),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Description',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            Text(
              detailRecieved,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
