import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/screens/chat_screens/chat_screen.dart';
import 'package:trial/screens/chat_screens/delete_popup.dart';
import 'package:trial/resources/chat_database_management.dart';
import 'package:connectivity/connectivity.dart';
import 'package:trial/resources/search_user_database.dart';
import 'package:trial/screens/firebaseuser.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

List<String> filterdata = [];

class _ChatState extends State<Chat> {
  final CollectionReference cref3 =
      FirebaseFirestore.instance.collection('chats');

  final user5 = FirebaseAuth.instance.currentUser!;

  StreamSubscription? sub;
  bool connection = true;

  UserDataManagement user = UserDataManagement();
  DeleteChat deletecontext = DeleteChat();

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((res) {
      setState(() {
        connection = (res != ConnectivityResult.none);
      });
    });
    getchatlist();
  }

  List chatlist = [];
  bool loading = true;

  Future<Null> getchatlist() async {
    setState(() {
      chatlist.clear();
      filterdata.clear();
    });
    await cref3.get().then((values) {
      for (var ele in values.docs) {
        setState(() {
          chatlist.add(ele.data());
        });
      }
    });
    for (int i = 0; i < chatlist.length; i++) {
      if (chatlist[i]['fromemail '] == user5.email) {
        setState(() {
          filterdata.add(chatlist[i]['toemail']);
        });
      }

      if (chatlist[i]['toemail'] == user5.email) {
        setState(() {
          filterdata.add(chatlist[i]['fromemail '].toString());
        });
      }
    }
    setState(() {
      loading = false;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              color: Colors.indigo[800],
              backgroundColor: Colors.black,
              onRefresh: getchatlist,
              child: ListView.builder(
                itemCount: filterdata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    color: Colors.black,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          getonpressemail = filterdata[index].toString();
                          chatTo = filterdata[index].toString();
                        });
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ConversationPage(
                              receivername:
                                  user.returninfo(filterdata[index], 1),
                            ),
                          ),
                        );
                      },
                      leading: FloatingActionButton(
                        backgroundColor: Colors.black,
                        heroTag: filterdata[index],
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserInfoPage(
                                useremail: filterdata[index],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            user.returninfo(filterdata[index], 0),
                          ),
                        ),
                      ),
                      title: Text(
                        user.returninfo(filterdata[index], 1),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        disabledColor: Colors.white,
                        onPressed: () {
                          deletecontext.showbottombuilder(
                              context, filterdata[index], "Delete");
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
    // }
  }
}
