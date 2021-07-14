import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trial/widgets/rooms_messages.dart';

class Searchdatabase {
  final CollectionReference cref =
      FirebaseFirestore.instance.collection('users');

  searchuser(String uname) {
    List searchresult = [];

    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['name']
              .toString()
              .substring(0, uname.length)
              .toLowerCase() ==
          uname.toLowerCase()) {
        searchresult.add(userdata[i]);
      }
    }

    return searchresult;
  }
}
