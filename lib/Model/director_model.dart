import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

class DirectorModel {
  RtcEngine? engine;
  AgoraRtmClient? client;
  AgoraRtmChannel? channel;
  Set<int>? activeUsers;
  Set<int>? lobbyUsers;
  int? localUser;
  DirectorModel(
      {this.engine,
      this.client,
      this.channel,
      this.activeUsers = const {},
      this.lobbyUsers = const {},
      this.localUser});

  DirectorModel copyWith({
    RtcEngine? engine,
    AgoraRtmClient? client,
    AgoraRtmChannel? channel,
    Set<int>? activeUsers,
    Set<int>? lobbyUsers,
    int? localUser,
  }) {
    return DirectorModel(
      engine: engine ?? this.engine,
      client: client ?? this.client,
      channel: channel ?? this.channel,
      activeUsers: activeUsers ?? this.activeUsers,
      lobbyUsers: lobbyUsers ?? this.lobbyUsers,
      localUser: localUser ?? this.localUser,
    );
  }
}
