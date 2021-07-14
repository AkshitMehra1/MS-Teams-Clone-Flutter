import 'package:trial/widgets/rooms_messages.dart';

class UserDataManagement {
  returninfo(String email, int x) {
    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['email'] == email) {
        if (x == 0) return userdata[i]['profilepicurl'];
        if (x == 1) return userdata[i]['name'];
      }
    }
    return "null user";
  }

  returninfobyname(String name, int x) {
    for (int i = 0; i < userdata.length; i++) {
      if (userdata[i]['name'] == name) {
        if (x == 0) return userdata[i]['profilepicurl'];
        if (x == 1) return userdata[i]['email'];
      }
    }
    return "null user";
  }
}
