// This App is created by Akshit Mehra and provides basic features to video call and text message like Teams.
// There maybe many bugs in it, if you find any please report them to improve the quality of the app.
// Everything works on Null safety for now and in Test.
// *This is not ready for Production yet*
// It was made for Microsoft Engage 2021 and after some time all the tokens in this app will stop working.

// Main Function that gets called first
// Ignore all the warnings while running the app, they are there because of changes in Flutter 1.0 and Flutter 2.0. Everthing is going to work if you are using the latest version of flutter.
// Some features were still in development while submitting the app so there may be some extra code but that won't affect the app in it's working state so that can be ignored too.

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:trial/configs/authentication_methods.dart';
import 'package:trial/screens/my_homepage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trial/screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// The Splash Screen is displayed first with Hello and Logo of the App

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Googlesigninprov(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: const Mainrun(),
          loadingText: const Text(
            "Hello!!",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          image: Image.asset(
            'lib/assets/logo.png',
            height: 500.0,
            width: 500.0,
            alignment: Alignment.center,
          ),
          backgroundColor: Colors.black,
          photoSize: 100.0,
          loaderColor: Colors.transparent,
        ),
      ),
    );
  }
}

class Mainrun extends StatefulWidget {
  const Mainrun({Key key}) : super(key: key);

  @override
  _MainrunState createState() => _MainrunState();
}

class _MainrunState extends State<Mainrun> {
  @override
  void initState() {
    super.initState();
  }

// Redirecting to Google Login Page, if the user already is signed in then it is redirected to the home page of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          } else if (snapshot.hasData) {
            return MyHomePage();
          }
          return SignInPage();
        },
      ),
    );
  }
}
