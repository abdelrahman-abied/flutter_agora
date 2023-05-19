import 'package:flutter/material.dart';
import 'package:flutter_agora/agora_manager.dart';
import 'package:flutter_agora/agora_ui.dart';
import 'package:flutter_agora/audio_call.dart';
import 'package:flutter_agora/video_call.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agora Flutter QuickStart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Join Audio Call'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCall(
                      token: AgoraManager.token,
                      channelName: AgoraManager.channelName,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Join Agora Call'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgoraUiCall(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Create Video Call'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCall(
                      token: AgoraManager.token,
                      channelName: AgoraManager.channelName,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
