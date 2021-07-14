import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/resources/search_user_database.dart';
import 'package:trial/screens/firebaseuser.dart';

class RoomAbout {
  UserDataManagement info = UserDataManagement();

  initializebottomsheet(context, List members) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 30),
          color: Colors.black,
          height: 300,
          // color: Colors.grey[900],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Text(
                  "Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                height: 200,
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      tileColor: Colors.indigo[800],
                      leading: FloatingActionButton(
                        backgroundColor: Colors.indigo[800],
                        heroTag: members[index].toString(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserInfoPage(
                                useremail: members[index],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            info.returninfo(members[index], 0),
                          ),
                        ),
                      ),
                      title: Text(
                        info.returninfo(members[index], 1),
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: Text(
                        members[index],
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
