import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/reading_list.dart';
import 'package:reading_list/settings.dart';
import 'package:reading_list/widgets.dart';
import 'package:reading_list/books.dart';
import 'package:reading_list/completed_list.dart';
import 'package:reading_list/favourites.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ReadingList',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),

        home: const Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  //page navigation
  final List<Widget> _pages = const [
    ReadingList(),
    CompletedList(),
    Favourites(),
    AppSettings(),
  ];
  int _index = 0;
  void _onTapped (int index){
    setState(() {
      _index = index;
    });
  }

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

  //upload to firebase
  Future createBook (BookCard newBook) async {

    //create new doc
    return FirebaseFirestore.instance.collection("books")
        .add({
      "image" : newBook.image,
      "title" : newBook.title,
      "author" : newBook.author,
      "published" : newBook.published,
      "genre" : newBook.genre,
      "plot" : newBook.plot,

    })
        .then((value) => print("BOOK ADDED"))
        .catchError((error) => print("CAUGHT ERROR: $error"));
  }

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
          ),
          onPressed: (){
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              builder: (context){
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      //TODO: VALIDATION
                      Form(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[

                              kUserInput(
                                text: "Image Url",
                                controller: _image,
                                function: (_){
                                  FocusScope.of(context).requestFocus(_titleFocusNode);
                                },
                              ),

                              kUserInput(
                                text: "Title",
                                controller: _title,
                                focusNode: _titleFocusNode,
                                function: (_){
                                  FocusScope.of(context).requestFocus(_authorFocusNode);
                                },
                              ),

                              kUserInput(
                                text: "Author",
                                controller: _author,
                                focusNode: _authorFocusNode,
                                function: (_){
                                  FocusScope.of(context).requestFocus(_publishedFocusNode);
                                },
                              ),

                              kUserInput(
                                text: "Publish Date",
                                controller: _published,
                                focusNode: _publishedFocusNode,
                                function: (_){
                                  FocusScope.of(context).requestFocus(_genreFocusNode);
                                },
                              ),kUserInput(
                                text: "Genre",
                                controller: _genre,
                                focusNode: _genreFocusNode,
                                function: (_){
                                  FocusScope.of(context).requestFocus(_plotFocusNode);
                                },
                              ),kUserInput(
                                text: "Plot",
                                controller: _plot,
                                focusNode: _plotFocusNode,
                                function: null,
                              ),

                            ],
                          ),
                        ),
                      ),

                      bookOptions(
                        text: "Save",
                        ctx: context,
                        function: (){
                          final _newBook = BookCard(
                            published: _published.text,
                            plot: _plot.text,
                            genre: _genre.text,
                            author: _author.text,
                            title: _title.text,
                            image: _image.text = (_image.text.isEmpty) ? "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY" : _image.text,
                          );

                          createBook(_newBook);

                          Navigator.pop(context);
                        },
                      ),

                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            Icons.library_books_outlined,
            Icons.checklist_rtl_outlined,
            Icons.favorite_border_outlined,
            Icons.settings_outlined,
          ],
          activeIndex: _index,
          gapLocation: GapLocation.center,
          onTap: _onTapped,
        ),

        body: _pages.elementAt(_index),
      ),
    );
  }
}



