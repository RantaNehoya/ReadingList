import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/utilities/widgets.dart';
import 'package:reading_list/utilities/utilities.dart';

//remove books
class RemoveBook extends StatelessWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  const RemoveBook({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Remove',
      ctx: context,
      function: (){
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context){
            return AlertBox( //yes option
              function: (){

                snapshot.data!.docs[index].reference.delete();
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

//add to favourites
class AddToFavourites extends StatelessWidget {

  final CollectionReference collectionReference;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  const AddToFavourites({
    Key? key,
    required this.snapshot,
    required this.collectionReference,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Add to Favourites',
      ctx: context,

      function: (){
        QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

        //TODO: DUPLICATES
        collectionReference.add({
          'image': snapshotData.get('image'),
          'title': snapshotData.get('title'),
          'author': snapshotData.get('author'),
          'genre': snapshotData.get('genre'),
          'plot': snapshotData.get('plot'),
          'published': snapshotData.get('published'),
        });

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            '${snapshotData.get('title')} successfully added to favorites',
          ),
        );
      },
    );
  }
}

//send to completed
class SendToCompleted extends StatelessWidget {

  final CollectionReference collectionReference;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  const SendToCompleted({
    Key? key,
    required this.snapshot,
    required this.collectionReference,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookOption(
      action: 'Send to Completed',
      ctx: context,

      function: (){
        QueryDocumentSnapshot snapshotData = snapshot.data!.docs[index];

        //add to completed list
        collectionReference.add({
          'image': snapshotData.get('image'),
          'title': snapshotData.get('title'),
          'author': snapshotData.get('author'),
          'genre': snapshotData.get('genre'),
          'plot': snapshotData.get('plot'),
          'published': snapshotData.get('published'),
        });

        //delete book from reading list
        snapshotData.reference.delete();

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            '${snapshotData.get('title')} successfully completed',
          ),
        );
      },
    );
  }
}