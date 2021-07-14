import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/resources/room_chat_database_management.dart';
import 'package:trial/screens/create_room_screen.dart';
import 'package:trial/widgets/rooms_messages.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  RoomDataManagement dataobject = RoomDataManagement();
  RoomChatsDataManagement pob = RoomChatsDataManagement();

  StreamSubscription? subs;
  bool connection = true;

  List _roomslist = [];

  @override
  void initState() {
    super.initState();
    getdata();
    getdataforuser();

    subs = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        connection = (event != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    subs?.cancel();
    super.dispose();
  }

  getdataforuser() async {
    userdata = await pob.getuserdata();
  }

  bool loader = false;

  Future<Null> getdata() async {
    setState(() {
      _roomslist.clear();
    });

    _roomslist = await dataobject.getRooms();

    setState(() {
      loader = true;
    });

    getdataforuser();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: _roomlistview(),
      ),
    );
  }

  Widget _roomlistview() {
    if (!loader) {
      return Center(
        child: RefreshProgressIndicator(
          color: Colors.indigo.shade800,
        ),
      );
    }
    return RefreshIndicator(
      color: Colors.indigo,
      backgroundColor: Colors.black,
      onRefresh: getdata,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 0,
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _roomslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        onPressed: null,
                        child: Card(
                          color: Colors.black,
                          child: ListTile(
                            // onLongPress: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => RoomChatsPage(
                                    hostemail: _roomslist[index]['host'],
                                    members: _roomslist[index]['membersemail'],
                                    roomName: _roomslist[index]['roomName'],
                                  ),
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 35,
                            ),
                            title: Text(
                              _roomslist[index]['roomName'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text(
                              'Room',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
