import 'package:flutter/material.dart';

import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_theme.dart';
import '../models/page_navigation.dart';
import '../utilities/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _currentMode = AuthMode.signup;

  @override
  Widget build(BuildContext context) {
    return AnimatedLogin(
      //TODO: LOGO
      onLogin: LoginFunctions(context).onSignup,
      onSignup: LoginFunctions(context).onLogin,
      onForgotPassword: LoginFunctions(context).onForgotPassword,
      socialLogins: [
        SocialLogin(
          iconPath: 'assets/images/google.png',
          callback: () async { return 'null';},
        ),
      ],
      loginMobileTheme: LoginViewTheme(
        textFormStyle: const TextStyle(
          color: Colors.white70,
        ),
      ),

      signUpMode: SignUpModes.confirmPassword,
      loginTexts: LoginTexts(
        //sign up messages
        welcomeDescription: 'Sign up with',
        signUpUseEmail: 'or',
        login: 'Log in',

        //log in messages
        welcomeBackDescription: 'Log in with',
        notHaveAnAccount: 'Don\'t have an account?',
        loginUseEmail: 'or',
        signUp: 'Sign up',
      ),
      initialMode: _currentMode,
      onAuthModeChange: (AuthMode newMode) => _currentMode = newMode,
    );
  }
}

class LoginFunctions {

  final BuildContext context;
  LoginFunctions(this.context);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  //log in - calls sign up
  Future<String?> onSignup(LoginData loginData) async {

    try {
      DialogBuilder(context).showLoadingDialog();

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: loginData.email,
        password: loginData.password,
      );

      User? user = userCredential.user;

      if (user != null){

        //create default starter book
        _collectionReference.doc(user.email.toString()).collection('books').doc().set({
          'image': '',
          'title': 'new book',
          'author': 'author',
          'genre': 'genre',
          'plot': 'plot',
          'published': DateTime.now().toString(),
        });

        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();

        DialogBuilder(context).showResultDialog('Successfully signed up.');
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PageNavigation()));
      }
    } on Exception { //TODO: AUTH EXCEPTION
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar(
          'An error occurred',
        ),
      );
    }

    return null;
  }

  //sign up - calls login
  Future<String?> onLogin(SignUpData signupData) async {

    try {
      DialogBuilder(context).showLoadingDialog();

      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: signupData.email,
        password: signupData.password,
      );

      User? user = userCredential.user;
      
      if (user != null){
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();

        DialogBuilder(context).showResultDialog('Successfully logged in.');
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PageNavigation()));
      }
    } on Exception {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar(
          'An error occurred',
        ),
      );
    }

    return null;
  }

  /// Social login callback
  Future<String?> socialLogin(String type) async {
    //TODO: GOOGLE SIGN IN
    DialogBuilder(context).showLoadingDialog();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    DialogBuilder(context)
        .showResultDialog('Successful social login with $type.');
    return null;
  }

  //forgot password
  Future<String?> onForgotPassword(String email) async {

    try {
      DialogBuilder(context).showLoadingDialog();

      _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();

      DialogBuilder(context).showResultDialog('Password reset link sent to email');
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        floatingSnackBar(
          'An error occurred',
        ),
      );
    }

    return null;
  }
}

class DialogBuilder {

  final BuildContext context;
  const DialogBuilder(this.context);

  //loading dialog
  Future<void> showLoadingDialog() => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content:  SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.lightMode.primaryColor,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    ),
  );

  //result dialog
  Future<void> showResultDialog(String text) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: SizedBox(
        height: 100,
        width: 100,
        child: Center(child: Text(text, textAlign: TextAlign.center)),
      ),
    ),
  );
}