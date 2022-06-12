import 'package:flutter/material.dart';

const kFirebaseStreamNoDataMessage = Center(
  child: Text("Hmm... there seems to be nothing here"),
);

const kBookGridLayout = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3/4.6,
);