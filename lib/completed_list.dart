import 'package:flutter/material.dart';

class CompletedList extends StatelessWidget {
  const CompletedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const <Widget>[
            Center(
              child: Text("Hmm... there seems to be nothing here"),
            ),
          ],
        ),
      ),
    );
  }
}
