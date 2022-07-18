import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';
// import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: AuthService.firbase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
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
                        //     .createUserWithEmailAndPassword(
                        //         email: email, password: password);
                        // final user = FirebaseAuth.instance.currentUser;
                        await AuthService.firbase().createUser(email: email, password: password);
                        final user = AuthService.firbase().currentUser;
                        // await user?.sendEmailVerification();
                        AuthService.firbase().sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                        // log(usercredential.toString());
                      } 
                      on WeakPasswordAuthException 
                      {
                        await showErrorDialog(context, 'Weak Password');
                      }
                      on EmailAlreadyInUseAuthException
                      {
                        await showErrorDialog(context, 'Email is already in use');

                      }
                      on InvalidEmailAuthException
                      {
                        await showErrorDialog(context, 'Email is invalid');

                      }
                      on GenericAuthException
                      {
                        await showErrorDialog(context, 'Failed to register');

                      }
                      // on FirebaseAuthException catch(e)
                      // {
                      //   // print(e.code);
                      //   if(e.code== 'weak-password')
                      //   {
                      //     await showErrorDialog(context, 'Weak Password');
                      //   }
                      //   else if (e.code=='email-already-in-use')
                      //   {
                      //     await showErrorDialog(context, 'Email is already in use');
                      //     // log('Email is already in use');
                      //   }
                      //   else if (e.code=='invalid-email')
                      //   {
                      //     await showErrorDialog(context, 'Email is invalid');
                      //     // log('Email is invalid');
                      //   }
                      //   else{
                      //     await showErrorDialog(context, 'Error ${e.code}');

                      //   }
                      // } 
                      // catch(e)
                      // {
                      //   await showErrorDialog(context, e.toString());
                      // }

                    
                  },
                  child: const Text('Register'),
                ),
                TextButton(onPressed: (){
                      // return const RegisterView();
                      // we have specified a void function
                      // We need a scaffold for register;
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    } , 
                    child: const Text('Already registered? Login here!'))
              ]);

            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
