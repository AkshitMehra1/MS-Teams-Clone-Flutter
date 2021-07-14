import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/screens/chat_screens/create_chat.dart';
import 'package:trial/widgets/sideBar.dart';
import 'package:trial/screens/chat_screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trial/screens/meeting_screens/rooms_page.dart';
import 'package:trial/widgets/createRoom.dart';
import 'package:trial/screens/firebaseuser.dart';

final loginedUser = FirebaseAuth.instance.currentUser!;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// fetch User Data is defined below, it will fetch all the info of the user from Firebase
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  final loginedUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference cref =
      FirebaseFirestore.instance.collection('users');

  List data = [];
  bool check = true;

// addUserData will add all info from fetchUserData into the App.
  addUserData() {
    cref.add({
      "name": loginedUser.displayName,
      "email": loginedUser.email,
      "uid": loginedUser.uid,
      "profilepicurl": loginedUser.photoURL,
    });
  }

  fetchUserData() async {
    data.clear();
    setState(() {
      check = true;
    });
    await cref.get().then((snapshot) {
      for (var res in snapshot.docs) {
        setState(() {
          data.add(res.data());
        });
      }
    });
    for (int i = 0; i < data.length; i++) {
      if (data[i]['email'].toString() == loginedUser.email.toString()) {
        check = false;
      }
    }

    if (check) addUserData();
  }

// The UI for the App is given below, initially the index is selected to 1 which will redirect to Rooms everytime the homepage is accesed
  int _index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const Sidenavbar(),
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: const Text(
          "MS Teams Clone!!",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[800],
        onPressed: () {
          if (_index == 1) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateRoom(),
              ),
            );
          } else {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const SearchChat()));
          }
        },
        tooltip: _index == 1 ? "New Room" : "New Chat",
        child: const Icon(Icons.add),
      ),
      body: _navigation(_index),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.indigo[800],
        ),
        child: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            onTap: ((int x) {
              setState(() {
                _index = x;
                _navigation(_index);
              });
            }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_rounded,
                  size: 23,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                  size: 23,
                ),
                label: 'Rooms',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 23,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _navigation(int _index) {
  switch (_index) {
    case 0:
      return const Chat();
    case 1:
      return const Rooms();
    case 2:
      return UserInfoPage(useremail: loginedUser.email);
  }
  return Container();
}
