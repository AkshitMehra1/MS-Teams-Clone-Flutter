import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trial/resources/meeting_room_chat_database_management.dart';
import 'package:trial/resources/room_chat_database_management.dart';
import 'package:trial/screens/meeting_screens/call_screen.dart';

class DirectMeetJoin {
  RoomChatsDataManagement pob = RoomChatsDataManagement();
  InmeetChatManagement meetchat = InmeetChatManagement();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
  }

  Future<void> onJoin(String id, BuildContext context) async {
    if (id.isNotEmpty) {
      await _handleCameraAndMic(
        Permission.camera,
      );
      await _handleCameraAndMic(
        Permission.microphone,
      );
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CallConversationPage(
            meetid: id,
          ),
        ),
      );
    }
  }

  updatearray(
      String hostemail, String fromemail, String roomName, String meetid) {
    pob.updatemembersarray(hostemail, fromemail, roomName, meetid);
  }
}
