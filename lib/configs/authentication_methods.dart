import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Google Authentication from firebase

class Googlesigninprov extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser;

    final googleauth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: googleauth.accessToken,
      idToken: googleauth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(cred);
    notifyListeners();
  }

  Future logoutofapp() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
