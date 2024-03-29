import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';
import 'package:flutter_test/src/test_compat.dart';

void main() {

  group('Mock Authentication', () {
    final provider = MockAuthProv();
    test('Should not be initialized to begin with', () {
        expect(provider.isInitialized, false);
    });
    test('Cannot log out if not initialized', () {
        expect(provider.logOut(),  throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to initialize ', ()async {
        await provider.initialize();
        expect(provider.isInitialized, true);
    });
    test('User should be null after initializtion', (){
        // await provider.initialize();
        expect(provider.currentUser, null);
    });
    test('Should be able to init in less than 2 sec', ()async{
        await provider.initialize();
        expect(provider.isInitialized, true);
    },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should be delegate to login function', () async{
      final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPassUser = provider.createUser(email: 'someone@bar.com', password: 'foobar');
      expect(badPassUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'someone@bar.com', password: 'anypass')
      expect(provider.currentUser,user);
      expect(user.isEmailVerified, false);
    });
    test('User should be able to verified', () async{
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user.isEmailVerified, true);
    });
      test('Should be able to logout', () async {
        await provider.logOut();
        await provider.logIn(email: 'email', password: 'password');
        final user = provider.currentUser;
        expect(user, isNotNull);
      });
  });

  
}
class NotInitializedException implements Exception{}

class MockAuthProv implements AuthProvider{
  AuthUser? _user;

  var _isInitialized = false;

  bool get isInitialized => _isInitialized;


  @override
  Future<AuthUser> createUser ({required String email, required String password}) async {
    // TODO: implement createUser
    if(!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds:1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Future.delayed(const Duration(seconds:1));

    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    if(!isInitialized) throw NotInitializedException();
    if(email=='foo@bar.com') throw UserNotFoundAuthException();
    if(password=='foobar') throw WrongPasswordAuthException();
    // throw UnimplementedError();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user==null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds:1));
    _user = null;
    // TODO: implement logOut
    // throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user==null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified:true);
    _user = newUser;


  }

}