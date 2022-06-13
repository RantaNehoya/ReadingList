import 'package:flutter/material.dart';

const kFirebaseStreamNoDataMessage = Center(
  child: Text("Hmm... there seems to be nothing here"),
);

const kBottomSheetPadding = EdgeInsets.all(15.0);

const kBookGridLayout = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 3/4.6,
);