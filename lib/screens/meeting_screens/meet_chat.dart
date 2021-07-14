import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trial/resources/meeting_room_chat_database_management.dart';
import 'package:trial/resources/search_user_database.dart';
import 'package:trial/screens/meeting_screens/meet_popup.dart';

class InmeetChat {
  InmeetChatManagement mchat = InmeetChatManagement();

  final scrollcontrol = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController inmeetchatcontroller = TextEditingController();
  UserDataManagement userdata = UserDataManagement();

  scrolltobottom() {
    if (scrollcontrol.hasClients) {
      scrollcontrol.jumpTo(scrollcontrol.position.maxScrollExtent);
    }
  }

  Widget _chattileinmeet(String nextdocid) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .doc(pdocid)
            .collection("roomChats")
            .doc(nextdocid)
            .collection("inmeetchat")
            .orderBy("counter")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => scrolltobottom());
          if (!snapshot.hasData) return Container();
          return ListView(
            controller: scrollcontrol,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: document['from'] == user.email.toString()
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[800],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25),
                          topRight: const Radius.circular(25),
                          bottomLeft: document['from'] == user.email.toString()
                              ? const Radius.circular(25)
                              : const Radius.circular(0),
                          bottomRight: document['from'] == user.email.toString()
                              ? const Radius.circular(0)
                              : const Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (userdata.returninfo(document['from'], 1) ==
                                    user.displayName)
                                ? "You"
                                : userdata.returninfo(document['from'], 1),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            document['message'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  bottomchat(context, String nextdocid, String meetid, bool behav) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo[800],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Meeting Room Chat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _chattileinmeet(nextdocid),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 69,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.indigo[800],
                          child: ListTile(
                            title: TextField(
                              onTap: () {},
                              controller: inmeetchatcontroller,
                              onChanged: (String str) {},
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                mchat.getLastCount(
                                    meetid, inmeetchatcontroller.text, behav);
                                setState(() {
                                  inmeetchatcontroller.clear();
                                });
                              },
                              icon: const Icon(Icons.send_sharp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
