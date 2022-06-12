import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:reading_list/models/book_layout.dart';
import 'package:reading_list/utilities/alertbox_actions.dart';
import 'package:reading_list/utilities/widgets.dart';
import 'package:reading_list/utilities/constants.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({Key? key}) : super(key: key);

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {

  //collection reference
  final _collectionReference = FirebaseFirestore.instance.collection('books');
  final _favouritesCollectionReference = FirebaseFirestore.instance.collection('favourites');
  final _completedCollectionReference = FirebaseFirestore.instance.collection('completed');

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reading List'),
          centerTitle: true,
        ),

        //read from firebase
        body: StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.orderBy('title').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

            //error
            if (snapshot.hasError || !snapshot.hasData){
              return firebaseStreamHasErrorMessage();
            }

            //filled list
            else{
              List<BookCard> _books = [];

              for (var snpsht in snapshot.data!.docs){
                _books.add(BookCard(
                  title: snpsht.get('title'),
                  published: snpsht.get('published'),
                  plot: snpsht.get('plot'),
                  genre: snpsht.get('genre'),
                  author: snpsht.get('author'),
                  image: snpsht.get('image'),
                ),);
              }

              return _books.isEmpty ?

              kFirebaseStreamNoDataMessage //empty list
                  :
              GridView.builder(
                gridDelegate: kBookGridLayout,
                itemCount: _books.length,
                itemBuilder: (context, index){

                  return GestureDetector(
                    child: _books[index],

                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text(
                              _books[index].title,
                              textAlign: TextAlign.center,
                            ),

                            content: Text(
                              _books[index].plot,
                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w300,
                              ),
                            ),

                            actions: [
                              //remove books
                              RemoveBook(
                                snapshot: snapshot,
                                index: index,
                              ),

                              //add to favourites
                              AddToFavourites(
                                collectionReference: _favouritesCollectionReference,
                                snapshot: snapshot,
                                index: index,
                              ),

                              //send to completed
                              SendToCompleted(
                                collectionReference: _completedCollectionReference,
                                snapshot: snapshot,
                                index: index,
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.02,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
