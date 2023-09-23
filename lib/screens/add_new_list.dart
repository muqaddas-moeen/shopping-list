import 'package:flutter/material.dart';
import 'package:shopping_list/data/list.dart';
import 'package:shopping_list/main.dart';
import 'package:shopping_list/models/list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewList extends StatefulWidget {
  AddNewList({super.key, required this.id});
  String id;

  @override
  State<AddNewList> createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  final _form = GlobalKey<FormState>();
  var title = '';
  var detail = '';
  List<ListModel> list = [];
  var isSending = false;

  void validate() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        isSending = true;
      });

      final url = Uri.https('shopping-list-43315-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(url,
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({'title': title, 'detail': detail}));

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
          ListModel(id: responseData['name'], title: title, detail: detail));

      print('The response data = ${responseData}');

      //print(detail);
    }
  }

  String titleFound = '';

  @override
  Widget build(BuildContext context) {
    if (availableItem.contains(widget.id)) {
      titleFound = availableItem.first.title;
      print(titleFound);
    }

    return Scaffold(
      // backgroundColor: ThemeData(theme.),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10, left: 25.0, right: 25.0, bottom: 30.0),
        child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Add Shopping Item Here'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: (widget.id != null || widget.id.isNotEmpty)
                      ? titleFound
                      : title,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('List Title'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length <= 1 ||
                        value.length > 50) {
                      return 'This field cannot be null.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                TextFormField(
                  initialValue: detail,
                  decoration: const InputDecoration(
                    label: Text('Detail'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 1) {
                      return 'This field cannot be null';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    detail = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: isSending
                            ? null
                            : () {
                                _form.currentState!.reset();
                              },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: isSending
                            ? null
                            : () {
                                validate();
                              },
                        child: isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Save Note')),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
