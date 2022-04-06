import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamer/pages/director.dart';
import 'package:streamer/pages/participant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _channelNameController = TextEditingController();
  final _userName = TextEditingController();
  late int uid;
  @override
  void initState() {
    getUserUid();
    super.initState();
  }

  Future<void> getUserUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? storedUid = preferences.getInt("localUid");
    if (storedUid != null) {
      uid = storedUid;
    } else {
      //should only happen once,unless they delelte the app
      int time = DateTime.now().microsecondsSinceEpoch;
      uid = int.parse(time.toString().substring(1, time.toString().length - 3));
      preferences.setInt("localUid", uid);
      print("seetingUid: $uid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/streamer.png"),
            SizedBox(
              height: 5,
            ),
            const Text("Multi Streaming with Friends"),
            SizedBox(height: 40),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: _userName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "User Name"),
                )),
            SizedBox(
              height: 8,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: _channelNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "Channel Name"),
                )),
            TextButton(
                onPressed: () async {
                  //takes us to the participant page
                  await [Permission.camera, Permission.microphone].request();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Participant(
                                channelName: _channelNameController.text,
                                userName: _userName.text,
                                uid: uid,
                              )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Participant ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.live_tv)
                  ],
                )),
            TextButton(
                onPressed: () async {
                  //takes us to the director
                  await [Permission.camera, Permission.microphone].request();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Director(
                                channelName: _channelNameController.text,
                                uid: uid,
                              )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Director ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Icon(
                      Icons.cut,
                      color: Colors.black,
                    )
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
