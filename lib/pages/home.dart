import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              onPressed: () {
                //takes us to the participant page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Participant(
                              channelName: _channelNameController.text,
                              userName: _userName.text,
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
              onPressed: () {
                //takes us to the director
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Director(
                              channelName: _channelNameController.text,
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
      )),
    );
  }
}
