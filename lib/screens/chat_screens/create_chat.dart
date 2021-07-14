import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/screens/chat_screens/chat_screen.dart';
import 'package:trial/resources/chat_database_management.dart';
import 'package:trial/resources/start_chat_database.dart';
import 'package:trial/screens/firebaseuser.dart';
import 'package:trial/resources/search_user_database.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  final TextEditingController stext = TextEditingController();

  final user2 = FirebaseAuth.instance.currentUser!;
  bool searchcheck = false;

  Searchdatabase sear = Searchdatabase();
  ChatDatabase chatman = ChatDatabase();

  List searchdata = [];
  getsearchdata(String st) {
    searchdata = sear.searchuser(st);
  }

  UserDataManagement user = UserDataManagement();
  Widget _searchresult() {
    if (searchdata.isEmpty) {
      if (searchcheck) {
        return Container(
          alignment: Alignment.topCenter,
          child: const RefreshProgressIndicator(
            color: Colors.indigo,
            backgroundColor: Colors.black,
          ),
        );
      } else {
        return Container();
      }
    } else {
      return ListView.builder(
        itemCount: searchdata.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(0, 6, 10, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 20,
              color: Colors.indigo[800],
              child: ListTile(
                leading: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: searchdata[index]['email'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => UserInfoPage(
                          useremail: searchdata[index]['email'],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage(
                      searchdata[index]['profilepicurl'],
                    ),
                  ),
                ),
                title: Text(
                  searchdata[index]['name'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  searchdata[index]['email'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    chatman.existingChatChecker(
                        user2.email.toString(), searchdata[index]['email']);
                    setState(() {
                      chatTo = searchdata[index]['email'];
                      getonpressemail = searchdata[index]['email'];
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationPage(
                          receivername:
                              user.returninfo(searchdata[index]['email'], 1),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chat,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: const Text(
          "Users",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: stext,
                    onChanged: (String str) {
                      getsearchdata(str);
                      if (str.isNotEmpty) {
                        setState(() {
                          searchcheck = true;
                        });
                      } else {
                        setState(() {
                          searchcheck = false;
                        });
                      }
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Search by entering the name",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _searchresult(),
          ),
        ],
      ),
      // ),
    );
  }
}
