import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';


class VoiceCallwithVideox extends StatefulWidget {

  final String token;
  final String channelId;

  const VoiceCallwithVideox(this.token, this.channelId, {Key? key}): super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VoiceCallwithVideox> {
  String appId = 'agora_app_id';
  String channelId = 'your_channel_name';
  String token = 'agora_app_token';

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "c42fa8688c484cafa46a0f50984329be",
      channelName: "basicvoicecall",
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
              ),
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