// import 'dart:developer';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_service.dart';
// import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
// import '../firebase_options.dart';
// import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body:Column(children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email here'),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password here'),
                ),
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      // final usercredential = await FirebaseAuth.instance
                      //     .signInWithEmailAndPassword(
                      //   email: email,
                      //   password: password,
                      // );
                      await AuthService.firbase().logIn(email: email, password: password);
                      // final user = FirebaseAuth.instance.currentUser;
                      final user = AuthService.firbase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, (route) => false);
                      }
                      // log(usercredential.toString());
                    } 
                    on UserNotFoundAuthException
                    {
                        await showErrorDialog(context, 'User not found');

                    }
                    on WrongPasswordAuthException
                    {
                        await showErrorDialog(context, 'Wrong Password');

                    }
                    on GenericAuthException
                    {
                      await showErrorDialog(context, 'Authentication Error');
                    }
                    // on FirebaseAuthException catch (e) {
                    //   // print(e.code);
                    //   if (e.code == 'user-not-code') {
                    //     await showErrorDialog(context, 'User not found');
                    //   } else if (e.code == 'wrong-password') {
                    //     await showErrorDialog(context, 'Wrong Password');
                    //     // log('Wrong Password');
                    //   } else {
                    //     await showErrorDialog(context, 'Error ${e.code}');
                    //   }
                    // } 
                    // catch (e) {
                    //   // print('something bad happend :(');
                    //   await showErrorDialog(context, 'Error ${e.toString()}');
                    //   // print(e.runtimeType);
                    //   // print(e);

                    // }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                    onPressed: () {
                      // return const RegisterView();
                      // we have specified a void function
                      // We need a scaffold for register;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    },
                    child: const Text('Not registered yet? Register here!'))
              ])
    );
  }
}
