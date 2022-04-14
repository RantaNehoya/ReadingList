import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

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
