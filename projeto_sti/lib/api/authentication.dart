//1
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projeto_sti/api/exceptions.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

//2
final FirebaseAuth _auth = FirebaseAuth.instance;

class Authentication {
  Authentication._privateConstructor();

  static final Authentication _instance = Authentication._privateConstructor();

  factory Authentication() {
    return _instance;
  }

  User? loggedInUser;

  /// To sign user out.
  void signOut() async {
    // bool someoneSignedIn = false;
    final User? user = await _auth.currentUser;
    if (user == null) {
      return;
    }
    await _auth.signOut();
    // final String uid = user.uid;
  }

  /// To register user.
  ///
  /// A [SignUpException] maybe thrown with the following error code:
  /// - **empty-email**:
  ///  - Thrown if no email was provided.
  /// - **empty-password**:
  ///  - Thrown if no password was provided.
  /// - **empty-password-confirm**:
  ///  - Thrown if the user didn't confirm the password.
  /// - **passwords-dont-match**:
  ///  - Thrown if the password and the password confirm don't match
  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **operation-not-allowed**:
  ///  - Thrown if email/password accounts are not enabled.
  /// - **weak-password**:
  ///  - Thrown if the password is not strong enough.
  Future<void> signUserUp(
      String email, String password, String passwordConfirm) async {
    if (email.isEmpty) {
      throw SignUpException("empty-email");
    }
    if (password.isEmpty) {
      throw SignUpException("empty-password");
    }
    if (passwordConfirm.isEmpty) {
      throw SignUpException("empty-password-confirm");
    }
    if (password != passwordConfirm) {
      throw SignUpException("passwords-dont-match");
    }
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        loggedInUser = user;
      } else {
        print("ERROR");
      }
    } on FirebaseAuthException catch (e) {
      throw SignUpException(e.code);
    }
  }

  /// Attempts to sign in a user with the given email address and password.
  ///
  /// A [LoginException] maybe thrown with the following error code:
  /// - **empty-email**:
  ///  - Thrown if the email address is not provided.
  /// - **empty-password**:
  ///  - Thrown if the password is not provided.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-disabled**:
  ///  - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  ///  - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  Future<void> login(String email, String password) async {
    //Firebase já trata da verificação de email
    if (email.isEmpty) {
      throw LoginException("empty-email");
    }
    if (password.isEmpty) {
      throw LoginException("empty-password");
    }
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        loggedInUser = user;
      } else {
        print("ERROR");
      }
    } on FirebaseAuthException catch (e) {
      throw LoginException(e.code);
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    loggedInUser =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }
}
