import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trial/screens/create_room_screen.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController tname = TextEditingController();

  RoomDataManagement dob = RoomDataManagement();
  final CollectionReference crf =
      FirebaseFirestore.instance.collection("users");

  String roomName = "";
  final loginedUser = FirebaseAuth.instance.currentUser!;

  List _userdata = [];
  List _passuserdata = [];

  @override
  void initState() {
    super.initState();
    getusersdata();
  }

  bool loader = false;
  List<bool> checkbox = [];

  getusersdata() async {
    await crf.get().then((vals) {
      for (var els in vals.docs) {
        if (els['email'] != loginedUser.email) {
          setState(() {
            _userdata.add(els.data());
            checkbox.add(false);
          });
        }
      }
    });
    setState(() {
      loader = true;
    });
  }

  Widget _allusers() {
    return ListView.builder(
      itemCount: _userdata.length,
      itemBuilder: (BuildContext context, int index) {
        if (!loader) return Container();
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.white,
            ),
            child: CheckboxListTile(
              tileColor: Colors.indigo[800],
              activeColor: Colors.indigo[800],
              title: Text(
                _userdata[index]['name'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              secondary: CircleAvatar(
                backgroundImage:
                    NetworkImage(_userdata[index]['profilepicurl']),
              ),
              value: checkbox[index],
              onChanged: (bool? newval) {
                setState(() {
                  checkbox[index] = newval!;
                  if (checkbox[index] &&
                      !_passuserdata.contains(_userdata[index])) {
                    _passuserdata.add(_userdata[index]);
                  } else if (!checkbox[index] &&
                      _passuserdata.contains(_userdata[index])) {
                    _passuserdata.remove(_userdata[index]);
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
          ),
        ),
        title: const Text(
          "Create",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 35, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(40, 20, 00, 10),
                    child: TextField(
                      controller: tname,
                      onChanged: (String str) {
                        setState(() {
                          roomName = str;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Room name",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Colors.indigo,
                    ),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if (tname.text.isNotEmpty) {
                          dob.createRooms(
                              roomName, loginedUser.email!, _passuserdata);
                          setState(() {
                            tname.clear();
                          });
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please Enter a Room Name",
                          );
                        }
                      },
                      icon: const Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: const Text(
              "Select Members for the Room",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: _allusers(),
          ),
        ],
      ),
    );
  }
}
