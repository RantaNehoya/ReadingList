import 'package:flutter/material.dart';

import 'books.dart';


class CompletedBooks with ChangeNotifier{

  List _completed_books = [];

  List get getCompleted_books => _completed_books;

  void addToCompleted (BookCard newBook){
    _completed_books.add(newBook);
    notifyListeners();
  }

  void removeFromCompleted (int index){
    List listOfBooks = _completed_books.toList();
    listOfBooks.remove(listOfBooks.elementAt(index));
    notifyListeners();
  }
}