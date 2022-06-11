import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:reading_list/reading_list.dart';
import 'package:reading_list/settings.dart';
import 'package:reading_list/completed_list.dart';
import 'package:reading_list/favourites.dart';
import 'package:reading_list/utilities.dart';
import 'package:reading_list/books.dart';
import 'package:reading_list/widgets.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBook();
}

class _AddBook extends State<AddBook> {

  //collection reference
  final _collectionReference = FirebaseFirestore.instance.collection('books');

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

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              backgroundColor: Colors.orangeAccent,
              context: context,
              builder: (context){
                return BottomsheetMenu(
                  collection: _collectionReference,
                  message: 'Book successfully added',
                );
              },
            );

            // bottomsheet(
            //   ctx: context,
            //   image: _image,
            //   author: _author,
            //   authorFocusNode: _authorFocusNode,
            //   genre: _genre,
            //   genreFocusNode: _genreFocusNode,
            //   plot: _plot,
            //   plotFocusNode: _plotFocusNode,
            //   published: _published,
            //   publishedFocusNode: _publishedFocusNode,
            //   title: _title,
            //   titleFocusNode: _titleFocusNode,
            //
            //   function: (){
            //     final _newBook = BookCard(
            //       id: DateTime.now().toString(),
            //       published: _published.text,
            //       plot: _plot.text,
            //       genre: _genre.text,
            //       author: _author.text,
            //       title: _title.text,
            //       image: _image.text = (_image.text.isEmpty) ? "https://media-exp1.licdn.com/dms/image/C560BAQH13TDLlaBLbA/company-logo_200_200/0/1584544180342?e=2147483647&v=beta&t=WAU3JlVFWsSIiIRfQs7dzzzhWkjaT0UipgQ5P1opEVY" : _image.text,
            //     );
            //
            //     createBook(_newBook);
            //
            //     _published.clear();
            //     _plot.clear();
            //     _genre.clear();
            //     _author.clear();
            //     _title.clear();
            //     _image.clear();
            //
            //     Navigator.pop(context);
            //
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       floatingSnackBar(
            //         'Book successfully added',
            //       ),
            //     );
            //   },
            // );
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