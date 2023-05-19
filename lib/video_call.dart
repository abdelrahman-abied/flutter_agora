import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_agora/agora_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
  final String token;
  final String channelName;
  const VideoCall({
    required this.token,
    required this.channelName,
  });

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _remoteVideoCaller(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 25,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  int? remoteUid;
  RtcEngine engine = createAgoraRtcEngine();
  initAgora() async {
    await _requestPermision();
    await _initAgoraRtcEngine();
    await _addAgoraEventHandlers();
    await _joinChannel();
  }

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    engine.leaveChannel();
    super.dispose();
  }

  _requestPermision() async {
    await [Permission.microphone, Permission.camera].request();
  }

  _initAgoraRtcEngine() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(
        appId: AgoraManager.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    engine.enableVideo();
    await engine.startPreview();
  }

  _joinChannel() async {
    await engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  _addAgoraEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("remote user $uid joined");
          setState(() {
            remoteUid = uid;
          });
        },
        onUserOffline: (RtcConnection connection, int uId, UserOfflineReasonType reason) {
          debugPrint("remote user $uId left channel");
          setState(() {
            remoteUid = null;
          });
          Navigator.pop(context);
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
  }
  // Display remote user's video

  Widget _remoteVideoCaller() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: AgoraManager.channelName),
        ),
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _localVideoCaller() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }
}
