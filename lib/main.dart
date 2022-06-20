import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/models/page_navigation.dart';
import 'package:reading_list/screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _){
          return MaterialApp(
            title: 'Reading List',
            debugShowCheckedModeBanner: false,
            theme: theme.isDark ? AppTheme.darkMode : AppTheme.lightMode,

            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen(),
              '/navigator': (context) => const PageNavigation(),
            },
          );
        },
      ),
    );
  }
}



