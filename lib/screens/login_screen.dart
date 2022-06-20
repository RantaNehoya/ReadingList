import 'package:flutter/material.dart';

import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/models/page_navigation.dart';
import 'package:reading_list/utilities/widgets.dart';

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
      onLogin: LoginFunctions(context).onSignup,
      onSignup: LoginFunctions(context).onLogin,
      onForgotPassword: LoginFunctions(context).onForgotPassword,

      loginMobileTheme: LoginViewTheme(
        textFormStyle: const TextStyle(
          color: Colors.white70,
        ),
      ),

      signUpMode: SignUpModes.confirmPassword,
      loginTexts: LoginTexts(
        //sign up messages
        welcome: 'Welcome to Reading List',
        welcomeDescription: 'A place to log all your reading books',
        login: 'Log in',

        //log in messages
        welcomeBack: 'Reading List',
        welcomeBackDescription: 'Glad to have you back!',
        notHaveAnAccount: 'Don\'t have an account?',
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
        String docID = user.uid;

        //create default starter book
        _collectionReference.doc(docID).collection('books').doc().set({
          'image': '',
          'title': 'new book',
          'author': 'author',
          'genre': 'genre',
          'plot': 'plot',
          'published': DateTime.now().toString(),
        });

        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();

        Navigator.popAndPushNamed(
          context, '/navigator',
        );
      }
    }

    on FirebaseAuthException catch (e){
      Navigator.of(context).pop();

      if (e.code == 'email-already-exists'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'Email already exists',
          ),
        );
      }
      else if (e.code == 'internal-error'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'An error occurred',
          ),
        );
      }
      else if (e.code == 'invalid-email'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'Invalid email',
          ),
        );
      }
      else if (e.code == 'invalid-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'Password must be 6 characters long',
          ),
        );
      }
    }

    on Exception {
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

        Navigator.popAndPushNamed(
          context, '/navigator',
        );
      }
    }

    on FirebaseAuthException catch (e){
      Navigator.of(context).pop();

      if (e.code == 'internal-error'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'An error occurred',
          ),
        );
      }
      else if (e.code == 'invalid-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'Invalid password',
          ),
        );
      }
      else if (e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          floatingSnackBar(
            'User not found',
          ),
        );
      }
    }

    on Exception {
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
  // Future<String?> onSocialLogin() async {
  //
  //   try {
  //     DialogBuilder(context).showLoadingDialog();
  //
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //
  //     UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
  //     User? user = userCredential.user;
  //
  //     if (user != null){
  //
  //       String docID = user.uid;
  //
  //       //create default starter book
  //       _collectionReference.doc(docID).collection('books').doc().set({
  //         'image': '',
  //         'title': 'new book',
  //         'author': 'author',
  //         'genre': 'genre',
  //         'plot': 'plot',
  //         'published': DateTime.now().toString(),
  //       });
  //
  //       await Future.delayed(const Duration(seconds: 2));
  //       Navigator.of(context).pop();
  //
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PageNavigation()));
  //
  //       DialogBuilder(context).showResultDialog('Successful log in');
  //       await Future.delayed(const Duration(seconds: 1));
  //       Navigator.of(context).pop();
  //     }
  //   } on Exception catch(e) {
  //     Navigator.of(context).pop();
  //     print('******************************** $e');
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       floatingSnackBar(
  //         'An error occurred',
  //       ),
  //     );
  //   }
  //
  //   return null;
  // }

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