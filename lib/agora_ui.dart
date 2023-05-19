import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_agora/agora_manager.dart';

class AgoraUiCall extends StatefulWidget {
  const AgoraUiCall({super.key});

  @override
  State<AgoraUiCall> createState() => _AgoraUiCallState();
}

class _AgoraUiCallState extends State<AgoraUiCall> {
// Instantiate the client
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: AgoraManager.appId,
      channelName: AgoraManager.channelName,
    ),
  );

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(
                client: client,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
