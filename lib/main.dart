import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'BasicTest.dart';
import 'VoiceCallwithBluetooth.dart';
import 'VoiceCallwithFirebase.dart';
import 'VoiceCallwithToken.dart';
import 'BasicVoiceCalltwo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'VoiceCallwithVideo.dart';
import 'NotificationsApi.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationsApi.showsoundNotification();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice and Video Call App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Add Voice & Video Call to App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String token = '';
  String channelId = '';

  Future<void> _permissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  @override
  void initState() {
    super.initState();
    _permissions();
    registerNotification();
  }

  void registerNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: true, provisional: false, sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationsApi.showsoundNotification();
      });
    } else {
      _fieldsToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: const Icon(Icons.phone, size: 60, color: Colors.green),
              onTap: () {
                _makeVoiceCall();
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              title: const Icon(Icons.photo_camera_front, size: 60, color: Colors.pink),
              onTap: () {
                _makeVoiceCall();
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              title: const Icon(Icons.chat, size: 60, color: Colors.deepPurple),
              onTap: () {
                _makeVoiceCall();
              },
            ),
          ],
        ),
      ),
    );
  }

  // voice call modal bottomsheet
  void _makeVoiceCall() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 350,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10.0),
            child:  SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Inapp Voice Call'),
                    subtitle: const Text('make inapp voice call with simple dial features (Beginners)'),
                    trailing: const Icon(Icons.phone, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const BasicTest())
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Inapp Voice Call + Redial Page'),
                    subtitle: const Text('make inapp voice call with basic features, timer, auto-end and redial page'),
                    trailing: const Icon(Icons.mobile_friendly, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const BasicVoiceCalltwo())
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Inapp Voice Call + Auto Token'),
                    subtitle: const Text('make inapp voice call with timer, '
                        'auto-end, redial page + auto generated agora token'),
                    trailing: const Icon(Icons.lock_clock, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const VoiceCallwithToken())
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Inapp Voice Call + Firebase'),
                    subtitle: const Text('make inapp voice call with basic features,'
                        ' auto gen token and Firebase '),
                    trailing: const Icon(Icons.local_fire_department, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const VoiceCallwithFirebase())
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Inapp Voice Call + Bluetooth'),
                    subtitle: const Text('make inapp voice call with basic features, '
                        'auto generated token, Firebase + Bluetooth'),
                    trailing: const Icon(Icons.bluetooth, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const VoiceCallwithBluetooth())
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Inapp Voice Call + VideoCall'),
                    subtitle: const Text('make inapp voice call with basic features, '
                        'auto gen token, Firebase + Videocall switch'),
                    trailing: const Icon(Icons.video_call, size: 24, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const VoiceCallwithVideo())
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _fieldsToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Notification Permission is required.'),
        action: SnackBarAction(
            label: 'X', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }


}
