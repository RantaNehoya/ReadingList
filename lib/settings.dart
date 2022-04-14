import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Theme"),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: ListView(
            children: <Widget>[

              //change to light mode
              GestureDetector(
                child: const ListTile(
                  leading: Icon(Icons.light_mode_outlined),
                  title: Text("Light Mode"),
                ),

                onTap: (){
                  //TODO: ADD THEME
                },
              ),

              //change to dark mode
              GestureDetector(
                child: const ListTile(
                  leading: Icon(Icons.dark_mode_outlined),
                  title: Text("Dark Mode"),
                ),

                onTap: (){
                  //TODO: ADD THEME
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
