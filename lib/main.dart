// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/create_update_note_view.dart';
import 'package:mynotes/view/notes_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/verify_email_view.dart';
import 'dart:developer';

import 'firebase_options.dart';
// import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Apun Ka',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      //a dictionary
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: ((context) => const NotesView()),
      verifyEmailRoute: ((context) => const VerifyEmailView()),
      createOrUpdateNoteRoute: ((context) => const CreateUpdateNoteView())
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("My Notes", style: TextStyle(color: Color(0xffffffaa))),
      ),
      body: FutureBuilder(
        // future: AuthService.firbase().initialize(),
        future: Firebase.initializeApp(options:  DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // final user = AuthService.firbase().currentUser;
              final user = FirebaseAuth.instance.currentUser;
              log("Hello");
              log(user.toString());
              if (user != null) {
                if (user.emailVerified) {
                  // print('Email is Verified');
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            // return const Text('Done!');
            default:
              // return const Text("Loading...");
              return const CircularProgressIndicator();
            // final emailVerified = user?.emailVerified ?? false;
            // if (emailVerified) {
            //   // print('You are are a verified user');
            // } else {
            //   return const VerifyEmailView();
            //   // print('You need to verify your email address');
            //   // Navigator.of(context).push(MaterialPageRoute(
            //       // builder: ((context) => const VerifyEmailView())));
            // }
            // return const Text("Done!");
          }
        },
      ),
    );
  }
}



