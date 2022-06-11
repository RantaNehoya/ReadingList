import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:reading_list/completed_books.dart';
import 'package:reading_list/widgets.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({Key? key}) : super(key: key);

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  @override
  Widget build(BuildContext context) {
    final c_books = Provider.of<CompletedBooks>(context, listen: true);
    final c_booksList = c_books.getCompleted_books;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Completed'),
          centerTitle: true,
        ),

        body: c_booksList.isEmpty ?
        const Center(
          child: Text('Hmm... there seems to be nothing here'),
        )
            :
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/4.6,
          ),

          itemBuilder: (context, index){
            return GestureDetector(
              child: c_booksList.elementAt(index),

              onTap: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      content: const Text(
                        'Are you sure you want to remove this book?',
                        textAlign: TextAlign.center,
                      ),

                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: <Widget>[
                            OutlinedButton(
                              child: const Text('Yes'),
                              onPressed: (){
                                setState(() {
                                  c_books.removeFromCompleted(index);
                                });

                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  floatingSnackBar(
                                    'Book successfully removed',
                                  ),
                                );
                              },
                            ),

                            OutlinedButton(
                              child: const Text('No'),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },

          itemCount: c_booksList.length,
        ),
      ),
    );
  }
}
