import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:reading_list/widgets.dart';
import 'package:reading_list/books.dart';

class ReadingList extends StatefulWidget {
  const ReadingList({Key? key}) : super(key: key);

  @override
  State<ReadingList> createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {

  //reference firebase collection "books"
  Stream<List<BookCard>> _read() => FirebaseFirestore.instance.collection("books")
      .snapshots()
      .map((snapshot) => //iterate over snapshot documents and convert to BookCard object
  snapshot.docs.map((doc) => BookCard.fromJson(doc.data())).toList());

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
                          onTap: (){
                            //TODO: ALERT DIALOG
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              builder: (context){
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[

                                      Text(
                                        _book[index].plot,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18.0,
                                        ),
                                      ),

                                      bookOptions(
                                        ctx: context,
                                        text: "Edit",
                                        function: (){
                                          //TODO: EDIT FUNCTION
                                        },
                                      ),

                                      bookOptions(
                                        ctx: context,
                                        text: "Remove",
                                        function: (){
                                          //TODO: REMOVE FUNCTION
                                        },
                                      ),bookOptions(
                                        ctx: context,
                                        text: "Add to Favourites",
                                        function: (){
                                          //TODO: FAVOURITES FUNCTION
                                        },
                                      ),bookOptions(
                                        ctx: context,
                                        text: "Send to Completed",
                                        function: (){
                                          //TODO: SEND TO FUNCTION
                                        },
                                      ),
                                    ],
                                  ),
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