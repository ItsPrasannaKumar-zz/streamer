// ignore_for_file: unused_import

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';

import 'package:flutter/material.dart';
import 'package:streamer/utils/appId.dart';

class Participant extends StatefulWidget {
  final String channelName;
  final String userName;
  final int uid;
  const Participant(
      {Key? key,
      required this.channelName,
      required this.userName,
      required this.uid})
      : super(key: key);

  @override
  State<Participant> createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  List<int> _users = [];
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  bool muted = false;
  bool videoDisabled = false;
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
    //callbacks for the Rtc Engine
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: ((channel, uid, elapsed) {
      setState(() {
        _users.add(uid);
      });
    }), leaveChannel: (stats) {
      setState(() {
        _users.clear();
      });
    }));

    //Callbacks for RTM Client
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerID) {
      print("Private Message from" + peerID + ":" + (message.text));
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      print('connection state changed:' +
          state.toString() +
          'reason' +
          reason.toString());
      if (state == 5) {
        _channel?.leave();
        _client?.logout();
        _client?.destroy();
        print("Logged Out");
      }
    };
    //join the RTM and RTC channels
    await _client?.login(null, widget.uid.toString());
    _channel = await _client?.createChannel(widget.channelName);
    await _channel?.join();
    await _engine.joinChannel(null, widget.channelName, null, widget.uid);

    //callbacks for RTM Channel
    _channel?.onMemberJoined = (AgoraRtmMember member) {
      print("Member Joined:" + member.userId + ", channel " + member.channelId);
    };
    _channel?.onMemberLeft = (AgoraRtmMember member) {
      print("member left" + member.userId + ', channel:' + member.channelId);
    };
    _channel?.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      print("Public Message from" + member.userId + ":" + (message.text));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          _broadcastView(),
          _toolBar(),
        ],
      )),
    );
  }

  Widget _toolBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        RawMaterialButton(
          onPressed: _onToggleMute,
          child: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? Colors.red : Colors.blueAccent,
            size: 20.0,
          ),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: muted ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12.0),
        ),
        RawMaterialButton(
          onPressed: (() => _onCallEnd(context)),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
            size: 35.0,
          ),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.redAccent,
          padding: const EdgeInsets.all(15.0),
        ),
        RawMaterialButton(
          onPressed: _onToggleVideoDisabled,
          child: Icon(
            videoDisabled ? Icons.videocam_off : Icons.videocam,
            color: videoDisabled ? Colors.white : Colors.blueAccent,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: videoDisabled ? Colors.blueAccent : Colors.white,
          padding: EdgeInsets.all(12.0),
        ),
        RawMaterialButton(
          onPressed: _onSwitchCamera,
          child: const Icon(
            Icons.switch_camera,
            color: Colors.blueAccent,
            size: 20.0,
          ),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
        )
      ]),
    );
  }

  Widget _broadcastView() {
    return Expanded(child: RtcLocalView.SurfaceView());
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleVideoDisabled() {
    setState(() {
      videoDisabled = !videoDisabled;
    });
    _engine.muteLocalVideoStream(videoDisabled);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
}
