import 'package:flutter/material.dart';
import 'package:shopping_list/screens/view_note.dart';

class ListItem extends StatelessWidget {
  ListItem({
    super.key,
    required this.title,
    required this.id,
  });
  String title;
  String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(
                  id: id,
                )));
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 2.5,
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
            child: Text(title!)),
      ),
    );
  }
}
