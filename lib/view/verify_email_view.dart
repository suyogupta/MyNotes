import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account"),
          const Text("If you havn't received it yet, press the button below"),
          TextButton(
              onPressed: () async {
                // final user = FirebaseAuth.instance.currentUser;
                // log(user.toString());
                // await user?.sendEmailVerification();
                AuthService.firbase().sendEmailVerification();
                // print('Sent');
              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                await AuthService.firbase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                // print('Sent');
              },
              child: const Text('Restart')),
        ],
      ),
    );
  }
}
