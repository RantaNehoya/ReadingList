import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

//dialog alert box
class AlertBox extends StatelessWidget {
  final VoidCallback function;
  const AlertBox({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      content: Text(
        'Do you wish to delete this book?\nThis action is irreversible',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13.5,
          fontWeight: FontWeight.w300,
        ),
      ),

      actions: [
        OutlinedButton(
          onPressed: function,
          child: Text('Yes'),
        ),

        OutlinedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}

//bottom sheet
class BottomsheetMenu extends StatefulWidget {
  final CollectionReference collection;
  final String message;
  const BottomsheetMenu({Key? key, required this.collection, required this.message}) : super(key: key);

  @override
  State<BottomsheetMenu> createState() => _BottomsheetMenuState();
}
class _BottomsheetMenuState extends State<BottomsheetMenu> {
  DateTime _selectedDate = DateTime.now();
  bool _isDateSelected = false;
  bool _isLoading = false;

  late String _title;
  late String _author;
  late String _genre;
  late String _plot;
  late DateTime _datePublished;

  //date picker method
  _selectDate (BuildContext ctx) async {
    final DateTime? selected = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(1650),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (selected != null && selected != _selectedDate){
      setState((){
        _selectedDate = selected;
        _isDateSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [

              //title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value){
                    _title = value;
                  },

                  decoration: InputDecoration(
                    label: const Text('Title'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),

              //author
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value){
                    _author = value;
                  },

                  decoration: InputDecoration(
                    label: const Text('Author'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),

              //genre
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value){
                    _genre = value;
                  },

                  decoration: InputDecoration(
                    label: const Text('Genre'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),

              //plot
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value){
                    _plot = value;
                  },

                  decoration: InputDecoration(
                    label: const Text('Plot'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  //date published
                  GestureDetector(
                    onTap: () async {
                      _selectDate(context);
                      _datePublished = _selectedDate;
                    },

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.07,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 1.0,
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: [
                            const Icon(Icons.today_outlined),

                            Text(
                              _isDateSelected ? '${_selectedDate.year} - ${_selectedDate.month} - ${_selectedDate.day}': 'Choose Date Published',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //TODO: VALIDATE
                  ModalProgressHUD(
                    inAsyncCall: _isLoading,
                    child: ElevatedButton(
                      child: const Text('Add Book'),
                      onPressed: (){
                        _isLoading = true;
                        widget.collection.add({
                          'image': '',
                          'title': _title,
                          'author': _author,
                          'genre': _genre,
                          'plot': _plot,
                          'published': _datePublished.toString(),
                        });
                        Navigator.pop(context);
                        _isLoading = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(widget.message),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

