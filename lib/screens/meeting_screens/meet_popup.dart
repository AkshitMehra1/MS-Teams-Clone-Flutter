import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trial/resources/meeting_room_chat_database_management.dart';
import 'package:trial/resources/room_chat_database_management.dart';

import 'call_screen.dart';

String pdocid = "";
String pfrom = "";
String phostemail = "";
String proomName = "";
List membersformailing = [];
bool sendmail = false;

Widget popup(BuildContext context) {
  final _channelController = TextEditingController(text: "");

  RoomChatsDataManagement roomChatobj = RoomChatsDataManagement();
  InmeetChatManagement meetc = InmeetChatManagement();

  bool _validateError = false;

  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
  }

  var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var time = int.parse(DateFormat("kk").format(DateTime.now()));

  Future<void> onJoin() async {
    _channelController.text.isEmpty
        ? _validateError = true
        : _validateError = false;

    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      bool ch =
          await roomChatobj.checkifmeetexists(pdocid, _channelController.text);
      if (!ch) {
        roomChatobj.getLastCount(pdocid, _channelController.text, pfrom,
            phostemail, proomName, true, date, time);
        meetc.createNewChat(
            1, "Beginning of Chat", _channelController.text, true);
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CallConversationPage(
              meetid: _channelController.text,
            ),
          ),
        );
        _channelController.clear();
      } else {
        Fluttertoast.showToast(
          msg: "Meeting Room name already exists!",
        );
      }
    }
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text(
            'Meeting Room Name',
            style: TextStyle(
              color: Colors.white,
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
                  TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Meeting Room Name..',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    controller: _channelController,
                    onChanged: (String str) {},
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: ButtonTheme(
                          height: 45,
                          minWidth: 100,
                          buttonColor: Colors.indigo[800],
                          child: ElevatedButton(
                            onPressed: onJoin,
                            child: const Text(
                              "Create Room",
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
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
