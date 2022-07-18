import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exception.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        // log('Email is already in use');
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
        // log('Email is invalid');
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } 
    on FirebaseAuthException catch (e) {
      if(e.code=='user-not-found')
      {
        throw UserNotFoundAuthException();
      }
      else if(e.code == 'wrong-passwaord')
      {
        throw WrongPasswordAuthException();
      }
      else{
        throw GenericAuthException();
      }
    } catch(e){
      throw GenericAuthException();
    }
    // TODO: implement logIn
    // throw UnimplementedError();
  }

  @override
  Future<void> logOut()async{
    // TODO: implement logOut
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null)
    {
      await FirebaseAuth.instance.signOut();
    }
    else
    {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    // TODO: implement sendEmailVerification
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
    // throw UnimplementedError();
  }
  
  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
  }
}
