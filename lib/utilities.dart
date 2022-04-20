import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/widgets.dart';
import 'package:reading_list/books.dart';

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

//update firebase

Future bottomsheet ({required BuildContext ctx, required TextEditingController image, required TextEditingController author, required TextEditingController published, required TextEditingController title, required TextEditingController genre, required TextEditingController plot, required FocusNode titleFocusNode, required FocusNode authorFocusNode, required FocusNode publishedFocusNode, required FocusNode genreFocusNode, required FocusNode plotFocusNode, required VoidCallback function}){
  return showModalBottomSheet(
    isScrollControlled: true,
    context: ctx,
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
                      controller: image,
                      function: (_){
                        FocusScope.of(context).requestFocus(titleFocusNode);
                      },
                    ),

                    kUserInput(
                      text: "Title",
                      controller: title,
                      focusNode: titleFocusNode,
                      function: (_){
                        FocusScope.of(context).requestFocus(authorFocusNode);
                      },
                    ),

                    kUserInput(
                      text: "Author",
                      controller: author,
                      focusNode: authorFocusNode,
                      function: (_){
                        FocusScope.of(context).requestFocus(publishedFocusNode);
                      },
                    ),

                    kUserInput(
                      text: "Publish Date",
                      controller: published,
                      focusNode: publishedFocusNode,
                      function: (_){
                        FocusScope.of(context).requestFocus(genreFocusNode);
                      },
                    ),kUserInput(
                      text: "Genre",
                      controller: genre,
                      focusNode: genreFocusNode,
                      function: (_){
                        FocusScope.of(context).requestFocus(plotFocusNode);
                      },
                    ),kUserInput(
                      text: "Plot",
                      controller: plot,
                      focusNode: plotFocusNode,
                      function: null,
                    ),

                  ],
                ),
              ),
            ),

            bookOptions(
              text: "Save",
              ctx: context,
              function: function,
            ),

          ],
        ),
      );
    },
  );
}