import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:reading_list/widgets.dart';
import 'package:reading_list/books.dart';
import 'package:reading_list/utilities.dart';
import 'alertbox_actions.dart';
import 'completed_books.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({Key? key}) : super(key: key);

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {

  //hud progress bool
  bool _isLoading = false;

  //collection reference
  final _collectionReference = FirebaseFirestore.instance.collection('books');
  final _favouritesCollectionReference = FirebaseFirestore.instance.collection('favourites');
  // final _completedCollectionReference = FirebaseFirestore.instance.collection('completed');

  //user input
  final TextEditingController _image = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _published = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _genre = TextEditingController();
  final TextEditingController _plot = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _authorFocusNode = FocusNode();
  final FocusNode _publishedFocusNode = FocusNode();
  final FocusNode _genreFocusNode = FocusNode();
  final FocusNode _plotFocusNode = FocusNode();

  @override
  void dispose(){ //dispose of focus nodes
    _titleFocusNode.dispose();
    _authorFocusNode.dispose();
    _publishedFocusNode.dispose();
    _genreFocusNode.dispose();
    _plotFocusNode.dispose();
    super.dispose();
  }

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
            if (snapshot.hasError){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Text(
                      'There seems to be a problem',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              );
            }

            //empty list
            if (!snapshot.hasData){
              return const Text("Hmm... there seems to be nothing here");
            }

            //filled list
            else{
              List<BookCard> _books = [];

              for (var snpsht in snapshot.data!.docs){
                _books.add(BookCard(
                  id: snpsht.id,
                  title: snpsht.get('title'),
                  published: snpsht.get('published'),
                  plot: snpsht.get('plot'),
                  genre: snpsht.get('genre'),
                  author: snpsht.get('author'),
                  image: snpsht.get('image'),
                ),);
              }

              return Stack(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3/4.6,
                      ),

                      itemBuilder: (context, index){
                        return GestureDetector(
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
                                      bookList: _books,
                                    ),

                                    // TODO: add to favourites button
                                    ModalProgressHUD(
                                      inAsyncCall: _isLoading,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),

                                        child: Center(
                                          child: OutlinedButton(

                                            child: const Text(
                                              'Add to Favourites',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                            ),

                                            style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all(Colors.black),

                                              padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                  vertical: MediaQuery.of(context).size.height * 0.015,
                                                  horizontal: 40.0,
                                                ),
                                              ),
                                            ),

                                            onPressed: () async {
                                              setState((){
                                                _isLoading = true;
                                              });
                                              //TODO: ADD TO FAVS FIREBASE
                                              snapshot.data!.docs[index].reference.delete();
                                              _books.removeAt(index);
                                              setState((){
                                                _isLoading = false;
                                              });
                                              //TODO: ADDED SNACKBAR
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    // TODO: SEND TO FUNCTION
                                    ModalProgressHUD(
                                      inAsyncCall: _isLoading,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),

                                        child: Center(
                                          child: OutlinedButton(

                                            child: const Text(
                                              'Send to Completed',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                            ),

                                            style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all(Colors.black),

                                              padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                  vertical: MediaQuery.of(context).size.height * 0.015,
                                                  horizontal: 40.0,
                                                ),
                                              ),
                                            ),

                                            onPressed: () async {
                                              setState((){
                                                _isLoading = true;
                                              });
                                              //TODO: ADD TO COMPLETED FIREBASE
                                              snapshot.data!.docs[index].reference.delete();
                                              _books.removeAt(index);
                                              setState((){
                                                _isLoading = false;
                                              });
                                              //TODO: SENT SNACKBAR
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    //TODO: SIZEDBOX
                                  ],
                                );
                              },
                            );
                          },

                          child: _books[index],
                        );
                      },

                      itemCount: _books.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
