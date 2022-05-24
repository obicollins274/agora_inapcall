import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'NoAnswerwithToken.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class VoiceCallwithToken extends StatefulWidget {
  const VoiceCallwithToken({Key? key}): super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VoiceCallwithToken> {
  final _users = <int>[];
  RtcEngine? _engine;
  bool isJoined = false;
  bool openMicrophone = true;
  bool enableSpeakerphone = true;
  bool playEffect = false;
  int uid = 0;
  String stringUid = '0';
  String joinMessage = 'Calling';
  AudioPlayer player = AudioPlayer();
  String appId = 'agora_app_id';
  String channelId = '';
  String token = '';
  Timer? _timer;
  int _start = 1;

  // use these functions to add dialing tone
  Future<ByteData> _loadAsset() async {
    return await rootBundle.load('assets/audio/dialtone.mp3');
  }

  Future<void> playSound() async {
    final file = File('${(await getTemporaryDirectory()).path}/dialtone.mp3');
    await file.writeAsBytes((await _loadAsset()).buffer.asUint8List());
    await player.play(file.path, isLocal: true);
    await player.setVolume(0.3);
  }

  Future<void> stopSound() async {
    await player.stop();
  }

  // use the functions to toggle between Microphones & SpeakerPhones
  void _switchMicrophone() {
    setState(() {
      openMicrophone = !openMicrophone;
    });
    _engine!.enableLocalAudio(openMicrophone);
  }

  void _switchSpeakerphone() {
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
    _engine!.setEnableSpeakerphone(!enableSpeakerphone);
  }

  void _onCallEnd(BuildContext context) {
    stopSound();
    Navigator.pop(context);
  }

  // agora RTC SDK
  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addAgoraEventHandlers();
    await _engine!.enableAudio();
    await _engine!.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine!.setClientRole(ClientRole.Broadcaster);
  }

  void _joinChannel() async {
    await _engine?.joinChannel(token, channelId, null, uid)
        .catchError((onError) {
    });
  }

  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(
        RtcEngineEventHandler(
            joinChannelSuccess: (channel, uid, elapsed) {
              setState(() {
                playSound();
                joinMessage = 'Ringing';
              });
            }, leaveChannel: (stats) {
          setState(() {
            stopSound();
            joinMessage = 'Disconnected';
            _users.clear();
            Navigator.pop(context);
          });
        }, userJoined: (uid, elapsed) {
          setState(() {
            stopSound();
            _startTimer();
            joinMessage = 'Connected';
            _users.add(uid);
            _start = 1;
          });
        }, userOffline: (uid, elapsed) {
          setState(() {
            stopSound();
            joinMessage = 'Disconnected';
            _users.remove(uid);
            Navigator.pop(context);
          });
        })
    );
  }

  // generate agora token per call session
  Future<void> _getAgoraToken() async {
    channelId = 'voicecall' + DateTime.now().millisecondsSinceEpoch.toString();
    final xresponse = await http.post(
        Uri.parse("https://rahabyte.com/inappcall/agora/tokenBuilder.php"), body: {
      "channelId": channelId,
    });
    var data = jsonDecode(xresponse.body);
    setState(() {
      token = data['token'].toString();
    });
  }

  // adjust ringing time
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) =>
        setState(
              () {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start + 1;
            }
          },
        ),
    );
  }

  Future<void> _ringTime() async {
    if (_start >= 35 && joinMessage == 'Ringing') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NoAnswerwithToken()));
      });
    }
  }

  // formated time when call connects
  String _formatedTime(int secTime) {
    String getParsedTime(String time) {
      return time;
    }
    int min = secTime ~/ 60;
    int sec = secTime % 60;
    String parsedTime = getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());
    return parsedTime;
  }

  Widget _showTimer() {
    if (joinMessage == 'Connected') {
      return Text(_formatedTime(_start),
          style: const TextStyle(fontSize: 16, color: Colors.white,
              fontWeight: FontWeight.w900), textAlign: TextAlign.center);
    }
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    _getAgoraToken();
    _loadAsset();
    _initEngine();
    _startTimer();
    _ringTime();

    // you have to generate the token before you join the channel
    Future.delayed(const Duration(seconds: 3), () {
      _joinChannel();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _engine!.destroy();
    _users.clear();
    _engine!.leaveChannel();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: _ringTime(),
              builder: (context, snapshot) {
                return const SizedBox();
              }
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueGrey,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              child: Column(
                  children: <Widget>[
                    const SizedBox(height:100),
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/avatar.png"),
                          ),
                          Positioned(
                              bottom: 0,
                              right: -25,
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 1.0,
                                fillColor: Colors.white,
                                child: const Icon(Icons.camera_alt_outlined, color: Colors.blueGrey),
                                padding: const EdgeInsets.all(10.0),
                                shape: const CircleBorder(),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height:20),
                    const Text('Client Name', style: TextStyle(fontSize: 24, color: Colors.white,
                        fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                    const SizedBox(height:10),
                    Text(joinMessage, style: const TextStyle(fontSize: 16, color: Colors.white,
                        fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                    _showTimer(),
                  ]
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width*0.80,
              height: 80,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              color: Colors.blueGrey,
              child: Row(
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                          onTap: () {
                            _switchMicrophone();
                          },
                          child: openMicrophone ?
                          const Icon(Icons.mic_off, color: Colors.blueGrey) :
                          const Icon(Icons.mic, color: Colors.green)
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child:FloatingActionButton(
                        onPressed: () {
                          _onCallEnd(context);
                        },
                        backgroundColor: Colors.pink,
                        child: const Icon(Icons.phone, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                          onTap: () async {
                            await player.setVolume(1.0);
                            _switchSpeakerphone();
                          },
                          child: enableSpeakerphone ?
                          const Icon(Icons.volume_up, color: Colors.blueGrey) :
                          const Icon(Icons.volume_up, color: Colors.green)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}