import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial/resources/chat_database_management.dart';
import 'package:trial/screens/chat_screens/chat_page.dart';

class DeleteChat {
  ChatDatabase deleteAChat = ChatDatabase();

  Container _bottomnavigatiomenu(
      BuildContext context, String chatemail, String option) {
    return Container(
      color: Colors.indigo[800],
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.delete_outline_outlined,
              size: 32,
              color: Colors.white,
            ),
            title: const Text(
              "Delete Chat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    deleteChat(context, chatemail, option),
              );
            },
          ),
        ],
      ),
    );
  }

  void showbottombuilder(
      BuildContext context, String chatemail, String optionstring) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.indigo[800],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 70,
          child: _bottomnavigatiomenu(context, chatemail, optionstring),
        );
      },
    );
  }

  Widget deleteChat(BuildContext context, String chatemail, String decider) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.indigo[800],
          title: const Center(
            child: Text(
              'Are you sure you want to delete it?',
              maxLines: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: ButtonTheme(
                                height: 45,
                                minWidth: 100,
                                buttonColor: Colors.lightBlue,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: ButtonTheme(
                                height: 45,
                                minWidth: 100,
                                buttonColor: Colors.lightBlue,
                                child: TextButton(
                                  onPressed: () {
                                    if (decider == "Delete") {
                                      deleteAChat.deleteChat(chatemail);
                                      setState(() {
                                        filterdata.remove(chatemail);
                                      });
                                    } else {
                                      deleteAChat.clearChat(chatemail);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Sure",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
