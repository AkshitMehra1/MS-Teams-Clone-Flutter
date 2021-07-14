import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trial/resources/room_chat_database_management.dart';
import 'package:trial/screens/meeting_screens/meet_popup.dart';
import 'package:trial/screens/meeting_screens/meet_chat.dart';
import 'package:trial/configs/agora_configs.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class CallConversationPage extends StatefulWidget {
  final String? meetid;

  const CallConversationPage({Key? key, this.meetid}) : super(key: key);

  @override
  _CallConversationPageState createState() => _CallConversationPageState();
}

class _CallConversationPageState extends State<CallConversationPage> {
  final cuser = FirebaseAuth.instance.currentUser;

  RtcEngine? agoraengine;
  List<int> meetpeople = [];

  RoomChatsDataManagement pobj = RoomChatsDataManagement();
  InmeetChat chatconnect = InmeetChat();

  bool mutestatus = false;
  String nextdoc = "";

  @override
  void initState() {
    super.initState();
    startvideoengine();
    getnextdocid(widget.meetid!);
  }

  getnextdocid(String meetid) async {
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(pdocid)
        .collection("roomChats")
        .where("ismeetid", isEqualTo: true)
        .where("roomChatdata", isEqualTo: meetid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        setState(() {
          nextdoc = element.id;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    agoraengine!.destroy();
    meetpeople.clear();
  }

  Future<void> initializeengine() async {
    agoraengine = await RtcEngine.create(appID);
    await agoraengine!.enableVideo();
    await agoraengine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await agoraengine!.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> startvideoengine() async {
    await initializeengine();
    _addAgoraEventHandlers();
    await agoraengine!.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration config = VideoEncoderConfiguration();
    config.dimensions = VideoDimensions(1920, 1080);
    await agoraengine!.setVideoEncoderConfiguration(config);
    await agoraengine!.joinChannel(null, widget.meetid!, null, 0);
  }

  void _addAgoraEventHandlers() {
    agoraengine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {});
      },
      leaveChannel: (stats) {
        setState(() {
          meetpeople.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          meetpeople.add(uid);
          Fluttertoast.showToast(msg: uid.toString() + " Joined");
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          meetpeople.remove(uid);
        });
      },
    ));
  }

  endcall(BuildContext context) {
    if (pfrom == cuser?.email) {
      pobj.updatemeetstatus(widget.meetid!, pdocid, phostemail, pfrom);
    }
    Navigator.pop(context);
  }

  switchcamera() {
    agoraengine!.switchCamera();
  }

  mutetoggle() {
    setState(() {
      mutestatus = !mutestatus;
    });
    agoraengine!.muteLocalAudioStream(mutestatus);
  }

  List<Widget> getliveviews() {
    final List<StatefulWidget> memlist = [];
    setState(() {
      memlist.add(rtc_local_view.SurfaceView());
    });
    for (var userid in meetpeople) {
      memlist.add(rtc_remote_view.SurfaceView(uid: userid));
    }
    return memlist;
  }

  Widget videoUI(view) {
    return Expanded(
      child: Container(
        child: view,
      ),
    );
  }

  Widget videoView(List<Widget> allviews) {
    final totalwrappedviews = allviews.map<Widget>(videoUI).toList();
    return Expanded(
      child: Row(
        children: totalwrappedviews,
      ),
    );
  }

  Widget meetpeopleview() {
    final totviews = getliveviews();
    switch (totviews.length) {
      case 1:
        return Column(
          children: <Widget>[
            videoUI(totviews[0]),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            videoView([totviews[0]]),
            videoView([totviews[1]]),
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            videoView(totviews.sublist(0, 2)),
            videoView(totviews.sublist(2, 3)),
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            videoView(totviews.sublist(0, 2)),
            videoView(totviews.sublist(2, 4)),
          ],
        );
      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
          ),
        ),
        title: Text(
          widget.meetid!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              chatconnect.bottomchat(context, nextdoc, widget.meetid!, true);
            },
            icon: const Icon(
              Icons.chat,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          meetpeopleview(),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  heroTag: "camerawsitcher",
                  onPressed: () {
                    switchcamera();
                  },
                  child: const Icon(
                    Icons.switch_camera_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  heroTag: "callendbutton",
                  onPressed: () {
                    endcall(context);
                  },
                  child: const Icon(
                    Icons.call_end_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  heroTag: "mutetoggle",
                  onPressed: () {
                    mutetoggle();
                  },
                  child: Icon(
                    (mutestatus) ? Icons.mic_off_outlined : Icons.mic_outlined,
                    color: Colors.white,
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
