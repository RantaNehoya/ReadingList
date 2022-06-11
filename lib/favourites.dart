import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final _favouritesCollectionReference = FirebaseFirestore.instance.collection('favourites');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          centerTitle: true,
        ),

        body: StreamBuilder<Object>(
          stream: _favouritesCollectionReference.snapshots(),
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: const <Widget>[
                Center(
                  child: Text("Hmm... there seems to be nothing here"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
