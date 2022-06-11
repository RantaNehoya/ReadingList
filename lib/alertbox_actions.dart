import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:reading_list/widgets.dart';
import 'package:reading_list/utilities.dart';
import 'package:reading_list/books.dart';

//remove books
class RemoveBook extends StatelessWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final List<BookCard> bookList;
  final int index;

  const RemoveBook({
    Key? key,
    required this.snapshot,
    required this.bookList,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Remove',
      ctx: context,
      function: () async {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context){
            return AlertBox( //yes option
              function: (){

                snapshot.data!.docs[index].reference.delete();
                bookList.removeAt(index);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  floatingSnackBar('Book successfully deleted'),
                );
              },
            );
          },
        );
      },
    );
  }
}
