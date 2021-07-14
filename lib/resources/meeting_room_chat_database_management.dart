import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trial/screens/meeting_screens/meet_popup.dart';

class InmeetChatManagement {
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("rooms");

  final user = FirebaseAuth.instance.currentUser!;

  String getCurrentDocID(String host, String roomName) {
    return host + roomName;
  }

  createNewChat(int count, String message, String meetid, bool behav) {
    cref
        .doc(pdocid)
        .collection("roomChats")
        .where("ismeetid", isEqualTo: behav)
        .where("roomChatdata", isEqualTo: meetid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        // print("point");
        cref
            .doc(pdocid)
            .collection("roomChats")
            .doc(element.id)
            .collection("inmeetchat")
            .add({
          "counter": count,
          "from": user.email,
          "message": message,
        });
      }
    });
  }

  Future<String> returndocid(String meetid) async {
    String ans = "";
    await cref
        .doc(pdocid)
        .collection("roomChats")
        .where("ismeetid", isEqualTo: true)
        .where("roomChatdata", isEqualTo: meetid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        // print(element.id);
        ans = element.id;
      }
    });
    return ans;
  }

  getLastCount(String meetid, String message, bool behav) async {
    int count = 0;
    bool check = false;

    await cref
        .doc(pdocid)
        .collection("roomChats")
        .where("ismeetid", isEqualTo: behav)
        .where("roomChatdata", isEqualTo: meetid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        cref
            .doc(pdocid)
            .collection("roomChats")
            .doc(element.id)
            .collection("inmeetchat")
            .orderBy("counter", descending: true)
            .get()
            .then((vals) {
          for (var ele in vals.docs) {
            count = ele['counter'];
            if (!check) createNewChat(count + 1, message, meetid, behav);
            check = true;
          }
        });
      }
    });
  }
}
