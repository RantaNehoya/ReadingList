import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:reading_list/utilities/add_book.dart';
import 'package:reading_list/screens/reading_list_screen.dart';
import 'package:reading_list/screens/completed_books_screen.dart';
import 'package:reading_list/screens/favourite_books_screen.dart';
import 'package:reading_list/screens/settings_screen.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({Key? key}) : super(key: key);

  @override
  State<PageNavigation> createState() => _PageNavigation();
}

class _PageNavigation extends State<PageNavigation> {

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
              context: context,
              backgroundColor: Colors.orangeAccent,
              isScrollControlled: true,

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),

              builder: (context){
                return AddBook();
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