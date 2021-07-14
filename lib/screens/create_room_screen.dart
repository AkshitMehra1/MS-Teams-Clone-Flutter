import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomDataManagement {
  final CollectionReference cref3 =
      FirebaseFirestore.instance.collection("rooms");

  final cuser = FirebaseAuth.instance.currentUser;

  String docname(String str1, String str2) {
    return str1 + str2;
  }

  Future<bool> presentcheck(String docname, String hostemail) async {
    var doc = await cref3.doc(docname).get();
    return (doc.exists && doc['host'] == cuser?.email) ? false : true;
  }

  createRooms(String roomName, String hostemail, List members) async {
    if (await presentcheck(docname(hostemail, roomName), hostemail)) {
      cref3.doc(docname(hostemail, roomName)).set({
        "host": hostemail,
        "roomName": roomName,
      });

      for (int i = 0; i < members.length; i++) {
        cref3.doc(docname(hostemail, roomName)).update({
          "membersemail": FieldValue.arrayUnion([members[i]['email']]),
        });
      }
      Fluttertoast.showToast(
        msg: "Room Created..",
        backgroundColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Room Already Exists",
        backgroundColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  List _templist1 = [];
  List _templist2 = [];
  List _listofrooms = [];

  Future<List> getRooms() async {
    List _templist = [];

    await cref3.get().then((value) {
      for (var element in value.docs) {
        if (element['host'] == cuser?.email) {
          _listofrooms.add(element.data());
        } else {
          _templist.add(element.data());
        }
      }
    });
    for (int i = 0; i < _templist.length; i++) {
      for (int j = 0; j < _templist[i]['membersemail'].length; j++) {
        if (_templist[i]['membersemail'][j] == cuser?.email) {
          _listofrooms.add(_templist[i]);
        }
      }
    }

    return _listofrooms;
  }

  List returnseparatedlist(bool check) {
    _templist1.clear();
    _templist2.clear();
    for (int i = 0; i < _listofrooms.length; i++) {
      if (_listofrooms[i]['host'] == cuser?.email) {
        _templist1.add(_listofrooms[i]);
      } else {
        _templist2.add(_listofrooms[i]);
      }
    }

    return check ? _templist1 : _templist2;
  }
}
