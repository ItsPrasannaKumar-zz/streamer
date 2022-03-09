import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:streamer/utils/appId.dart';

class Participant extends StatefulWidget {
  final String channelName;
  final String userName;
  const Participant(
      {Key? key, required this.channelName, required this.userName})
      : super(key: key);

  @override
  State<Participant> createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  List<int> _users = [];
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  @override
  void initState() {
    initilizeAgora();
    super.initState();
  }

  Future<void> initilizeAgora() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _client = await AgoraRtmClient.createInstance(appId);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: ((channel, uid, elapsed) {
      setState(() {
        _users.add(uid);
      });
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Particpant")),
    );
  }
}
