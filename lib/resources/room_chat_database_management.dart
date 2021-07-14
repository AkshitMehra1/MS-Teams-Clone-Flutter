import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChatsDataManagement {
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("rooms");

  createroomChat(String roomChatmsg, String fromemail, String hostemail,
      String roomName, int count, bool ismeetid, String date, int time) {
    cref.doc(getCurrentDocID(hostemail, roomName)).collection("roomChats").add({
      "from": fromemail,
      "roomChatdata": roomChatmsg,
      "count": count,
      "ismeetid": ismeetid,
      "chatvalid": ismeetid,
      "date": date,
      "time": time,
    });

    if (ismeetid)
      updatemembersarray(hostemail, fromemail, roomName, roomChatmsg);
  }

  updatemembersarray(
      String hostemail, String fromemail, String roomName, String meetid) {
    cref
        .doc(getCurrentDocID(hostemail, roomName))
        .collection("roomChats")
        .where("roomChatdata", isEqualTo: meetid)
        .where("ismeetid", isEqualTo: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        cref
            .doc(getCurrentDocID(hostemail, roomName))
            .collection("roomChats")
            .doc(element.id)
            .update({
          "inmeet": FieldValue.arrayUnion([fromemail]),
        });
      }
    });
  }

  getLastCount(
      String docid,
      String roomChatmsg,
      String fromemail,
      String hostemail,
      String roomName,
      bool ismeetid,
      String date,
      int time) async {
    int count = 0;
    await cref
        .doc(docid)
        .collection("roomChats")
        .orderBy("count")
        .get()
        .then((value) {
      for (var element in value.docs) {
        count = element['count'];
      }
    });

    createroomChat(roomChatmsg, fromemail, hostemail, roomName, count + 1,
        ismeetid, date, time);
  }

  String getCurrentDocID(String hostemail, String roomName) {
    return hostemail + roomName;
  }

  Future<bool> checkifmeetexists(String docid, String roomChatmsg) async {
    bool check = false;

    await cref
        .doc(docid)
        .collection("roomChats")
        .where("roomChatdata", isEqualTo: roomChatmsg)
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element['ismeetid']) {
          check = true;
        }
      }
    });

    return check;
  }

  Future<List> getuserdata() async {
    List _alluserdata = [];
    await FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        _alluserdata.add(element.data());
      }
    });
    return _alluserdata;
  }

  updatemeetstatus(
      String meetid, String docid, String hostemail, String from) async {
    await cref
        .doc(docid)
        .collection("roomChats")
        .where("from", isEqualTo: from)
        .where("roomChatdata", isEqualTo: meetid)
        .get()
        .then((vals) {
      for (var element in vals.docs) {
        FirebaseFirestore.instance
            .collection("rooms")
            .doc(docid)
            .collection("roomChats")
            .doc(element.id)
            .update({'ismeetid': false});
      }
    });
  }
}
