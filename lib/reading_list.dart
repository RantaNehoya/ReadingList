import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/widgets.dart';
import 'package:reading_list/books.dart';
import 'package:reading_list/utilities.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({Key? key}) : super(key: key);

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {

  //collection reference
  final collectionReference = FirebaseFirestore.instance.collection("books");

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

  //reference firebase collection "books"
  Stream<List<BookCard>> _read() => collectionReference.snapshots().map((snapshot) => //iterate over snapshot documents and convert to BookCard object
  snapshot.docs.map((doc) => BookCard.fromJson(doc.data())).toList());

  _displayDialog({required BuildContext context, required List book, required int index}) async {
    return showDialog(
        context: context,
        builder: (context){
          //TODO: POP ALERTDIALOG
          return AlertDialog(
            content: Text(
              book[index].plot,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: [
              kBookOptions(
                ctx: context,
                text: "Edit",
                function: () async {

                  final documentID = await getDocumentID(index);

                  final bookDoc = collectionReference.doc(documentID);

                  _published.text = await collectionReference.doc(documentID).get().then((value) => value.data()!["published"]);

                  _plot.text = await collectionReference.doc(documentID).get().then((value) => value.data()!["plot"]);

                  _genre.text = await collectionReference.doc(documentID).get().then((value) => value.data()!["genre"]);

                  _author.text = await collectionReference.doc(documentID).get().then((value) => value.data()!["author"]);

                  _title.text = await collectionReference.doc(documentID).get().then((value) => value.data()!["title"]);

                  _image.text = "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY";

                  bottomsheet(
                    ctx: context,
                    image: _image,
                    author: _author,
                    authorFocusNode: _authorFocusNode,
                    genre: _genre,
                    genreFocusNode: _genreFocusNode,
                    plot: _plot,
                    plotFocusNode: _plotFocusNode,
                    published: _published,
                    publishedFocusNode: _publishedFocusNode,
                    title: _title,
                    titleFocusNode: _titleFocusNode,

                    function: () {
                      bookDoc.update({
                        "published": _published.text,

                        "plot": _plot.text,

                        "genre": _genre.text,

                        "author": _author.text,

                        "title": _title.text,

                        "image": _image.text = (_image.text.isEmpty) ? "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY" : _image.text,
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),

              kBookOptions(
                ctx: context,
                text: "Remove",
                function: () {
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        content: const Text("Are you sure you want to delete this book from your list?\nThis action cannot be undone."),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  final documentID = await getDocumentID(index);
                                  final bookDoc = collectionReference.doc(documentID);

                                  bookDoc.delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes"),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              kBookOptions(
                ctx: context,
                text: "Add to Favourites",
                function: () {
                  //TODO: FAVOURITES FUNCTION
                },
              ),
              kBookOptions(
                ctx: context,
                text: "Send to Completed",
                function: () {
                  //TODO: SEND TO FUNCTION
                },
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        //read from firebase
        body: StreamBuilder<List<BookCard>>(
          stream: _read(),
          builder: (context, snapshot){

            if (snapshot.hasData){
              final _book = snapshot.data!;

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
                            _displayDialog(
                              context: context,
                              book: _book,
                              index: index,
                            );
                          },

                          child: _book[index],
                        );
                      },

                      itemCount: _book.length,
                    ),
                  ),
                ],
              );
            }

            else if (snapshot.hasError){
              return const Text("Oh no! Something went wrong...");
            }

            else {
              return const CircularProgressIndicator(
                strokeWidth: 3.0,
              );
            }
          },
        ),
      ),
    );
  }
}