import 'package:flutter/material.dart';

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

TextFormField kUserInput ({required String text, required TextEditingController controller, required dynamic function, FocusNode? focusNode}){
  return TextFormField(
    decoration: InputDecoration(
      labelText: text,
    ),
    textInputAction: TextInputAction.next,
    controller: controller,
    focusNode: focusNode,
    onFieldSubmitted: function,
  );
}

SnackBar floatingSnackBar (String msg){
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
}