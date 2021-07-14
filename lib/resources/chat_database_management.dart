import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';

String chatTo = "";

// The Functions are pretty much self explanatory

class ChatDatabase {
  final CollectionReference cref2 =
      FirebaseFirestore.instance.collection('chats');

  createNewChat(String loginedUserEmail, String toUserEmail) {
    String docid = loginedUserEmail + toUserEmail;
    Map<String, String> chatNameData = {
      "fromemail ": loginedUserEmail.toString(),
      "toemail": toUserEmail.toString()
    };
    cref2.doc(docid).set(chatNameData);
  }

  existingChatChecker(String from, String to) async {
    var doc = await cref2.doc(from + to).get();
    var doc2 = await cref2.doc(to + from).get();
    if (!(doc.exists || doc2.exists)) {
      createNewChat(from, to);
    }
  }

  final user4 = FirebaseAuth.instance.currentUser!;
  int count = 0;

  createNewMessage(String str1, String str2, String message, int ma) {
    String clname = str1 + str2;
    count = ma + 1;
    cref2.doc(clname).collection("chatMessages").add({
      "message": message,
      "from": user4.email,
      "counter": count,
      "time": DateTime.now(),
    });
  }

  lastMessage(String str1, String str2, String message) async {
    List tempChatGetter = [];
    var doc = await cref2.doc(str1 + str2).get();
    if (doc.exists) {
      await cref2
          .doc((str1 + str2).toString())
          .collection("chatMessages")
          .get()
          .then((values) {
        for (var elements in values.docs) {
          tempChatGetter.add(elements.data());
        }
      });
      int c = 0, max = 0;
      for (int i = 0; i < tempChatGetter.length; i++) {
        c = tempChatGetter[i]['counter'];
        if (c >= max) {
          max = c;
        }
      }
      createNewMessage(str1, str2, message, max);
    } else {
      await cref2
          .doc((str2 + str1).toString())
          .collection("chatMessages")
          .get()
          .then((values) {
        for (var elements in values.docs) {
          tempChatGetter.add(elements.data());
        }
      });
      int c = 0, max = 0;
      for (int i = 0; i < tempChatGetter.length; i++) {
        c = tempChatGetter[i]['counter'];
        if (c >= max) {
          max = c;
        }
      }
      createNewMessage(str2, str1, message, max);
    }
  }

  deleteChat(String chatemail) async {
    String docid1 = user4.email! + chatemail;
    String docid2 = chatemail + user4.email!;
    var doc = await cref2.doc(docid1).get();

    cref2.doc((doc.exists) ? docid1 : docid2).delete();
  }

  clearChat(String chatemail) async {
    String d1 = user4.email! + chatemail;
    String d2 = chatemail + user4.email!;
    var document = await cref2.doc(d1).get();
    cref2
        .doc((document.exists) ? d1 : d2)
        .collection("chatMessages")
        .get()
        .then((deleteValues) {
      for (var e in deleteValues.docs) {
        e.reference.delete();
      }
    });
  }
}
