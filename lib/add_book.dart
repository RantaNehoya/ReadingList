import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:reading_list/reading_list.dart';
import 'package:reading_list/settings.dart';
import 'package:reading_list/completed_list.dart';
import 'package:reading_list/favourites.dart';
import 'package:reading_list/utilities.dart';
import 'package:reading_list/books.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBook();
}

class _AddBook extends State<AddBook> {

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

                _published.clear();
                _plot.clear();
                _genre.clear();
                _author.clear();
                _title.clear();
                _image.clear();

                Navigator.pop(context);
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