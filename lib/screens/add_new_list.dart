import 'package:flutter/material.dart';
import 'package:shopping_list/data/list.dart';
import 'package:shopping_list/main.dart';
import 'package:shopping_list/models/list_model.dart';

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

  void validate() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      print(title);
      print(detail);
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
                        onPressed: () {
                          _form.currentState!.reset();
                        },
                        child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: () {
                          validate();
                        },
                        child: const Text('Save List')),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
