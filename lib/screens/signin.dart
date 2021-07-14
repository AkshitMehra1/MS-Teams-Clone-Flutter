// To Sign in a user after logging out or opening the app first time

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/configs/authentication_methods.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

// Sign in screen with Logo and Google Sign in button
class _SigninState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo.png',
              height: 300,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Login with Google Please",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50.0,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => disPopUp(context),
                  );
                },
                child: Container(
                  width: 230,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Center(
                        child: Text(
                          "Google Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A disclaimer pop up box just for the confirmation and time pass
// Press Continue to login with google and go to the homepage of the App though the main.dart file
Widget disPopUp(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.indigo[800],
    title: const Center(
      child: Text(
        'Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              const Text(
                'Press Continue to Login',
                textAlign: TextAlign.center,
                maxLines: 10,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Container(
                height: 50.0,
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: ButtonTheme(
                      height: 45,
                      minWidth: 100,
                      buttonColor: Colors.lightBlue,
                      child: ElevatedButton(
                        onPressed: () {
                          final provider = Provider.of<Googlesigninprov>(
                            context,
                            listen: false,
                          );
                          provider.googleLogin();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
