import 'package:flutter/material.dart';

Padding bookOptions ({required BuildContext ctx, required VoidCallback function, required String text}){
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Center(
      child: OutlinedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black,),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              vertical: MediaQuery.of(ctx).size.height * 0.015,
              horizontal: 40.0,
            ),
          ),
        ),

        onPressed: function,

        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
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