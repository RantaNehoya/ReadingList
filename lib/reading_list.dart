import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

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
  final _collectionReference = FirebaseFirestore.instance.collection("books");

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
  Stream<List<BookCard>> _read(){
    return _collectionReference.snapshots().map((snapshot) => //iterate over snapshot documents and convert to BookCard object
    snapshot.docs.map((doc) =>
        BookCard.fromJson(doc.data())
    ).toList()
    );
  }

  // _displayDialog({required BuildContext context, required List book, required int index}) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context){
  //         //TODO: POP ALERTDIALOG
  //         return
  //       }
  //   );
  // }

  // void _read (){
  //   _collectionReference.snapshots().map((book) => null)
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        //read from firebase
        body: StreamBuilder<List<BookCard>>(
          stream: _read(),
          builder: (context, snapshot){

            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
              );
            }

            if (snapshot.hasError){
              return const Center(
                child: Text("Oh no! Something went wrong..."),
              );
            }
            else{
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
                            showDialog(
                              context: context,
                              builder: (context){
                                return DisplayDialog(
                                  book: _book,
                                  index: index,
                                  collectionReference: _collectionReference,

                                  image: _image,
                                  author: _author,
                                  published: _published,
                                  title: _title,
                                  genre: _genre,
                                  plot: _plot,

                                  titleFocusNode: _titleFocusNode,
                                  authorFocusNode: _authorFocusNode,
                                  publishedFocusNode: _publishedFocusNode,
                                  genreFocusNode: _genreFocusNode,
                                  plotFocusNode: _plotFocusNode,
                                );
                              },
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
          },
        ),
      ),
    );
  }
}

class DisplayDialog extends StatelessWidget {

  final List book;
  final int index;
  final CollectionReference collectionReference;

  //user input
  final TextEditingController image;
  final TextEditingController author;
  final TextEditingController published;
  final TextEditingController title;
  final TextEditingController genre;
  final TextEditingController plot;

  final FocusNode titleFocusNode;
  final FocusNode authorFocusNode;
  final FocusNode publishedFocusNode;
  final FocusNode genreFocusNode;
  final FocusNode plotFocusNode;

  const DisplayDialog({
    Key? key,
    required this.book,
    required this.index,
    required this.collectionReference,

    required this.image,
    required this.author,
    required this.published,
    required this.title,
    required this.genre,
    required this.plot,

    required this.titleFocusNode,
    required this.authorFocusNode,
    required this.publishedFocusNode,
    required this.genreFocusNode,
    required this.plotFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        book[index].title,
        textAlign: TextAlign.center,
      ),
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

        //todo: pop dialog
        //edit/update books
        kBookOptions(
          ctx: context,
          text: "Edit",
          function: () async {

            final documentID = await getDocumentID(index);
            final bookDoc = collectionReference.doc(documentID);

            published.text = await collectionReference.doc(documentID).get().then((value) => value['published']);
            plot.text = await collectionReference.doc(documentID).get().then((value) => value['plot']);
            genre.text = await collectionReference.doc(documentID).get().then((value) => value['genre']);
            author.text = await collectionReference.doc(documentID).get().then((value) => value['author']);
            title.text = await collectionReference.doc(documentID).get().then((value) => value['title']);
            image.text = "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY";

            bottomsheet(
              ctx: context,
              image: image,
              author: author,
              authorFocusNode: authorFocusNode,
              genre: genre,
              genreFocusNode: genreFocusNode,
              plot: plot,
              plotFocusNode: plotFocusNode,
              published: published,
              publishedFocusNode: publishedFocusNode,
              title: title,
              titleFocusNode: titleFocusNode,

              function: () {
                bookDoc.update({
                  'published': published.text,

                  'plot': plot.text,

                  'genre': genre.text,

                  'author': author.text,

                  'title': title.text,

                  'image': image.text = (image.text.isEmpty) ? "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY" : image.text,
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Book successfully updated'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
        ),

        //remove books
        kBookOptions(
          ctx: context,
          text: "Remove",

          function: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: const Text(
                    'Are you sure you want to delete this book from your list?\nThis action cannot be undone.',
                    textAlign: TextAlign.center,
                  ),

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
                          child: const Text('Yes'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),

        //add to favourites button
        kBookOptions(
          ctx: context,
          text: 'Add to Favourites',
          function: () {
            //TODO: FAVOURITES FUNCTION
            //TODO: pop dialog
          },
        ),

        //completed books
        kBookOptions(
          ctx: context,
          text: 'Send to Completed',
          function: () {
            //TODO: SEND TO FUNCTION
            //TODO: pop dialog
          },
        ),
      ],
    );
  }
}
