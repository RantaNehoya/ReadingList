import 'package:flutter/material.dart';

Center firebaseStreamHasErrorMessage (){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          strokeWidth: 3.0,
        ),
        SizedBox(
          height: 15.0,
        ),

        Text(
          'Fetching...',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        )
      ],
    ),
  );
}

Padding bookOption ({required String action, required BuildContext ctx, required VoidCallback function}){
  return Padding(
    padding: const EdgeInsets.all(5.0),

    child: Center(
      child: OutlinedButton(

        child: Text(
          action,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),

        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),

          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              vertical: MediaQuery.of(ctx).size.height * 0.015,
              horizontal: 40.0,
            ),
          ),
        ),

        onPressed: function,
      ),
    ),
  );
}

SnackBar floatingSnackBar (String msg){
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
}