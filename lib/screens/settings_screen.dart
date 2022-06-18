import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:reading_list/app_theme.dart';
import 'package:reading_list/utilities/widgets.dart';

import 'login_screen.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {

  //firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Change Theme"),
            ),

            body: Column(
              children: [

                //user details
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: theme.isDark ? AppTheme.darkMode.primaryColorDark : AppTheme.lightMode.primaryColorDark,

                    child: Column(
                      children: [
                        Icon(
                          Icons.manage_accounts_outlined,
                          size: MediaQuery.of(context).size.width * 0.4,
                        ),

                        Container(
                          color: theme.isDark ? AppTheme.darkMode.primaryColorLight : AppTheme.lightMode.primaryColorLight,

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _firebaseAuth.currentUser!.email.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        //change email
                        settingsPageOptions(
                          label: 'Change Email',
                          icon: Icons.email_outlined,
                          function: (){
                            //TODO: CHANGE EMAIL
                            _firebaseAuth.currentUser!.updateEmail('newEmail');
                          },
                        ),

                        //change password
                        settingsPageOptions(
                          label: 'Change Password',
                          icon: Icons.password_outlined,
                          function: (){
                            _firebaseAuth.sendPasswordResetEmail(
                              email: _firebaseAuth.currentUser!.email.toString(),
                            );

                            floatingSnackBar('Password reset sent to email address');
                          },
                        ),

                        //log out
                        settingsPageOptions(
                          label: 'Log Out',
                          icon: Icons.logout_outlined,
                          function: (){
                            _firebaseAuth.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                        ),

                        settingsPageDivider(context),

                        //change to light mode
                        settingsPageOptions(
                          label: 'Light Mode',
                          icon: Icons.light_mode_outlined,
                          function: (){
                            //isDark = false
                            theme.changeTheme(false);
                          },
                        ),

                        //change to dark mode
                        settingsPageOptions(
                          label: 'Dark Mode',
                          icon: Icons.dark_mode_outlined,
                          function: (){
                            //isDark = true
                            theme.changeTheme(true);
                          },
                        ),

                        settingsPageDivider(context),

                        //delete account
                        settingsPageOptions(
                          label: 'Delete Account',
                          icon: Icons.delete_outlined,
                          function: (){
                            //TODO: ALERT DIALOG
                            _firebaseAuth.currentUser!.delete();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     vertical: 8.0,
                //   ),
                //   child: ListView(
                //     children: <Widget>[
                //
                //
                //
                //
                //       GestureDetector(

                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
