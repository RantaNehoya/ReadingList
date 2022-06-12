import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/utilities/utilities.dart';

class AddBook extends StatelessWidget {
  AddBook({Key? key}) : super(key: key);

  //collection reference
  final _collectionReference = FirebaseFirestore.instance.collection('books');

  @override
  Widget build(BuildContext context) {
    return BottomsheetMenu(
      collection: _collectionReference,
      message: 'Book successfully added',
    );
  }
}
