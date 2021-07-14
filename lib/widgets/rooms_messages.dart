import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trial/resources/room_chat_database_management.dart';
import 'package:trial/resources/search_user_database.dart';
import 'package:trial/screens/meeting_screens/join_call.dart';
import 'package:trial/screens/meeting_screens/meet_popup.dart';
import 'package:trial/screens/meeting_screens/meet_chat.dart';
import 'package:trial/widgets/about.dart';
import 'package:trial/screens/firebaseuser.dart';

List userdata = [];

class RoomChatsPage extends StatefulWidget {
  final String? hostemail;
  final List? members;
  final String? roomName;
  const RoomChatsPage({Key? key, this.hostemail, this.members, this.roomName})
      : super(key: key);

  @override
  RoomChatsPageState createState() => RoomChatsPageState();
}

class RoomChatsPageState extends State<RoomChatsPage> {
  RoomChatsDataManagement pob = RoomChatsDataManagement();

  UserDataManagement udata = UserDataManagement();
  DirectMeetJoin joindirect = DirectMeetJoin();
  InmeetChat inmeetchat = InmeetChat();

  RoomAbout infoobj = RoomAbout();

  final roomChatscrollcontroller = ScrollController();

  var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var time = int.parse(DateFormat("kk").format(DateTime.now()));

  final TextEditingController ptext = TextEditingController();
  final curruser = FirebaseAuth.instance.currentUser!;
  bool textfield = true;
  bool roomChatload = false;

  directjoin(String meetid, BuildContext context) {
    joindirect.onJoin(meetid, context);
    joindirect.updatearray(
        widget.hostemail!, curruser.email!, widget.roomName!, meetid);
    setState(() {
      pdocid = pob.getCurrentDocID(widget.hostemail!, widget.roomName!);
      pfrom = curruser.email!;
      phostemail = widget.hostemail!;
      proomName = widget.roomName!;
    });
  }

  scrolltobottom() {
    if (roomChatscrollcontroller.hasClients) {
      roomChatscrollcontroller
          .jumpTo(roomChatscrollcontroller.position.maxScrollExtent);
    }
  }

  Widget conditionalwidget(String dbdate, int dbtime, String roomChatdata,
      bool ismeetid, bool chatvalid, String docid) {
    if (ismeetid) {
      return SizedBox(
        height: 30,
        width: 80,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Colors.blue,
          ),
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              directjoin(roomChatdata, context);
            },
            icon: const Text(
              "Join",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    } else {
      if (chatvalid) {
        return SizedBox(
          height: 30,
          width: 80,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.blue,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  pdocid =
                      pob.getCurrentDocID(widget.hostemail!, widget.roomName!);
                });
                inmeetchat.bottomchat(context, docid, roomChatdata, false);
              },
              icon: const Text(
                "Meet Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }
    }
    // }
    return Container();
  }

  Widget _roomChatstile() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("rooms")
            .doc(pob.getCurrentDocID(widget.hostemail!, widget.roomName!))
            .collection("roomChats")
            .orderBy("count")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => scrolltobottom());
          if (!snapshot.hasData) return Container();
          return ListView(
            controller: roomChatscrollcontroller,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.black,
                        elevation: 8.0,
                        child: ListTile(
                          leading: FloatingActionButton(
                            backgroundColor: Colors.black,
                            heroTag: document['from'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => UserInfoPage(
                                    useremail: document['from'],
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                udata.returninfo(document['from'], 0),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  document['roomChatdata'],
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                udata.returninfo(document['from'], 1),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: conditionalwidget(
                                    document['date'],
                                    document['time'],
                                    document['roomChatdata'],
                                    document['ismeetid'],
                                    document['chatvalid'],
                                    document.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.indigo[800],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.navigate_before,
            ),
          ),
          title: Row(
            children: [
              Text(
                widget.roomName!,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.members!.length == 1
                    ? "(" + widget.members!.length.toString() + " member)"
                    : "(" + widget.members!.length.toString() + " members)",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              //   ],
              // ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                infoobj.initializebottomsheet(context, widget.members!);
              },
              iconSize: 28,
              alignment: Alignment.centerRight,
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _roomChatstile(),
                ),
                Padding(
                  padding: (!textfield)
                      ? const EdgeInsets.all(30)
                      : const EdgeInsets.all(0),
                  child: Align(
                    alignment: (!textfield)
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                    child: (!textfield)
                        ? FloatingActionButton(
                            backgroundColor: Colors.blue,
                            heroTag: "textfieldshowbutton",
                            onPressed: () {
                              setState(() {
                                textfield = true;
                              });
                            },
                            child: const Icon(
                              Icons.create_outlined,
                            ),
                          )
                        : Container(
                            height: 69,
                            // padding:
                            //     const EdgeInsets.fromLTRB(10, 6, 10, 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 20,
                              color: Colors.indigo[800],
                              child: ListTile(
                                onTap: () {},
                                leading: IconButton(
                                  highlightColor: Colors.indigo[800],
                                  onPressed: () {
                                    setState(() {
                                      pdocid = pob.getCurrentDocID(
                                          widget.hostemail!, widget.roomName!);
                                      pfrom = curruser.email!;
                                      phostemail = widget.hostemail!;
                                      proomName = widget.roomName!;
                                      membersformailing.clear();
                                      membersformailing = widget.members!;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          popup(context),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.video_call_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                title: TextField(
                                  onTap: () {},
                                  controller: ptext,
                                  onChanged: (String str) {},
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
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
                                    if (ptext.text.isNotEmpty) {
                                      pob.getLastCount(
                                        pob.getCurrentDocID(widget.hostemail!,
                                            widget.roomName!),
                                        ptext.text,
                                        curruser.email!,
                                        widget.hostemail!,
                                        widget.roomName!,
                                        false,
                                        date,
                                        time,
                                      );
                                      setState(() {
                                        ptext.clear();
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send_sharp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
