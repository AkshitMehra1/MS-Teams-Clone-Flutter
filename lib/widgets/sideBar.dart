import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:trial/configs/authentication_methods.dart';
import 'package:trial/screens/firebaseuser.dart';
import 'package:url_launcher/url_launcher.dart';

class Sidenavbar extends StatefulWidget {
  const Sidenavbar({Key? key}) : super(key: key);

  @override
  _SidenavbarState createState() => _SidenavbarState();
}

class _SidenavbarState extends State<Sidenavbar> {
  final loginedUser = FirebaseAuth.instance.currentUser!;
  launchurl(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          height: 400,
          width: 400,
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
          color: Colors.grey[900],
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => UserInfoPage(
                        useremail: loginedUser.email,
                      ),
                    ),
                  );
                },
                dense: true,
                leading: CircleAvatar(
                  maxRadius: 25,
                  backgroundImage: NetworkImage(
                    loginedUser.photoURL!,
                  ),
                ),
                title: Text(
                  "  ${loginedUser.email!}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Engage 2021',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchurl('https://microsoft.acehacker.com/engage2021');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.build_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Source Code Github',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchurl(
                            'https://github.com/AkshitMehra1/MS-Teams-Clone-Flutter');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.bug_report_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Found a bug?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchurl(
                            'https://github.com/AkshitMehra1/MS-Teams-Clone-Flutter/issues');
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'About the Dev',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchurl(
                            'https://www.linkedin.com/in/akshit-mehra-1800b418b/');
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      onTap: () {
                        final provider = Provider.of<Googlesigninprov>(context,
                            listen: false);
                        provider.logoutofapp();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
