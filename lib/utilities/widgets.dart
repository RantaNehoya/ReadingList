import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:reading_list/app_theme.dart';

Center firebaseStreamHasErrorMessage (){
  return Center(
    child: Consumer<ThemeProvider>(
      builder: (context, theme, _){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3.0,
            ),

            const SizedBox(
              height: 15.0,
            ),

            Text(
              'Fetching...',
              style: TextStyle(
                fontSize: 15.0,
                color: theme.isDark ? Colors.white54 : Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        );
      },
    ),
  );
}

Padding bookOption ({required String action, required BuildContext ctx, required VoidCallback function}){
  return Padding(
    padding: const EdgeInsets.all(5.0),

    child: Consumer<ThemeProvider>(
      builder: (context, theme, _){
        return Center(
          child: OutlinedButton(

            child: Text(
              action,
              style: const TextStyle(
                fontSize: 13.0,
              ),
            ),

            style: ButtonStyle(
              foregroundColor: theme.isDark ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black),

              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(
                  vertical: MediaQuery.of(ctx).size.height * 0.015,
                  horizontal: 40.0,
                ),
              ),
            ),

            onPressed: function,
          ),
        );
      },
    ),
  );
}

SnackBar floatingSnackBar (String msg){
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
}

Padding bookInputTextFormField ({required String label, required TextEditingController controller, FocusNode? focusNode, FocusNode? requestedFocusNode}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      focusNode: focusNode,

      validator: (value){
        if (value == null || value.isEmpty){
          return 'Cannot leave field empty';
        }
        else {
          return null;
        }
      },

      onEditingComplete: (){
        requestedFocusNode?.requestFocus();
      },

      decoration: InputDecoration(
        label: Text(label),
      ),
    ),
  );
}

Padding settingsPageOptions ({required IconData icon, required String label, required VoidCallback function}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
      ),

      onTap: function,
    ),
  );
}

Divider settingsPageDivider (BuildContext ctx){
  return Divider(
    thickness: 1.0,
    endIndent: MediaQuery.of(ctx).size.width * 0.03,
    indent: MediaQuery.of(ctx).size.width * 0.03,
  );
}

double bottomSheetHeight (BuildContext ctx){
  return MediaQuery.of(ctx).size.height * 0.9;
}

double publicationDateWidth (BuildContext ctx){
  return MediaQuery.of(ctx).size.width * 0.5;
}

double publicationDateHeight (BuildContext ctx){
  return MediaQuery.of(ctx).size.width * 0.07;
}