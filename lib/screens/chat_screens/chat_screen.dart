import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/resources/chat_database_management.dart';
import 'package:trial/resources/search_user_database.dart';
import 'package:trial/screens/firebaseuser.dart';
import 'package:emoji_picker/emoji_picker.dart';

import 'delete_popup.dart';

class ConversationPage extends StatefulWidget {
  final String? receivername;
  const ConversationPage({Key? key, this.receivername}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

bool isWriting = false;
String getonpressemail = "";

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController chattext = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  final scontrol = ScrollController();
  bool scroller = false;
  bool loaded = false;

  ChatDatabase obj = ChatDatabase();
  final user3 = FirebaseAuth.instance.currentUser!;
  final CollectionReference cref4 =
      FirebaseFirestore.instance.collection('chats');

  UserDataManagement user = UserDataManagement();
  DeleteChat clearChat = DeleteChat();

  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    checks(getonpressemail);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  String? text = "";

  String collectionname = "";

  checks(String tomail) async {
    String fromail = user3.email.toString();
    var docid1 = await cref4.doc(fromail + tomail).get();
    if (docid1.exists) {
      setState(() {
        collectionname = fromail + tomail;
      });
    } else {
      setState(() {
        collectionname = tomail + fromail;
      });
    }
    setState(() {
      loaded = true;
    });
  }

  scrolltobottom() {
    if (scontrol.hasClients) scontrol.jumpTo(scontrol.position.maxScrollExtent);
  }

  Widget _chattile() {
    if (!loaded) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(collectionname)
              .collection("chatMessages")
              .orderBy("counter")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            WidgetsBinding.instance
                ?.addPostFrameCallback((_) => scrolltobottom());
            if (!snapshot.hasData) return Container();
            return ListView(
              controller: scontrol,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment:
                        document['from'] == user3.email.toString()
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
                            bottomLeft:
                                document['from'] == user3.email.toString()
                                    ? const Radius.circular(25)
                                    : const Radius.circular(0),
                            bottomRight:
                                document['from'] == user3.email.toString()
                                    ? const Radius.circular(0)
                                    : const Radius.circular(25),
                          ),
                        ),
                        child: Text(
                          document['message'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        shadowColor: Colors.lightBlue[200],
        title: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => UserInfoPage(
                      useremail: user.returninfobyname(widget.receivername!, 1),
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.returninfobyname(widget.receivername!, 0),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.receivername!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              clearChat.showbottombuilder(context,
                  user.returninfobyname(widget.receivername!, 1), "Delete");
            },
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _chattile(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 62,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                elevation: 0,
                color: Colors.indigo[800],
                child: ListTile(
                  leading: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      focusNode.unfocus();
                      focusNode.canRequestFocus = false;
                      setState(() {
                        showEmojiPicker = !showEmojiPicker;
                      });
                    },
                    icon: const Icon(Icons.emoji_emotions_rounded),
                  ),
                  title: TextFormField(
                    focusNode: focusNode,
                    onTap: () {},
                    controller: chattext,
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
                      if (chattext.text.isNotEmpty) {
                        String lu = user3.email.toString();
                        obj.lastMessage(lu, chatTo, chattext.text);
                      }

                      setState(() {
                        chattext.clear();
                      });
                    },
                    icon: const Icon(Icons.send_sharp),
                  ),
                ),
              ),
            ),
          ),
          showEmojiPicker ? emojiContainer() : Container(),
        ],
      ),
    );
  }

  Widget emojiContainer() {
    return EmojiPicker(
      bgColor: const Color.fromRGBO(0, 0, 0, 1),
      indicatorColor: const Color.fromRGBO(0, 0, 0, 1),
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        chattext.text = chattext.text + emoji.emoji;
      },
      recommendKeywords: const ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }
}
